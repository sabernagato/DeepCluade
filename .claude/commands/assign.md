# assign.md

分配新的开发任务给指定团队。

## 使用方法
```
/assign --team [frontend|backend] --type [feature|bug|refactor|test] 任务描述
```

## 参数说明

- `--team`: 目标团队 (frontend 或 backend)
- `--type`: 任务类型
  - `feature`: 新功能开发
  - `bug`: 缺陷修复
  - `refactor`: 代码重构
  - `test`: 测试相关
- `任务描述`: 详细的任务需求描述

## 示例

```
/assign --team frontend --type feature 实现用户登录功能，包括表单验证和JWT认证
/assign --team backend --type bug 修复API响应时间过长的问题
/assign --team frontend --type refactor 重构组件结构，提升代码可维护性
```

## 执行流程

1. 解析命令参数
2. 生成唯一的任务ID (TASK-XXX)
3. 创建任务JSON文件
4. 设置初始状态为 "pending"
5. 根据任务类型确定首个执行角色（通常是架构师）
6. 创建通知消息
7. 返回任务ID供跟踪

## 任务文件结构

```json
{
  "id": "TASK-001",
  "type": "feature",
  "team": "frontend",
  "status": "pending",
  "assigned_to": null,
  "description": "任务描述",
  "requirements": ["需求细节"],
  "created_at": "时间戳",
  "updated_at": "时间戳"
}
```

## 注意事项

- 任务ID自动生成，格式为 TASK-XXX
- 任务创建后会自动通知相应团队
- 可以通过 `/report` 命令查看任务进度