# init-frontend.md

初始化前端开发团队，创建所有前端Agent的配置文件。

## 使用方法
```
/init-frontend
```

## 功能说明

该命令会为前端团队的所有角色创建配置文件：
- 前端架构师 (Frontend Architect)
- 前端程序员 (Frontend Developer)  
- 前端测试员 (Frontend Tester)
- 前端审核员 (Frontend Reviewer)

## 执行步骤

1. 检查是否已运行初始化脚本
2. 读取配置文件获取前端目录
3. 为每个角色创建 `.claude/agent.md` 文件
4. 设置角色特定的指令和权限
5. 创建初始工作目录

## 注意事项

- 如果Agent配置已存在，会提示是否覆盖
- 确保先运行 `init-dev-agents.sh` 脚本
- 初始化后需要在各自目录启动Agent