# DeepCluade - 专业开发流程多Agent协作框架

DeepCluade是一个基于Claude Code的多Agent协作框架，通过角色分工实现专业的软件开发流程。

## 🚀 快速开始

### 1. 初始化框架

```bash
# 克隆或下载项目后，运行初始化脚本
./init-dev-agents.sh

# 按提示配置前端和后端目录
# 例如：前端目录设为 "frontend"，后端目录设为 "backend"
```

### 2. 启动管理Agent

```bash
# 在项目根目录运行
claude

# Claude Code会读取 .claude/orchestrator.md 配置
# 自动成为项目管理Agent
```

### 3. 初始化开发团队

在管理Agent中执行：

```
# 初始化前端团队
/init-frontend

# 或初始化后端团队
/init-backend
```

### 4. 分配任务

```
# 创建新的开发任务
/assign --team frontend --type feature 实现用户登录功能
```

### 5. 启动专业Agent

在新的终端窗口中：

```bash
# 前端架构师
cd agents/frontend/architect && claude

# 前端程序员
cd agents/frontend/developer && claude

# 前端测试员
cd agents/frontend/tester && claude

# 前端审核员
cd agents/frontend/reviewer && claude
```

## 📁 项目结构

```
DeepCluade/
├── init-dev-agents.sh      # 初始化脚本
├── create-agent-configs.sh # Agent配置生成脚本
├── monitor-workflow.sh     # 工作流监控脚本
├── .claude/               # Claude Code配置
│   ├── orchestrator.md    # 管理Agent配置
│   └── commands/          # 自定义命令
├── .agents/               # 框架核心配置
│   ├── config.json        # 目录配置
│   ├── permissions.json   # 权限配置
│   ├── load-config.sh     # 配置加载脚本
│   └── _workflow/         # 工作流文件
└── agents/                # Agent工作区
    ├── frontend/          # 前端团队
    └── backend/           # 后端团队
```

## 👥 角色说明

| 角色 | 职责 | 默认权限 |
|------|------|----------|
| 管理Agent | 任务分配、进度跟踪、权限管理 | 读取所有，写入工作流 |
| 架构师 | 技术设计、架构决策、原型开发 | 读取所有，写入设计文档 |
| 程序员 | 功能实现、Bug修复、代码重构 | 读取所有，写入源代码 |
| 测试员 | 测试计划、用例编写、质量验证 | 读取代码，申请写入测试 |
| 审核员 | 代码审查、安全检查、性能评估 | 读取所有，写入审核报告 |

## 🔧 常用命令

### 管理Agent命令

- `/init-frontend` - 初始化前端团队
- `/init-backend` - 初始化后端团队
- `/assign` - 分配新任务
- `/report [task-id]` - 查看进度报告
- `/grant-write` - 处理权限请求
- `/permission-status` - 查看权限状态
- `/review [task-id]` - 查看审核结果

### 监控工具

```bash
# 实时监控工作流状态
./monitor-workflow.sh

# 查看一次性报告
./monitor-workflow.sh --once
```

## 📋 工作流程

1. **需求分析** - 管理Agent接收并分解需求
2. **架构设计** - 架构师设计技术方案
3. **代码实现** - 程序员根据设计实现功能
4. **测试验证** - 测试员编写并执行测试
5. **代码审核** - 审核员评估代码质量
6. **迭代改进** - 根据反馈进行优化

## 🔐 权限系统

- **默认权限**：每个角色有预定义的读写权限
- **临时权限**：通过申请获得额外写权限
- **权限审批**：管理Agent审批权限请求

## 💡 最佳实践

1. **任务粒度**：保持任务在1-2天内可完成
2. **及时沟通**：使用消息系统保持信息同步
3. **文档先行**：架构设计文档指导实现
4. **持续集成**：每个阶段都有质量把关

## 🐛 故障排除

### 配置未加载
```bash
source .agents/load-config.sh
```

### Agent找不到任务
- 检查任务文件是否在正确目录
- 确认任务状态和分配

### 权限请求未显示
- 检查 `.agents/_permissions/pending/` 目录
- 确保文件格式正确

## 📚 扩展开发

- 可以添加新的Agent角色
- 可以自定义命令和工作流
- 可以集成外部工具和服务

## 📄 许可证

MIT License

## 🤝 贡献

欢迎提交Issue和Pull Request！

---

*DeepCluade - 让Claude Code协作更专业*