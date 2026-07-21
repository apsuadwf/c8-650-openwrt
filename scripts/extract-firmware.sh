#!/bin/bash
# C8-650 固件解包脚本
# 用法: ./extract-firmware.sh <固件文件>

set -e

FIRMWARE="$1"

if [ -z "$FIRMWARE" ]; then
    echo "用法: $0 <固件文件>"
    echo "示例: $0 C8-650双系统-4.6.6移远-常规版.bin"
    exit 1
fi

if [ ! -f "$FIRMWARE" ]; then
    echo "错误: 文件不存在: $FIRMWARE"
    exit 1
fi

echo "=== C8-650 固件解包工具 ==="
echo "固件文件: $FIRMWARE"
echo ""

# 创建输出目录
OUTPUT_DIR="./firmware_extracted"
mkdir -p "$OUTPUT_DIR"

# 检查依赖
echo "检查依赖..."
for cmd in binwalk unsquashfs tar; do
    if ! command -v $cmd &> /dev/null; then
        echo "错误: 需要安装 $cmd"
        echo "请运行: sudo apt install squashfs-tools binwalk"
        exit 1
    fi
done

# 解包固件
echo "解包固件..."
cd "$OUTPUT_DIR"
binwalk --run-as=root -e "../$FIRMWARE"

# 查找解压目录
EXTRACTED_DIR=$(find . -maxdepth 1 -name "_*" -type d | head -1)
if [ -z "$EXTRACTED_DIR" ]; then
    echo "错误: 解压失败"
    exit 1
fi

echo "解压目录: $EXTRACTED_DIR"

# 解压tar
echo "解压tar..."
cd "$EXTRACTED_DIR"
TAR_FILE=$(find . -name "*.tar" | head -1)
if [ -n "$TAR_FILE" ]; then
    tar -xf "$TAR_FILE"
fi

# 查找squashfs
echo "查找SquashFS..."
SQUASHFS_FILE=$(find . -name "root" -type f | head -1)
if [ -z "$SQUASHFS_FILE" ]; then
    echo "错误: 未找到SquashFS"
    exit 1
fi

# 解压squashfs
echo "解压SquashFS..."
ROOTFS_DIR="$OUTPUT_DIR/rootfs"
unsquashfs -f -d "$ROOTFS_DIR" "$SQUASHFS_FILE"

echo ""
echo "=== 解包完成 ==="
echo "根文件系统: $ROOTFS_DIR"
echo ""
echo "常用命令:"
echo "  查看LuCI应用: ls $ROOTFS_DIR/usr/lib/lua/luci/controller/"
echo "  查看配置文件: cat $ROOTFS_DIR/etc/config/network"
echo "  查看已安装包: cat $ROOTFS_DIR/usr/lib/opkg/status | grep Package"
