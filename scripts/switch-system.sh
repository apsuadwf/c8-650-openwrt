#!/bin/bash
# C8-650 双系统切换脚本
# 用法: ./switch-system.sh [system1|system2|status]

set -e

# 显示当前系统状态
show_status() {
    echo "=== C8-650 双系统状态 ==="
    echo ""
    
    # 读取U-Boot环境变量
    local boot_system
    boot_system=$(fw_printenv boot_system 2>/dev/null | cut -d= -f2)
    
    if [ -z "$boot_system" ]; then
        echo "当前系统: 未知 (无法读取boot_system变量)"
        return 1
    fi
    
    case "$boot_system" in
        0)
            echo "当前系统: 系统1 (官方固件)"
            echo "下次启动: 系统1 (官方固件)"
            ;;
        1)
            echo "当前系统: 系统2 (OpenWrt)"
            echo "下次启动: 系统2 (OpenWrt)"
            ;;
        *)
            echo "当前系统: 未知 (boot_system=$boot_system)"
            ;;
    esac
    
    echo ""
    echo "可用命令:"
    echo "  $0 system1    切换到系统1 (官方固件)"
    echo "  $0 system2    切换到系统2 (OpenWrt)"
    echo "  $0 status     显示当前状态"
    echo "  $0 reboot     重启系统"
}

# 切换到系统1 (官方固件)
switch_to_system1() {
    echo "=== 切换到系统1 (官方固件) ==="
    echo ""
    echo "警告: 此操作将切换到官方固件并重启系统"
    echo ""
    
    read -p "确认切换? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "取消操作"
        return 0
    fi
    
    echo "设置启动系统为系统1..."
    fw_setenv boot_system 0
    
    echo "重启系统..."
    reboot
}

# 切换到系统2 (OpenWrt)
switch_to_system2() {
    echo "=== 切换到系统2 (OpenWrt) ==="
    echo ""
    echo "警告: 此操作将切换到OpenWrt并重启系统"
    echo ""
    
    read -p "确认切换? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "取消操作"
        return 0
    fi
    
    echo "设置启动系统为系统2..."
    fw_setenv boot_system 1
    
    echo "重启系统..."
    reboot
}

# 重启系统
reboot_system() {
    echo "=== 重启系统 ==="
    echo ""
    echo "警告: 此操作将重启系统"
    echo ""
    
    read -p "确认重启? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "取消操作"
        return 0
    fi
    
    # 尝试重置5G模块
    if command -v sendat &> /dev/null; then
        echo "重置5G模块..."
        sendat 2 "AT+CFUN=1,1" 2>/dev/null || true
        sleep 2
    fi
    
    echo "重启系统..."
    reboot
}

# 显示帮助
show_help() {
    echo "C8-650 双系统切换脚本"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  system1    切换到系统1 (官方固件)"
    echo "  system2    切换到系统2 (OpenWrt)"
    echo "  status     显示当前系统状态"
    echo "  reboot     重启系统"
    echo "  help       显示帮助"
    echo ""
    echo "物理按键切换方法:"
    echo "  1. 断电"
    echo "  2. 按住Reset键 (旧版按WPS键)"
    echo "  3. 通电"
    echo "  4. 等待电源灯亮起"
    echo "  5. 松开按键"
    echo "  6. 系统自动切换并重启"
    echo ""
    echo "示例:"
    echo "  $0 status"
    echo "  $0 system1"
    echo "  $0 system2"
    echo "  $0 reboot"
}

# 主函数
main() {
    # 检查是否为root用户
    if [ "$(id -u)" -ne 0 ]; then
        echo "错误: 需要root权限运行此脚本"
        echo "请使用: sudo $0 $*"
        exit 1
    fi
    
    case "${1:-help}" in
        system1|sys1|s1)
            switch_to_system1
            ;;
        system2|sys2|s2)
            switch_to_system2
            ;;
        status|st)
            show_status
            ;;
        reboot|rb)
            reboot_system
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
