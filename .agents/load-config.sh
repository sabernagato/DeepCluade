#!/bin/bash

# DeepCluade 配置加载脚本
# 用于在Agent环境中加载项目配置

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE="$SCRIPT_DIR/config.json"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "错误：配置文件不存在: $CONFIG_FILE"
    echo "请先运行 init-dev-agents.sh 初始化框架"
    exit 1
fi

# 读取配置并导出为环境变量
export FRONTEND_DIR=$(jq -r '.frontend_dir' "$CONFIG_FILE")
export BACKEND_DIR=$(jq -r '.backend_dir' "$CONFIG_FILE")

# 导出团队配置
export FRONTEND_ARCHITECT=$(jq -r '.teams.frontend.architect' "$CONFIG_FILE")
export FRONTEND_DEVELOPER=$(jq -r '.teams.frontend.developer' "$CONFIG_FILE")
export FRONTEND_TESTER=$(jq -r '.teams.frontend.tester' "$CONFIG_FILE")
export FRONTEND_REVIEWER=$(jq -r '.teams.frontend.reviewer' "$CONFIG_FILE")

export BACKEND_ARCHITECT=$(jq -r '.teams.backend.architect' "$CONFIG_FILE")
export BACKEND_DEVELOPER=$(jq -r '.teams.backend.developer' "$CONFIG_FILE")
export BACKEND_TESTER=$(jq -r '.teams.backend.tester' "$CONFIG_FILE")
export BACKEND_REVIEWER=$(jq -r '.teams.backend.reviewer' "$CONFIG_FILE")

# 导出框架版本
export DEEPCLUADE_VERSION=$(jq -r '.version' "$CONFIG_FILE")

# 导出工作流目录
export WORKFLOW_DIR="$SCRIPT_DIR/_workflow"
export TASKS_DIR="$WORKFLOW_DIR/tasks"
export REVIEWS_DIR="$WORKFLOW_DIR/reviews"
export REPORTS_DIR="$WORKFLOW_DIR/reports"

# 导出通信目录
export COMM_DIR="$SCRIPT_DIR/_communication"
export COMM_ARCHITECT="$COMM_DIR/architect"
export COMM_DEVELOPER="$COMM_DIR/developer"
export COMM_TESTER="$COMM_DIR/tester"
export COMM_REVIEWER="$COMM_DIR/reviewer"

# 导出权限目录
export PERMISSIONS_DIR="$SCRIPT_DIR/_permissions"
export PENDING_PERMISSIONS="$PERMISSIONS_DIR/pending"

# 导出状态目录
export STATUS_DIR="$SCRIPT_DIR/_status"

# 辅助函数：获取当前Agent角色
get_current_role() {
    local pwd_path=$(pwd)
    if [[ $pwd_path == *"/architect"* ]]; then
        echo "architect"
    elif [[ $pwd_path == *"/developer"* ]]; then
        echo "developer"
    elif [[ $pwd_path == *"/tester"* ]]; then
        echo "tester"
    elif [[ $pwd_path == *"/reviewer"* ]]; then
        echo "reviewer"
    else
        echo "unknown"
    fi
}

# 辅助函数：获取当前团队
get_current_team() {
    local pwd_path=$(pwd)
    if [[ $pwd_path == *"/frontend/"* ]]; then
        echo "frontend"
    elif [[ $pwd_path == *"/backend/"* ]]; then
        echo "backend"
    else
        echo "unknown"
    fi
}

# 导出当前角色和团队
export CURRENT_ROLE=$(get_current_role)
export CURRENT_TEAM=$(get_current_team)

# 显示加载的配置
echo "DeepCluade 配置已加载："
echo "- 前端目录: $FRONTEND_DIR"
echo "- 后端目录: $BACKEND_DIR"
echo "- 框架版本: $DEEPCLUADE_VERSION"
echo "- 当前角色: $CURRENT_ROLE"
echo "- 当前团队: $CURRENT_TEAM"
echo ""

# 提供便捷的路径导航函数
alias goto-tasks="cd $TASKS_DIR"
alias goto-reviews="cd $REVIEWS_DIR"
alias goto-reports="cd $REPORTS_DIR"
alias goto-comm="cd $COMM_DIR"
alias goto-permissions="cd $PENDING_PERMISSIONS"

# 提供查看任务的便捷函数
show_tasks() {
    echo "=== 待处理任务 ==="
    for task in $TASKS_DIR/*.json; do
        if [ -f "$task" ]; then
            local id=$(jq -r '.id' "$task")
            local type=$(jq -r '.type' "$task")
            local status=$(jq -r '.status' "$task")
            local assigned=$(jq -r '.assigned_to // "未分配"' "$task")
            echo "$id [$type] - 状态: $status - 分配给: $assigned"
        fi
    done
}

# 提供查看消息的便捷函数
show_messages() {
    local role=${1:-$CURRENT_ROLE}
    echo "=== $role 的消息 ==="
    for msg in $COMM_DIR/$role/*.json; do
        if [ -f "$msg" ]; then
            local from=$(jq -r '.from' "$msg")
            local subject=$(jq -r '.subject' "$msg")
            local time=$(jq -r '.timestamp' "$msg")
            echo "来自 $from: $subject ($time)"
        fi
    done
}

# 导出函数供使用
export -f show_tasks
export -f show_messages

echo "可用命令："
echo "- show_tasks      : 显示所有任务"
echo "- show_messages   : 显示当前角色的消息"
echo "- goto-tasks      : 进入任务目录"
echo "- goto-comm       : 进入通信目录"
echo ""