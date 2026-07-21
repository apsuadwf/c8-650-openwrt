#!/bin/bash
# C8-650 5G模块配置脚本
# 用法: ./5g-setup.sh [运营商]

set -e

# 默认配置
AT_PORT="/dev/ttyUSB2"
BAUD_RATE="115200"

# 运营商APN配置
declare -A APNS=(
    ["mobile"]="cmnet"
    ["unicom"]="3gnet"
    ["telecom"]="ctnet"
)

# 检查依赖
check_deps() {
    for cmd in picocom sendat uci; do
        if ! command -v $cmd &> /dev/null; then
            echo "错误: 需要安装 $cmd"
            exit 1
        fi
    done
}

# 检查5G模块
check_module() {
    echo "检查5G模块..."
    
    # 检查USB设备
    if ! lsusb | grep -q "2c7c:0900"; then
        echo "错误: 未检测到RM500U模块"
        echo "请检查USB连接"
        exit 1
    fi
    
    echo "✓ 检测到RM500U模块"
    
    # 检查串口
    if [ ! -c "$AT_PORT" ]; then
        echo "错误: AT指令端口不存在: $AT_PORT"
        echo "可用端口:"
        ls /dev/ttyUSB* 2>/dev/null || echo "  无"
        exit 1
    fi
    
    echo "✓ AT指令端口正常: $AT_PORT"
}

# 测试AT指令
test_at() {
    echo "测试AT指令..."
    
    local response
    response=$(echo "AT" | timeout 5 picocom -b $BAUD_RATE -q $AT_PORT 2>/dev/null | grep "OK")
    
    if [ -n "$response" ]; then
        echo "✓ AT指令测试成功"
    else
        echo "✗ AT指令测试失败"
        exit 1
    fi
}

# 查询模块信息
query_info() {
    echo ""
    echo "=== 模块信息 ==="
    
    # IMEI
    echo -n "IMEI: "
    echo "AT+CGSN" | timeout 5 picocom -b $BAUD_RATE -q $AT_PORT 2>/dev/null | grep -v "AT" | grep -v "^$"
    
    # 信号强度
    echo -n "信号强度: "
    echo "AT+CSQ" | timeout 5 picocom -b $BAUD_RATE -q $AT_PORT 2>/dev/null | grep "+CSQ"
    
    # 网络注册
    echo -n "网络注册: "
    echo "AT+CEREG?" | timeout 5 picocom -b $BAUD_RATE -q $AT_PORT 2>/dev/null | grep "+CEREG"
    
    # 运营商
    echo -n "运营商: "
    echo "AT+COPS?" | timeout 5 picocom -b $BAUD_RATE -q $AT_PORT 2>/dev/null | grep "+COPS"
    
    # 模块型号
    echo -n "模块型号: "
    echo "ATI" | timeout 5 picocom -b $BAUD_RATE -q $AT_PORT 2>/dev/null | grep -E "Model|Revision"
    
    echo ""
}

# 配置网络
setup_network() {
    local carrier=$1
    local apn=${APNS[$carrier]}
    
    if [ -z "$apn" ]; then
        echo "错误: 不支持的运营商: $carrier"
        echo "支持的运营商: mobile, unicom, telecom"
        exit 1
    fi
    
    echo "配置网络 (运营商: $carrier, APN: $apn)..."
    
    # 配置NCM拨号
    uci set network.wwan=interface
    uci set network.wwan.proto='ncm'
    uci set network.wwan.device="$AT_PORT"
    uci set network.wwan.apn="$apn"
    uci set network.wwan.auth='none'
    uci set network.wwan.pdptype='ipv4v6'
    uci commit network
    
    echo "✓ 网络配置完成"
    
    # 重启网络
    echo "重启网络..."
    /etc/init.d/network restart
    
    echo "✓ 网络重启完成"
}

# 配置SMS工具
setup_sms() {
    echo "配置SMS工具..."
    
    uci set sms_tool=sms_tool
    uci set sms_tool.sendport="$AT_PORT"
    uci set sms_tool.ussdport="$AT_PORT"
    uci set sms_tool.atport="$AT_PORT"
    uci set sms_tool.readport="$AT_PORT"
    uci commit sms_tool
    
    echo "✓ SMS配置完成"
}

# 发送测试短信
send_test_sms() {
    local phone=$1
    local message=$2
    
    if [ -z "$phone" ] || [ -z "$message" ]; then
        echo "用法: $0 sms <手机号> <短信内容>"
        exit 1
    fi
    
    echo "发送短信到 $phone..."
    sendat 2 "AT+CMGF=1"
    sendat 2 "AT+CMGS=\"$phone\""
    sendat 2 "$message"
    sendat 2 "$(printf '\x1a')"
    
    echo "✓ 短信发送完成"
}

# 显示帮助
show_help() {
    echo "C8-650 5G模块配置脚本"
    echo ""
    echo "用法: $0 [命令] [参数]"
    echo ""
    echo "命令:"
    echo "  check     检查5G模块状态"
    echo "  info      查询模块信息"
    echo "  setup     配置网络 (需要指定运营商)"
    echo "  sms       发送短信"
    echo "  help      显示帮助"
    echo ""
    echo "运营商:"
    echo "  mobile    中国移动 (APN: cmnet)"
    echo "  unicom    中国联通 (APN: 3gnet)"
    echo "  telecom   中国电信 (APN: ctnet)"
    echo ""
    echo "示例:"
    echo "  $0 check"
    echo "  $0 info"
    echo "  $0 setup mobile"
    echo "  $0 sms 10086 YE"
}

# 主函数
main() {
    check_deps
    
    case "${1:-help}" in
        check)
            check_module
            test_at
            ;;
        info)
            check_module
            query_info
            ;;
        setup)
            check_module
            test_at
            setup_network "${2:-mobile}"
            setup_sms
            ;;
        sms)
            check_module
            send_test_sms "$2" "$3"
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
