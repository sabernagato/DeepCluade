# grant-write.md

查看和处理Agent的写权限请求。

## 使用方法
```
/grant-write [approve|reject] [请求ID]
```

## 参数说明

- 无参数: 列出所有待处理的权限请求
- `approve`: 批准权限请求
- `reject`: 拒绝权限请求
- `请求ID`: 要处理的请求文件名

## 示例

```
/grant-write                          # 查看所有待处理请求
/grant-write approve tester-123.json  # 批准测试员的请求
/grant-write reject architect-456.json # 拒绝架构师的请求
```

## 权限请求格式

```json
{
  "agent": "frontend-tester",
  "request_type": "write",
  "target_files": ["tests/unit/auth.spec.js"],
  "reason": "添加认证模块单元测试",
  "content_preview": "测试代码预览...",
  "requested_at": "时间戳"
}
```

## 处理流程

### 查看请求
1. 扫描 `.agents/_permissions/pending/` 目录
2. 显示每个请求的摘要信息
3. 提供内容预览

### 批准请求
1. 验证请求的合理性
2. 临时授予写权限
3. 执行文件写入操作
4. 记录操作日志
5. 移除临时权限
6. 归档请求文件

### 拒绝请求
1. 记录拒绝原因
2. 通知请求的Agent
3. 归档请求文件

## 安全考虑

- 仔细审查请求的目标文件
- 检查内容预览避免恶意代码
- 权限是临时的，操作后自动回收
- 所有操作都有日志记录

## 注意事项

- 只有管理Agent可以批准权限
- 建议定期清理已处理的请求
- 紧急情况可以批量处理