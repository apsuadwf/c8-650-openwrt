# 编译指南

## 环境要求

### 系统要求

- **操作系统**: Ubuntu 22.04/24.04 LTS (推荐)
- **内存**: 4GB+ (推荐8GB)
- **磁盘**: 50GB+ 可用空间
- **网络**: 稳定的网络连接 (需要梯子)

### 不支持的环境

- ❌ WSL (Windows Subsystem for Linux)
- ❌ macOS (部分兼容)
- ❌ root用户编译

## 安装依赖

```bash
# Ubuntu/Debian
sudo apt update -y
sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils \
  bison build-essential bzip2 ccache cmake cpio curl device-tree-compiler ecj \
  fastjar flex gawk gettext gcc-multilib g++-multilib git gnutls-dev gperf \
  haveged help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev libfuse-dev \
  libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev \
  libncursesw5-dev libpython3-dev libreadline-dev libssl-dev libtool lrzsz \
  mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python3 \
  python3-pip python3-ply qemu-utils rsync scons squashfs-tools \
  subversion swig texinfo uglifyjs unzip vim wget xmlto xxd zlib1g-dev
```

## 克隆源码

```bash
# 创建编译用户 (不要用root)
sudo useradd -m builder
sudo usermod -aG sudo builder
su - builder

# 克隆ImmortalWrt源码
git clone -b openwrt-23.05 --single-branch --filter=blob:none \
  https://github.com/immortalwrt/immortalwrt.git
cd immortalwrt

# 更新feeds
./scripts/feeds update -a
./scripts/feeds install -a
```

## 添加自定义插件

```bash
# 复制自定义LuCI插件
cp -r /path/to/c8-650-openwrt/luci-apps/luci-app-Secondsystem package/
cp -r /path/to/c8-650-openwrt/luci-apps/luci-app-Smstrun package/

# 更新feeds (让新插件生效)
./scripts/feeds update -a
./scripts/feeds install -a
```

## 配置编译

### 使用预置配置

```bash
# 复制预置配置
cp /path/to/c8-650-openwrt/config/.config .

# 应用配置
make defconfig
```

### 手动配置 (可选)

```bash
make menuconfig
```

**关键配置项：**

```
Target System  → MediaTek Ralink MIPS
               → (或) MediaTek AARCH64 (MT7981)
Subtarget      → MT7981 based boards
Target Profile → HCMT7981-emmc 或 Generic

LuCI → Collections → luci (勾选)

LuCI → Applications →
  [*] luci-app-Secondsystem     # 切换系统
  [*] luci-app-Smstrun          # 短信
  [*] luci-app-dockerman        # Docker
  [*] luci-app-store            # iStore
  [*] luci-app-turboacc-mtk     # 网络加速
  [*] luci-app-advancedsetting  # 高级设置
  [*] luci-app-sms-tool         # 短信工具
  [*] luci-app-ddnsto           # 内网穿透
  [*] luci-app-diskman          # 磁盘管理
  [*] luci-app-filetransfer     # 文件传输
  [*] luci-app-samba4           # SMB共享
  [*] luci-app-ttyd             # Web终端

Kernel Modules → USB Support →
  [*] kmod-usb-core
  [*] kmod-usb2
  [*] kmod-usb3
  [*] kmod-usb-serial
  [*] kmod-usb-serial-option
  [*] kmod-usb-net
  [*] kmod-usb-net-cdc-ncm
  [*] kmod-usb-net-rndis
  [*] kmod-usb-net-cdc-mbim

Network →
  [*] xray-core
  [*] chinadns-ng
  [*] ipt2socks
```

## 编译固件

```bash
# 下载源码包 (需要梯子)
make download -j8

# 开始编译 (-j后面跟CPU核心数)
make -j$(nproc) V=s

# 编译时间: 首次1-3小时，后续10-30分钟
```

## 编译产物

```
bin/targets/mediatek/mt7981/
├── immortalwrt-mediatek-mt7981-hcmt7981-emmc-squashfs-sysupgrade.bin
├── immortalwrt-mediatek-mt7981-hcmt7981-emmc-squashfs-factory.bin
└── packages/
    ├── luci-app-Secondsystem_xxx_all.ipk
    └── ...
```

## 刷入固件

### 方法一：SSH刷入 (已有OpenWrt)

```bash
# 复制固件到设备
scp bin/targets/mediatek/mt7981/immortalwrt-*.bin root@192.168.1.1:/tmp/

# SSH登录设备
ssh root@192.168.1.1

# 刷入固件 (保留配置)
sysupgrade /tmp/immortalwrt-*.bin

# 刷入固件 (不保留配置)
sysupgrade -n /tmp/immortalwrt-*.bin
```

### 方法二：U-Boot刷机 (首次刷入)

```bash
# 1. 断电
# 2. 按住Reset键
# 3. 通电
# 4. 电脑设置IP: 192.168.1.2, 子网掩码: 255.255.255.0
# 5. 浏览器访问: http://192.168.1.1
# 6. 上传固件文件
# 7. 等待刷入完成 (约5分钟)
```

### 方法三：LuCI界面刷入

```
系统 → 备份/升级 → 刷写新固件 → 上传固件 → 刷入
```

## 常见问题

### 编译报错: "Package xxx is not found"

```bash
# 更新feeds
./scripts/feeds update -a
./scripts/feeds install -a
```

### 编译报错: "No space left on device"

```bash
# 清理编译缓存
make clean

# 或者扩展磁盘空间
```

### 下载超时

```bash
# 使用国内镜像
# 编辑 feeds.conf.default
# 将 git.openwrt.org 替换为 mirrors.tuna.tsinghua.edu.cn/openwrt
```

### WiFi无法使用

```bash
# 检查WiFi驱动
lsmod | grep mt

# 检查WiFi配置
uci show wireless

# 重新配置WiFi
wifi config
```

### 5G模块不识别

```bash
# 检查USB设备
lsusb | grep 2c7c

# 检查串口
ls /dev/ttyUSB*

# 手动添加VID/PID
echo "2c7c 0900" > /sys/bus/usb-serial/drivers/option1/new_id
```

## GitHub Actions 自动编译

### 1. Fork仓库

```bash
# Fork本仓库到你的GitHub账号
```

### 2. 配置Secrets

在仓库 Settings → Secrets and variables → Actions 中添加:

- `SECRETS_KEY`: 任意字符串 (用于加密)

### 3. 触发编译

```bash
# 推送到main分支会自动触发编译
git push origin main

# 或手动触发
# Actions → Build OpenWrt → Run workflow
```

### 4. 下载固件

编译完成后在 Releases 中下载固件。

## 参考资料

- [ImmortalWrt官方文档](https://immortalwrt.org/docs)
- [OpenWrt编译指南](https://openwrt.org/docs/guide-user/additional-software/imagebuilder)
- [MT7981开发文档](https://www.mediatek.com/)
