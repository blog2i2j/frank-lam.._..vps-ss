#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# 记录整体开始时间
TOTAL_START_TIME=$SECONDS

# --- 打印 Banner ---
clear
echo -e "${CYAN}"
echo "##################################################"
echo "#                                                #"
echo "#      VPS 快速部署工具 (Wget/BBR/Sing-box)        #"
echo "#                                                #"
echo "##################################################"
echo -e "${NC}"

# --- 核心执行函数 (使用内置整数运算) ---
run_step() {
    local step_label=$1
    local cmd=$2

    echo -e "${YELLOW}▶ 正在进行: ${step_label}${NC}"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    
    # 记录步骤开始时间
    local step_start=$SECONDS
    
    # 执行命令
    eval "$cmd"
    
    # 计算步骤耗时
    local step_end=$SECONDS
    local duration=$((step_end - step_start))
    
    echo -e "${BLUE}--------------------------------------------------${NC}"
    echo -e "${GREEN}✔ ${step_label} 已完成! 耗时: ${duration}s${NC}\n"
}

# 1. Wget 安装 (CentOS Stream 9)
run_step "Wget 下载与安装" "
    curl -O https://mirror.xtom.com.hk/centos-stream/9-stream/AppStream/x86_64/os/Packages/wget-1.21.1-7.el9.x86_64.rpm && \
    rpm -ivh wget-1.21.1-7.el9.x86_64.rpm --force --nodeps
"

# 2. BBR 开启
run_step "BBR 内核加速配置" "
    echo 'net.core.default_qdisc = fq' > /etc/sysctl.d/10-bbr.conf
    echo 'net.ipv4.tcp_congestion_control = bbr' >> /etc/sysctl.d/10-bbr.conf
    sysctl --system
    
    # 验证
    if sysctl net.ipv4.tcp_congestion_control | grep -q bbr; then
        echo -e '${GREEN}状态: BBR 已成功激活!${NC}'
    else
        echo -e '${RED}状态: BBR 激活失败，请检查内核版本${NC}'
    fi
"

# 3. Sing-box 安装
run_step "Sing-box 脚本部署" "
    bash <(curl -fsSL https://github.com/233boy/sing-box/raw/main/install.sh)
"

# --- 总结报告 ---
TOTAL_DURATION=$((SECONDS - TOTAL_START_TIME))

echo -e "${PURPLE}=================================================="
echo -e "🏁  所有任务已执行完毕！"
echo -e "⏳  总共运行时间: ${TOTAL_DURATION} 秒"
echo -e "==================================================${NC}"