# 固件详细分析

## 固件基本信息

| 项目 | 值 |
|------|-----|
| **文件名** | C8-650双系统-4.6.6移远-常规版.bin |
| **大小** | 106MB |
| **格式** | POSIX tar archive |
| **编译者** | manper (恩山论坛) |
| **编译日期** | 2024-02-25 |
| **系统版本** | ImmortalWrt 21.02-SNAPSHOT |
| **内核版本** | Linux 5.4.255 |
| **架构** | ARM64 (aarch64) |
| **目标平台** | mediatek/mt7981 |
| **设备标识** | nradio_wt9108_No2-manper_650 |
| **压缩方式** | SquashFS + XZ |

## 固件结构

```
固件.bin (tar格式)
├── CONTROL                          # 设备信息
├── kernel                           # 内核镜像 (3.5MB)
└── root                             # SquashFS根文件系统 (103MB)
    ├── bin/                         # 基础命令
    ├── dev/                         # 设备文件
    ├── etc/                         # 配置文件
    │   ├── config/                  # UCI配置
    │   ├── init.d/                  # 启动脚本
    │   └── modules.d/               # 内核模块配置
    ├── lib/                         # 库文件
    │   ├── modules/                 # 内核模块
    │   └── lua/                     # Lua库
    ├── opt/                         # 可选软件
    ├── overlay/                     # 可写层
    ├── rom/                         # 只读根
    ├── sbin/                        # 系统命令
    ├── tmp/                         # 临时文件
    ├── usr/                         # 用户程序
    │   ├── bin/                     # 用户命令
    │   ├── lib/                     # 用户库
    │   │   ├── lua/luci/            # LuCI界面
    │   │   └── opkg/               # 包管理
    │   └── sbin/                    # 系统管理命令
    └── var/                         # 变量数据
        └── www/                     # Web根目录
```

## SquashFS信息

| 项目 | 值 |
|------|-----|
| **Magic** | hsqs (little-endian) |
| **版本** | 4.0 |
| **压缩算法** | XZ |
| **大小** | 107,072,736 bytes |
| **Inode数量** | 7,169 |
| **块大小** | 262,144 bytes (256KB) |
| **创建时间** | 2024-02-25 04:28:13 |

## 解包方法

### 方法一：使用binwalk (推荐)

```bash
# 安装工具
sudo apt install squashfs-tools binwalk

# 解包固件
binwalk --run-as=root -e C8-650双系统-4.6.6移远-常规版.bin

# 进入解压目录
cd _C8-650双系统-4.6.6移远-常规版.bin.extracted/

# 解压tar
tar -xf 0.tar

# 解压SquashFS
unsquashfs -f -d rootfs/ sysupgrade-nradio_wt9108_No2-manper_650/root
```

### 方法二：使用dd手动提取

```bash
# 找到SquashFS偏移
binwalk C8-650双系统-4.6.6移远-常规版.bin | grep squashfs
# 输出: 3629056  0x375E00  Squashfs filesystem, little endian, version 4.0, xz compressed

# 提取SquashFS
dd if=C8-650双系统-4.6.6移远-常规版.bin of=root.squashfs bs=1 skip=3629056

# 解压
unsquashfs -f -d rootfs/ root.squashfs
```

### 方法三：使用Docker (无需安装工具)

```bash
docker run --rm -v $(pwd):/firmware:ro -v $(pwd)/output:/output \
  ubuntu:22.04 bash -c "
    apt-get update -qq && 
    apt-get install -y -qq squashfs-tools binwalk &&
    cd /output &&
    binwalk --run-as=root -e /firmware/*.bin
  "
```

## 关键配置文件

### 网络配置

```bash
# /etc/config/network
# (解压后为空，运行时生成)

# /etc/config/wireless
# (解压后为空，运行时生成)
```

### 5G模块配置

```bash
# /etc/config/sms_tool
config sms_tool
    option sendport '/dev/ttyUSB2'
    option ussdport '/dev/ttyUSB2'
    option atport '/dev/ttyUSB2'
    option readport '/dev/ttyUSB2'
```

### 内核模块

```bash
# /etc/modules.d/usb-net-cdc-ncm
# NCM网络驱动

# /etc/modules.d/usb-net-qmi-wwan
# QMI网络驱动

# /etc/modules.d/usb-serial-wwan
# 串口驱动
```

## 自定义LuCI应用

### Secondsystem (切换回官方系统)

**控制器**: `/usr/lib/lua/luci/controller/Secondsystem.lua`

```lua
module("luci.controller.Secondsystem", package.seeall)

function index()
    entry({"admin", "system", "Secondsystem"}, alias("admin", "system", "Secondsystem", "settings"), _("官方系统"), 50)
    entry({"admin", "system", "Secondsystem", "settings"}, template("Secondsystem/settings"), _("Settings"), 10)
    entry({"admin", "system", "Secondsystem", "switch"}, call("action_switch"), nil)
    entry({"admin", "system", "Secondsystem", "reboots"}, call("action_reboots"), nil)
end

function action_switch()
    local sys = require "luci.sys"
    local http = require "luci.http"
    local confirm = http.formvalue("confirm")
    
    if confirm and confirm == "yes" then
        sys.call("fw_setenv boot_system 0")
        sys.call("reboot")
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "system", "Secondsystem", "settings"))
    end
end

function action_reboots()
    local sys = require "luci.sys"
    local http = require "luci.http"
    local command = 'AT+CFUN=1,1'
    local sendat = 'sendat 2 "' .. command .. '"'
    local confirm = http.formvalue("confirm")
    
    if confirm and confirm == "yes" then
        sys.call(sendat)
        sys.call("reboot")
    else
        luci.http.redirect(luci.dispatcher.build_url("admin", "system", "Secondsystem", "settings"))
    end
end
```

**视图**: `/usr/lib/lua/luci/view/Secondsystem/settings.htm`

(见 luci-app-Secondsystem 目录)

### Smstrun (短信功能)

**控制器**: `/usr/lib/lua/luci/controller/Smstrun.lua`

**视图**: `/usr/lib/lua/luci/view/Smstrun/`

(见 luci-app-Smstrun 目录)

## 5G模块信息

### RM500U USB接口

| 接口 | 用途 | 设备 |
|------|------|------|
| 接口0/1 | USB网卡 | usb0/wwan0 |
| 接口2 | DIAG | /dev/ttyUSB0 |
| 接口3 | LOG | /dev/ttyUSB1 |
| 接口4 | AT指令 | /dev/ttyUSB2 |
| 接口5 | Modem | /dev/ttyUSB3 |
| 接口6 | NMEA (GPS) | /dev/ttyUSB4 |
| 接口7 | ADB | - |

### 常用AT指令

```bash
# 测试连接
echo "AT" | picocom -b 115200 /dev/ttyUSB2

# 查询信号强度
echo "AT+CSQ" | picocom -b 115200 /dev/ttyUSB2

# 查询网络注册状态
echo "AT+CEREG?" | picocom -b 115200 /dev/ttyUSB2

# 查询运营商
echo "AT+COPS?" | picocom -b 115200 /dev/ttyUSB2

# 查询IMEI
echo "AT+CGSN" | picocom -b 115200 /dev/ttyUSB2

# 重启模块
echo "AT+CFUN=1,1" | picocom -b 115200 /dev/ttyUSB2
```

## 双系统切换原理

### U-Boot环境变量

```bash
# 查看当前启动系统
fw_printenv boot_system

# 切换到系统1（官方固件）
fw_setenv boot_system 0

# 切换到系统2（OpenWrt）
fw_setenv boot_system 1
```

### 分区布局

```
Flash/eMMC:
├── bootloader (U-Boot)
├── env (环境变量)
├── system1 (官方固件)
└── system2 (OpenWrt)
```

### 物理按键切换

1. 断电
2. 按住Reset键（旧版按WPS键）
3. 通电
4. 等待电源灯亮起
5. 松开按键
6. 系统自动切换并重启
