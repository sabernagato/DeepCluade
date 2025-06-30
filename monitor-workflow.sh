#!/bin/bash

# DeepCluade 工作流监控脚本
# 实时监控多Agent协作状态

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 清屏函数
clear_screen() {
    clear
    echo -e "${CYAN}================================================${NC}"
    echo -e "${CYAN}     DeepCluade 开发流程监控面板${NC}"
    echo -e "${CYAN}================================================${NC}"
    echo ""
}

# 检查配置
check_config() {
    if [ ! -f ".agents/config.json" ]; then
        echo -e "${RED}错误：未找到配置文件${NC}"
        echo "请先运行 ./init-dev-agents.sh 初始化框架"
        exit 1
    fi
    
    # 加载配置
    source .agents/load-config.sh >/dev/null 2>&1
}

# 显示项目配置
show_config() {
    echo -e "${BLUE}项目配置：${NC}"
    echo "- 前端目录: $FRONTEND_DIR"
    echo "- 后端目录: $BACKEND_DIR"
    echo "- 框架版本: $DEEPCLUADE_VERSION"
    echo ""
}

# 统计任务
count_tasks() {
    local status=$1
    local count=0
    
    for task in .agents/_workflow/tasks/*.json; do
        if [ -f "$task" ]; then
            local task_status=$(jq -r '.status' "$task" 2>/dev/null)
            if [ "$task_status" = "$status" ]; then
                ((count++))
            fi
        fi
    done
    
    echo $count
}

# 显示任务统计
show_tasks_summary() {
    echo -e "${BLUE}任务统计：${NC}"
    
    local total=0
    local pending=$(count_tasks "pending")
    local design=$(count_tasks "design")
    local development=$(count_tasks "development")
    local testing=$(count_tasks "testing")
    local review=$(count_tasks "review")
    local completed=$(count_tasks "completed")
    
    total=$((pending + design + development + testing + review + completed))
    
    echo "总任务数: $total"
    echo -e "- 待处理: ${YELLOW}$pending${NC}"
    echo -e "- 设计中: ${PURPLE}$design${NC}"
    echo -e "- 开发中: ${BLUE}$development${NC}"
    echo -e "- 测试中: ${CYAN}$testing${NC}"
    echo -e "- 审核中: ${YELLOW}$review${NC}"
    echo -e "- 已完成: ${GREEN}$completed${NC}"
    echo ""
}

# 显示当前活跃任务
show_active_tasks() {
    echo -e "${BLUE}活跃任务：${NC}"
    
    local found=0
    for task in .agents/_workflow/tasks/*.json; do
        if [ -f "$task" ]; then
            local status=$(jq -r '.status' "$task" 2>/dev/null)
            if [ "$status" != "pending" ] && [ "$status" != "completed" ] && [ "$status" != "cancelled" ]; then
                local id=$(jq -r '.id' "$task")
                local type=$(jq -r '.type' "$task")
                local team=$(jq -r '.team' "$task")
                local assigned=$(jq -r '.assigned_to // "未分配"' "$task")
                local desc=$(jq -r '.description' "$task" | head -c 50)
                
                echo -e "- ${GREEN}$id${NC} [$type] - $team/$assigned - $desc..."
                found=1
            fi
        fi
    done
    
    if [ $found -eq 0 ]; then
        echo "当前没有活跃任务"
    fi
    echo ""
}

# 检查Agent状态
check_agent_status() {
    local team=$1
    local role=$2
    local workspace="agents/$team/$role/workspace"
    
    # 检查最近的活动（查看workspace目录的修改时间）
    if [ -d "$workspace" ]; then
        local last_modified=$(find "$workspace" -type f -mmin -10 2>/dev/null | wc -l)
        if [ $last_modified -gt 0 ]; then
            echo -e "${GREEN}活跃${NC}"
        else
            echo -e "${YELLOW}空闲${NC}"
        fi
    else
        echo -e "${RED}未初始化${NC}"
    fi
}

# 显示Agent状态
show_agents_status() {
    echo -e "${BLUE}Agent状态：${NC}"
    
    for team in frontend backend; do
        echo -e "\n${CYAN}$team 团队：${NC}"
        echo -n "  架构师: "; check_agent_status $team architect
        echo -n "  程序员: "; check_agent_status $team developer
        echo -n "  测试员: "; check_agent_status $team tester
        echo -n "  审核员: "; check_agent_status $team reviewer
    done
    echo ""
}

# 显示待处理权限请求
show_pending_permissions() {
    echo -e "${BLUE}权限请求：${NC}"
    
    local count=0
    for perm in .agents/_permissions/pending/*.json; do
        if [ -f "$perm" ]; then
            ((count++))
        fi
    done
    
    if [ $count -gt 0 ]; then
        echo -e "${YELLOW}有 $count 个待处理的权限请求${NC}"
        
        # 显示前3个请求的摘要
        local shown=0
        for perm in .agents/_permissions/pending/*.json; do
            if [ -f "$perm" ] && [ $shown -lt 3 ]; then
                local agent=$(jq -r '.agent' "$perm" 2>/dev/null)
                local reason=$(jq -r '.reason' "$perm" 2>/dev/null | head -c 40)
                echo "  - $agent: $reason..."
                ((shown++))
            fi
        done
        
        if [ $count -gt 3 ]; then
            echo "  ... 还有 $((count-3)) 个请求"
        fi
    else
        echo "没有待处理的权限请求"
    fi
    echo ""
}

# 显示最近的消息
show_recent_messages() {
    echo -e "${BLUE}最近消息：${NC}"
    
    # 查找最近的5条消息
    local messages=$(find .agents/_communication -name "*.json" -type f -mmin -60 2>/dev/null | sort -r | head -5)
    
    if [ -z "$messages" ]; then
        echo "最近1小时内没有新消息"
    else
        for msg in $messages; do
            if [ -f "$msg" ]; then
                local from=$(jq -r '.from' "$msg" 2>/dev/null)
                local to=$(jq -r '.to' "$msg" 2>/dev/null)
                local subject=$(jq -r '.subject' "$msg" 2>/dev/null)
                echo "  $from → $to: $subject"
            fi
        done
    fi
    echo ""
}

# 显示系统健康状态
show_health_status() {
    echo -e "${BLUE}系统健康：${NC}"
    
    # 检查必要的目录
    local dirs_ok=true
    for dir in .agents/_workflow .agents/_communication .agents/_permissions agents; do
        if [ ! -d "$dir" ]; then
            echo -e "  ${RED}✗${NC} 目录缺失: $dir"
            dirs_ok=false
        fi
    done
    
    if $dirs_ok; then
        echo -e "  ${GREEN}✓${NC} 所有系统目录正常"
    fi
    
    # 检查配置文件
    if [ -f ".agents/config.json" ] && [ -f ".agents/permissions.json" ]; then
        echo -e "  ${GREEN}✓${NC} 配置文件完整"
    else
        echo -e "  ${RED}✗${NC} 配置文件缺失"
    fi
    
    echo ""
}

# 主监控循环
monitor_loop() {
    while true; do
        clear_screen
        show_config
        show_tasks_summary
        show_active_tasks
        show_agents_status
        show_pending_permissions
        show_recent_messages
        show_health_status
        
        echo -e "${CYAN}================================================${NC}"
        echo "按 Ctrl+C 退出监控"
        echo "自动刷新间隔: 5秒"
        
        sleep 5
    done
}

# 主函数
main() {
    check_config
    
    # 处理参数
    case "$1" in
        --once)
            clear_screen
            show_config
            show_tasks_summary
            show_active_tasks
            show_agents_status
            show_pending_permissions
            show_recent_messages
            show_health_status
            ;;
        *)
            monitor_loop
            ;;
    esac
}

# 运行主函数
main "$@"