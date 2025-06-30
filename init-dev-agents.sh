#!/bin/bash

# DeepCluade - 专业开发流程多Agent协作框架初始化脚本
# 用于创建项目结构和配置文件

echo "================================================"
echo "DeepCluade - 多Agent协作框架初始化"
echo "================================================"
echo ""

# 检查当前目录
if [ -d ".agents" ] || [ -d "agents" ]; then
    echo "警告：检测到已存在的agents目录"
    read -p "是否要继续？这将覆盖现有配置 (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "初始化已取消"
        exit 0
    fi
fi

# 获取前端和后端目录配置
echo "请配置代码目录："
echo ""
read -p "请输入前端代码目录名称 (默认: src): " frontend_dir
frontend_dir=${frontend_dir:-src}

read -p "请输入后端代码目录名称 (默认: server): " backend_dir  
backend_dir=${backend_dir:-server}

echo ""
echo "配置确认："
echo "- 前端目录: $frontend_dir"
echo "- 后端目录: $backend_dir"
echo ""

# 创建基础目录结构
echo "创建基础目录结构..."

# 创建.claude目录和命令文件
mkdir -p .claude/commands

# 创建.agents目录结构
mkdir -p .agents/{_workflow/{tasks,reviews,reports},_communication/{architect,developer,tester,reviewer},_permissions/pending,_status}

# 创建agents目录结构
teams=("frontend" "backend")
roles=("architect" "developer" "tester" "reviewer")

for team in "${teams[@]}"; do
    for role in "${roles[@]}"; do
        mkdir -p "agents/$team/$role/.claude"
        mkdir -p "agents/$team/$role/workspace"
        
        # 为特定角色创建额外目录
        case $role in
            "architect")
                mkdir -p "agents/$team/$role/designs"
                ;;
            "tester")
                mkdir -p "agents/$team/$role/test-plans"
                mkdir -p "agents/$team/$role/test-results"
                ;;
            "reviewer")
                mkdir -p "agents/$team/$role/reviews"
                ;;
        esac
    done
done

# 创建tests和docs目录（如果不存在）
mkdir -p tests docs

# 创建配置文件
echo "创建配置文件..."

# 创建目录配置文件
cat > .agents/config.json << EOF
{
  "frontend_dir": "$frontend_dir",
  "backend_dir": "$backend_dir",
  "teams": {
    "frontend": {
      "architect": "agents/frontend/architect",
      "developer": "agents/frontend/developer",
      "tester": "agents/frontend/tester",
      "reviewer": "agents/frontend/reviewer"
    },
    "backend": {
      "architect": "agents/backend/architect",
      "developer": "agents/backend/developer",
      "tester": "agents/backend/tester",
      "reviewer": "agents/backend/reviewer"
    }
  },
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": "1.0.0"
}
EOF

# 创建权限配置文件
cat > .agents/permissions.json << EOF
{
  "roles": {
    "architect": {
      "read": ["*"],
      "write": ["self", "docs/architecture/**", "_workflow/tasks/**", "_communication/**"],
      "create": ["designs/**", "workspace/**"]
    },
    "developer": {
      "read": ["*"],
      "write": ["self", "$frontend_dir/**", "$backend_dir/**", "_workflow/tasks/**", "_communication/**"],
      "create": ["workspace/**"]
    },
    "tester": {
      "read": ["$frontend_dir/**", "$backend_dir/**", "tests/**", "docs/**"],
      "write": ["self", "_workflow/tasks/**", "_communication/**"],
      "create": ["test-plans/**", "test-results/**", "workspace/**"]
    },
    "reviewer": {
      "read": ["*"],
      "write": ["self", "_workflow/reviews/**", "_communication/**"],
      "create": ["reviews/**", "workspace/**"]
    }
  },
  "special_permissions": {
    "temporary_write": {
      "duration": "1h",
      "requires_approval": true
    }
  }
}
EOF

# 创建示例任务文件
cat > .agents/_workflow/tasks/TASK-EXAMPLE.json << EOF
{
  "id": "TASK-EXAMPLE",
  "type": "example",
  "team": "frontend",
  "status": "pending",
  "assigned_to": null,
  "description": "这是一个示例任务",
  "requirements": [
    "这是一个示例，实际使用时会被真实任务替换"
  ],
  "created_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

# 创建README文件
cat > .agents/README.md << EOF
# DeepCluade Agent工作区

这是DeepCluade框架的Agent工作区，用于多Agent协作开发。

## 目录说明

- \`_workflow/\` - 工作流控制
  - \`tasks/\` - 任务队列
  - \`reviews/\` - 审核队列  
  - \`reports/\` - 报告存储
- \`_communication/\` - Agent间通信
- \`_permissions/\` - 权限管理
- \`_status/\` - 状态追踪

## 配置文件

- \`config.json\` - 目录配置
- \`permissions.json\` - 权限配置

## 使用说明

1. 管理Agent通过创建任务文件来分配工作
2. 各Agent读取任务并在自己的工作区工作
3. 通过通信目录交换消息
4. 需要额外权限时创建权限请求
EOF

# 设置脚本权限
chmod +x init-dev-agents.sh

echo ""
echo "✅ 初始化完成！"
echo ""
echo "目录结构已创建："
echo "- .claude/          # Claude Code配置"
echo "- .agents/          # 框架配置和工作流"
echo "- agents/           # Agent工作区"
echo ""
echo "下一步："
echo "1. 运行 'claude' 启动管理Agent"
echo "2. 使用 '/init-frontend' 或 '/init-backend' 初始化团队"
echo "3. 使用 '/assign' 分配任务"
echo ""
echo "详细使用说明请参考设计文档"