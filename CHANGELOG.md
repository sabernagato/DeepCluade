# Changelog

All notable changes to DeepCluade will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-06-30

### Added
- 初始版本发布
- 核心框架实现，包括：
  - 多Agent角色系统（架构师、程序员、测试员、审核员）
  - 基于文件系统的通信机制
  - 灵活的权限管理系统
  - 任务分配和工作流管理
- 管理Agent命令系统：
  - `/init-frontend` - 初始化前端团队
  - `/init-backend` - 初始化后端团队
  - `/assign` - 分配任务
  - `/report` - 生成进度报告
  - `/grant-write` - 处理权限请求
  - `/permission-status` - 查看权限状态
  - `/review` - 查看审核结果
- 辅助工具：
  - `init-dev-agents.sh` - 框架初始化脚本
  - `monitor-workflow.sh` - 实时监控面板
  - `load-config.sh` - 配置加载和辅助函数
- 完整的文档和使用说明

### Features
- 支持前端和后端双团队并行开发
- 自定义代码目录配置
- 实时工作流监控
- 结构化的消息和任务格式
- 临时权限申请机制
- 专业的开发流程：设计→开发→测试→审核

### Security
- 默认只读权限，写权限需申请
- 权限请求需人工审批
- 操作日志记录

[1.0.0]: https://github.com/sabernagato/DeepCluade/releases/tag/v1.0.0