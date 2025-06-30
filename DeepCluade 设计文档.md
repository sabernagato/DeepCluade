# 专业开发流程多Agent协作框架

## 概述

这是一个基于文件系统的 Claude Code 多Agent协作框架，通过角色分工（架构师、程序员、测试员、审核员）实现专业的开发流程，解决单一 Claude Code 实例的上下文污染问题。

## 核心特性

- **角色专业化**：架构师设计、程序员实现、测试员验证、审核员把关
- **上下文隔离**：每个Agent在独立目录工作，避免相互干扰
- **灵活的权限系统**：默认只读，需要时申请写权限
- **双向通信**：基于文件系统的消息传递机制
- **自定义目录**：支持用户定义前端和后端代码目录

## 系统架构

```
project/                         # 主项目目录
├── [前端目录]/                  # 用户自定义前端代码目录
├── [后端目录]/                  # 用户自定义后端代码目录
├── tests/                       # 测试文件
├── docs/                        # 文档
├── .claude/
│   ├── orchestrator.md          # 总管理Agent配置
│   └── commands/                # 自定义命令
│       ├── init-frontend.md     # 初始化前端团队
│       ├── init-backend.md      # 初始化后端团队
│       ├── assign.md            # 分配任务
│       ├── review.md            # 查看审核结果
│       ├── report.md            # 生成进度报告
│       ├── grant-write.md       # 处理写权限请求
│       └── permission-status.md # 查看权限状态
├── .agents/
│   ├── config.json              # 目录配置文件
│   ├── permissions.json         # 权限配置
│   ├── load-config.sh           # 配置加载脚本
│   ├── _workflow/               # 工作流控制
│   │   ├── tasks/               # 任务队列
│   │   ├── reviews/             # 审核队列
│   │   └── reports/             # 报告存储
│   ├── _communication/          # Agent间通信
│   │   ├── architect/           # 架构师消息
│   │   ├── developer/           # 程序员消息
│   │   ├── tester/              # 测试员消息
│   │   └── reviewer/            # 审核员消息
│   ├── _permissions/            # 权限管理
│   │   └── pending/             # 待审批的权限请求
│   └── _status/                 # 状态追踪
└── agents/                      # Agent工作区
    ├── frontend/                # 前端团队
    │   ├── architect/           # 架构师工作区
    │   │   ├── .claude/
    │   │   ├── designs/         # 架构设计文档
    │   │   └── workspace/       # 临时工作文件
    │   ├── developer/           # 程序员工作区
    │   │   ├── .claude/
    │   │   └── workspace/
    │   ├── tester/              # 测试员工作区
    │   │   ├── .claude/
    │   │   ├── test-plans/      # 测试计划
    │   │   ├── test-results/    # 测试结果
    │   │   └── workspace/
    │   └── reviewer/            # 审核员工作区
    │       ├── .claude/
    │       ├── reviews/         # 审核报告
    │       └── workspace/
    └── backend/                 # 后端团队（结构同前端）
```

## 快速开始

### 1. 初始化框架

```bash
# 下载并运行初始化脚本
./init-dev-agents.sh

# 交互式配置
请输入前端代码目录名称 (默认: src): frontend
请输入后端代码目录名称 (默认: server): api

# 配置将保存到 .agents/config.json
```

### 2. 启动管理Agent

```bash
claude

# 在 Claude Code 中
我是项目管理Agent，负责协调开发团队工作。

# 初始化团队（二选一）
/init-frontend  # 初始化前端开发团队
/init-backend   # 初始化后端开发团队
```

### 3. 分配任务

```
# 创建新任务
/assign --team frontend --type feature 实现用户登录功能

# 查看任务状态
/report TASK-001
```

### 4. 启动专业Agent

每个角色在新的终端窗口中启动：

```bash
# 架构师
cd agents/frontend/architect
claude

# 程序员
cd agents/frontend/developer
claude

# 测试员
cd agents/frontend/tester
claude

# 审核员
cd agents/frontend/reviewer
claude
```

## 角色职责

### 管理Agent（Orchestrator）

- 接收用户需求
- 分解和分配任务
- 协调各Agent工作
- 处理权限请求
- 生成进度报告

### 架构师（Architect）

- 技术方案设计
- 架构决策
- 编写设计文档
- 创建原型代码
- 审核反馈处理

### 程序员（Developer）

- 根据设计实现功能
- 编写生产代码
- 代码重构
- 修复bug
- 唯一默认有写权限的角色

### 测试员（Tester）

- 制定测试计划
- 编写测试用例
- 执行单元测试
- 集成测试（按需）
- 生成测试报告

### 审核员（Reviewer）

- 代码质量审核
- 架构合规检查
- 安全性评估
- 性能影响分析
- 提供改进建议

## 工作流程

### 标准开发流程

```
1. 架构设计 → 2. 代码实现 → 3. 测试验证 → 4. 代码审核
                                                ↓
                    5. 架构师复审 ← (如有问题)
                          ↓
                    6. 程序员修改
```

### 任务生命周期

1. **创建任务**：管理Agent创建任务文件
2. **设计阶段**：架构师接收任务，创建设计文档
3. **开发阶段**：程序员根据设计实现功能
4. **测试阶段**：测试员编写和执行测试
5. **审核阶段**：审核员评估代码质量
6. **完成/修改**：根据审核结果完成或返工

## 权限系统

### 默认权限

| 角色 | 读权限 | 写权限 |
|------|--------|--------|
| 架构师 | 主项目所有目录 | 自己的工作区 |
| 程序员 | 主项目所有目录 | 自己的工作区 + 源代码目录 |
| 测试员 | 主项目代码和测试 | 自己的工作区 |
| 审核员 | 主项目所有目录 | 自己的工作区 |

### 权限请求流程

1. **创建请求**：Agent创建权限请求JSON文件
2. **用户审批**：通过 `/grant-write` 命令查看和批准
3. **执行写入**：获得临时权限后执行操作
4. **权限回收**：操作完成后自动回收

示例权限请求：
```json
{
  "agent": "frontend-architect",
  "request_type": "write",
  "target_files": ["docs/architecture/auth.md"],
  "reason": "创建认证模块架构文档",
  "content_preview": "# 认证架构设计..."
}
```

## 通信机制

### 任务分发

任务文件格式（`.agents/_workflow/tasks/TASK-XXX.json`）：
```json
{
  "id": "TASK-001",
  "type": "feature",
  "team": "frontend",
  "status": "design",
  "assigned_to": "architect",
  "description": "实现用户登录功能",
  "requirements": [
    "表单验证",
    "JWT认证",
    "记住我功能"
  ]
}
```

### Agent间消息

消息格式（`.agents/_communication/[role]/message-XXX.json`）：
```json
{
  "from": "architect",
  "to": "developer",
  "subject": "设计完成",
  "content": "登录模块设计已完成，请开始实现",
  "attachments": ["designs/TASK-001.md"],
  "timestamp": "2024-06-30T10:00:00Z"
}
```

## 实际使用示例

### 完整的功能开发流程

#### 1. 管理Agent分配任务

```bash
/assign --team frontend --type feature 实现用户认证功能，包括登录、注册和JWT认证
```

#### 2. 架构师设计

```bash
cd agents/frontend/architect
claude

# 架构师工作
我是前端架构师，让我查看待设计的任务...

# 读取配置
source ../../../.agents/load-config.sh
echo "前端目录: $FRONTEND_DIR"

# 分析现有代码（只读）
ls ../../../$FRONTEND_DIR/
cat ../../../$FRONTEND_DIR/main.js

# 创建设计文档
cat > designs/TASK-001-auth.md << EOF
# 用户认证模块设计

## 技术选型
- 框架：Vue 3
- 状态管理：Pinia
- UI库：Element Plus
- 认证：JWT + Refresh Token

## 模块结构
- views/LoginView.vue - 登录页面
- views/RegisterView.vue - 注册页面
- stores/auth.js - 认证状态管理
- api/auth.js - 认证API调用
- utils/token.js - Token工具函数

## 接口约定
- POST /api/auth/login
- POST /api/auth/register
- POST /api/auth/refresh
- POST /api/auth/logout
EOF

# 创建原型
mkdir -p workspace/prototypes
# ... 创建原型组件

# 更新任务状态
echo "设计完成，任务状态更新为 development"
```

#### 3. 程序员实现

```bash
cd agents/frontend/developer
claude

# 读取架构设计
cat ../../../agents/frontend/architect/designs/TASK-001-auth.md

# 实现功能（直接写入主项目）
# 创建登录组件
cat > ../../../$FRONTEND_DIR/views/LoginView.vue << EOF
<template>
  <div class="login-container">
    <!-- 实际的登录表单实现 -->
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth'
// ... 实现代码
</script>
EOF

# 创建状态管理
cat > ../../../$FRONTEND_DIR/stores/auth.js << EOF
import { defineStore } from 'pinia'
// ... Pinia store 实现
EOF
```

#### 4. 测试员测试

```bash
cd agents/frontend/tester
claude

# 创建测试计划
cat > test-plans/TASK-001.md << EOF
# 认证功能测试计划

## 单元测试
- [x] 登录表单验证
- [x] Token解析功能
- [ ] 自动刷新逻辑

## 集成测试（按需）
- [ ] 完整登录流程
- [ ] Token过期处理
EOF

# 在工作区编写测试
mkdir -p workspace/tests
cat > workspace/tests/auth.spec.js << EOF
import { describe, it, expect } from 'vitest'
// ... 测试代码
EOF

# 申请添加测试到主项目
echo '{
  "agent": "frontend-tester",
  "request_type": "write",
  "target_files": ["tests/unit/auth.spec.js"],
  "reason": "添加认证模块单元测试",
  "content": "// 测试文件内容..."
}' > ../../../.agents/_permissions/pending/tester-$(date +%s).json
```

#### 5. 审核员审核

```bash
cd agents/frontend/reviewer
claude

# 生成审核报告
cat > reviews/TASK-001-review.json << EOF
{
  "task_id": "TASK-001",
  "review_result": "needs_revision",
  "scores": {
    "architecture_compliance": 9.0,
    "code_quality": 8.5,
    "test_coverage": 7.0,
    "security": 8.0
  },
  "must_fix": [
    "添加输入验证防止XSS",
    "实现Token自动刷新"
  ],
  "suggestions": [
    "考虑添加登录失败次数限制",
    "优化错误提示信息"
  ]
}
EOF
```

## 监控和管理

### 实时监控

```bash
# 运行监控脚本
./monitor-workflow.sh

# 输出示例
=== 开发流程监控面板 ===

项目配置：
- 前端目录: frontend
- 后端目录: api

活跃团队: frontend

角色状态:
  architect    : COMPLETED
  developer    : WORKING
  tester       : IDLE
  reviewer     : IDLE

待处理权限请求: 1 个请求
任务统计: 总任务数: 3
```

### 管理命令

| 命令 | 说明 |
|------|------|
| `/init-frontend` | 初始化前端团队 |
| `/init-backend` | 初始化后端团队 |
| `/assign` | 分配新任务 |
| `/report [task_id]` | 查看任务进度 |
| `/grant-write` | 处理权限请求 |
| `/permission-status` | 查看权限状态 |
| `/review [task_id]` | 查看审核结果 |

## 最佳实践

### 1. 任务粒度

- 保持任务适中，不要过大或过小
- 一个任务应该能在1-2天内完成
- 明确定义验收标准

### 2. 通信规范

- 使用结构化的JSON格式
- 消息包含明确的发送者和接收者
- 重要决策记录在消息中

### 3. 代码管理

- 架构师的原型代码仅供参考
- 程序员负责生产级代码实现
- 测试员确保代码质量

### 4. 权限控制

- 谨慎批准写权限请求
- 查看内容预览后再批准
- 定期清理过期的权限请求

### 5. 并发协作

- 避免多个Agent同时修改同一文件
- 通过任务分解减少依赖
- 使用消息系统协调工作

## 故障排除

### 常见问题

1. **Agent找不到任务**
   - 检查任务状态是否正确
   - 确认任务分配给了正确的角色

2. **权限请求未显示**
   - 确保请求文件在 `_permissions/pending/` 目录
   - 文件名需要以 `.json` 结尾

3. **通信失败**
   - 检查消息文件格式是否正确
   - 确认目标Agent的通信目录存在

4. **配置丢失**
   - 运行 `source .agents/load-config.sh` 重新加载
   - 检查 `config.json` 文件是否存在

## 扩展和定制

### 添加新角色

1. 在 `agents/[team]/` 下创建新角色目录
2. 创建 `.claude/agent.md` 配置文件
3. 更新权限配置
4. 添加到工作流程中

### 自定义命令

在 `.claude/commands/` 目录下创建新的 `.md` 文件：

```markdown
# my-command.md
执行自定义操作的命令。

使用方法：/my-command [参数]

功能：
1. 执行特定操作
2. 生成报告
3. 更新状态
```

### 集成外部工具

可以通过脚本集成其他工具：
- 代码检查工具（ESLint、Prettier）
- CI/CD 系统
- 项目管理工具
- 版本控制系统

## 总结

这个框架通过角色分工和文件系统通信，实现了一个轻量但功能完整的多Agent协作系统。它特别适合：

- 需要严格开发流程的项目
- 希望避免上下文污染的复杂开发
- 重视代码质量和架构设计的团队
- 个人开发者模拟团队协作

框架的核心优势在于简单、灵活和可扩展，完全基于 Claude Code 的原生能力，无需额外工具或服务。