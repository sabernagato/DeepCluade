# review.md

查看代码审核结果和反馈。

## 使用方法
```
/review [任务ID] [--status 状态]
```

## 参数说明

- `任务ID` (可选): 查看特定任务的审核结果
- `--status`: 筛选特定状态的审核
  - `pending`: 待审核
  - `approved`: 已通过
  - `needs_revision`: 需要修改
  - `rejected`: 已拒绝

## 示例

```
/review                              # 查看所有审核结果
/review TASK-001                     # 查看TASK-001的审核详情
/review --status needs_revision      # 查看所有需要修改的审核
```

## 审核报告内容

### 审核摘要
- 任务ID和描述
- 审核状态
- 审核时间
- 审核员

### 评分详情
- 架构合规性 (0-10分)
- 代码质量 (0-10分)
- 测试覆盖率 (0-10分)
- 安全性 (0-10分)
- 性能影响 (0-10分)

### 反馈内容
- **必须修改项** (must_fix)
  - 影响功能的严重问题
  - 安全漏洞
  - 架构违规

- **建议改进项** (suggestions)
  - 代码风格问题
  - 性能优化建议
  - 可维护性改进

### 审核结果示例

```json
{
  "task_id": "TASK-001",
  "review_result": "needs_revision",
  "reviewer": "frontend-reviewer",
  "reviewed_at": "2024-06-30T10:00:00Z",
  "scores": {
    "architecture_compliance": 9.0,
    "code_quality": 8.5,
    "test_coverage": 7.0,
    "security": 8.0,
    "performance": 8.5
  },
  "must_fix": [
    "添加输入验证防止XSS攻击",
    "处理异步操作的错误情况"
  ],
  "suggestions": [
    "考虑使用组合式API提高可读性",
    "添加更多的单元测试用例"
  ],
  "code_snippets": [
    {
      "file": "src/views/LoginView.vue",
      "line": 45,
      "issue": "未验证的用户输入",
      "suggestion": "使用v-html时需要先进行XSS过滤"
    }
  ]
}
```

## 处理审核反馈

1. **查看反馈**: 使用此命令查看详细的审核意见
2. **分配修改**: 将需要修改的项分配给相应的Agent
3. **跟踪进度**: 确保所有必须修改项都得到处理
4. **重新审核**: 修改完成后触发新的审核

## 注意事项

- 审核结果保存在 `.agents/_workflow/reviews/` 目录
- 必须修改项需要优先处理
- 建议项可以根据实际情况决定是否采纳
- 审核通过后任务才能标记为完成