# 重大发现：OpenWrt 官方已支持 C8-668GL/C8-650

## 背景

经过固件逆向分析和源码搜索，发现 **NRadio C8-668GL 已被合并到 OpenWrt 官方源码**！

## 关键信息

### 官方提交

```
提交地址: https://git.openwrt.org/openwrt/openwrt/commit?id=6b32a5d768847b7d0e9222adecbcb66e367abbfc
标题: mediatek: filogic: add support for NRadio C8-668GL
状态: 已合并到 OpenWrt 官方
```

### 设备信息

```dts
model = "NRadio C8-668GL";
compatible = "nradio,c8-668gl", "mediatek,mt7981";
```

### C8-650 与 C8-668 的关系

| 型号 | 5G模块 | 其他 |
|------|--------|------|
| C8-650 | RM500U (紫光展锐) | 相同硬件 |
| C8-668 | RM500Q (高通) | 相同硬件 |
| C8-668GL | RM500Q-GL (高通全球版) | 相同硬件 |

**结论：C8-650 和 C8-668 只是 5G 模块不同，硬件平台完全相同，固件通用。**

## RM500U 驱动支持

### 驱动已在官方源码中

| 模式 | 驱动包 | 状态 |
|------|--------|------|
| **NCM** (推荐) | `kmod-usb-net-cdc-ncm` | ✅ 官方支持 |
| RNDIS | `kmod-usb-net-rndis` | ✅ 官方支持 |
| ECM | `kmod-usb-net-cdc-ecm` | ✅ 官方支持 |
| MBIM | `kmod-usb-net-cdc-mbim` | ✅ 官方支持 |
| AT指令 | `kmod-usb-serial-option` | ✅ 官方支持 |

### 为什么不需要额外驱动

RM500U 使用标准 USB 通信协议：
- **VID**: `2c7c` (Quectel)
- **PID**: `0900` (RM500U)
- 这个 VID/PID 已经在 Linux 内核的 `option` 驱动中

```bash
# 检查内核是否支持
ls /lib/modules/*/kernel/drivers/usb/serial/option.ko

# 检查 VID/PID 是否在驱动中
grep "2c7c" /lib/modules/*/kernel/drivers/usb/serial/option.ko
```

## 新的编译方法

### 方法一：使用 OpenWrt 官方源码（推荐）

```bash
# 1. 克隆 OpenWrt 官方源码（包含 C8-668GL 支持）
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt

# 2. 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 配置编译（选择 C8-668GL）
make menuconfig
# Target: MediaTek Ralink MIPS → MT7981
# Target Profile: NRadio C8-668GL

# 4. 添加自定义插件
cp -r /path/to/c8-650-openwrt/luci-apps/luci-app-Secondsystem package/

# 5. 使用我们的配置
cp /path/to/c8-650-openwrt/config/.config .
make defconfig

# 6. 编译
make download -j8
make -j$(nproc) V=s
```

### 方法二：使用 ImmortalWrt 源码

```bash
# 1. 克隆 ImmortalWrt 源码
git clone -b openwrt-23.05 https://github.com/immortalwrt/immortalwrt.git
cd immortalwrt

# 2. 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 配置编译
make menuconfig
# Target: MediaTek Ralink MIPS → MT7981
# Target Profile: 选择 C8-668GL 或 Generic

# 4. 添加自定义插件
cp -r /path/to/c8-650-openwrt/luci-apps/luci-app-Secondsystem package/

# 5. 使用我们的配置
cp /path/to/c8-650-openwrt/config/.config .
make defconfig

# 6. 编译
make download -j8
make -j$(nproc) V=s
```

## 设备树关键信息

从官方提交的 dts 文件可以看到：

```dts
// 按键
reset → GPIO 1
wps → GPIO 9

// LED
power → GPIO 10 (绿色)
5G → GPIO 11 (蓝色)
4G → GPIO 12 (蓝色)
WiFi → GPIO 13 (蓝色)

// 5G模块控制
cpe-pwr → GPIO 31 (电源)
cpe-sel0 → GPIO 30 (选择)

// 启动参数
bootargs = "console=ttyS0,115200n1 root=PARTLABEL=rootfs_2nd rootwait"
```

## 编译时需要勾选的驱动

```bash
# 在 make menuconfig 中勾选
Kernel Modules → USB Support →
  [*] kmod-usb-core
  [*] kmod-usb2
  [*] kmod-usb3
  [*] kmod-usb-serial
  [*] kmod-usb-serial-option      # AT指令
  [*] kmod-usb-net
  [*] kmod-usb-net-cdc-ncm        # NCM模式（推荐）
  [*] kmod-usb-net-rndis          # RNDIS模式
  [*] kmod-usb-net-cdc-mbim       # MBIM模式
  [*] kmod-usb-net-cdc-ecm        # ECM模式
```

## 总结

| 项目 | 状态 |
|------|------|
| **官方支持** | ✅ C8-668GL 已被 OpenWrt 官方支持 |
| **设备树** | ✅ 已包含在官方源码中 |
| **5G驱动** | ✅ RM500U 标准驱动已包含 |
| **编译配置** | ✅ 可直接使用 OpenWrt 官方配置 |
| **自定义插件** | ✅ 可添加 Secondsystem 等插件 |

**结论：不需要额外找驱动或源码，直接用 OpenWrt 官方源码编译就能支持 C8-650 + RM500U！**

## 参考链接

- [OpenWrt 官方提交](https://git.openwrt.org/openwrt/openwrt/commit?id=6b32a5d768847b7d0e9222adecbcb66e367abbfc)
- [ImmortalWrt 官方仓库](https://github.com/immortalwrt/immortalwrt)
- [Quectel RM500U 驱动文档](https://forumschinese.quectel.com/)
