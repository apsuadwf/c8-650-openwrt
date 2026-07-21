# C8-650 OpenWrt/ImmortalWrt 自定义固件

基于鲲鹏无限 C8-650 5G CPE 的 ImmortalWrt 固件分析与自定义编译项目。

## ⭐ 重大发现：OpenWrt 官方已支持！

**NRadio C8-668GL 已被合并到 OpenWrt 官方源码**，C8-650 与 C8-668 硬件相同，可直接使用官方源码编译！

- 📖 [官方支持详情](docs/official-support.md)
- 🔗 [OpenWrt 官方提交](https://git.openwrt.org/openwrt/openwrt/commit?id=6b32a5d768847b7d0e9222adecbcb66e367abbfc)

## 设备信息

| 项目 | 值 |
|------|-----|
| **设备** | 鲲鹏无限 C8-650 |
| **SoC** | MediaTek MT7981 (Filogic 830) ARM64 |
| **5G模块** | Quectel RM500U (VID:2c7c, PID:0900) |
| **RAM** | 256MB |
| **ROM** | eMMC |
| **WiFi** | MT7915E (WiFi 6) |
| **系统** | ImmortalWrt 21.02-SNAPSHOT |
| **内核** | Linux 5.4.255 |
| **双系统** | 支持（官方固件 + OpenWrt） |

## 固件分析

基于 manper 编译的 `C8-650双系统-4.6.6移远-常规版.bin` 固件逆向分析。

### 核心特性

- ✅ 双系统切换（官方 ↔ OpenWrt）
- ✅ 5G模块 RM500U 完整支持
- ✅ Docker 容器支持
- ✅ iStore 应用商店
- ✅ 多种代理工具（Xray、SSR、Hysteria）
- ✅ 短信收发功能
- ✅ 网络加速（TurboACC MTK版）

## 仓库结构

```
c8-650-openwrt/
├── README.md                    # 本文件
├── .github/workflows/
│   └── build.yml                # GitHub Actions 自动编译
├── docs/
│   ├── firmware-analysis.md     # 固件详细分析
│   ├── package-list.md          # 完整包列表 (280+包)
│   ├── build-guide.md           # 编译指南
│   ├── configuration.md         # 配置文件详解
│   ├── themes-and-resources.md  # 主题与资源分析
│   └── official-support.md      # ⭐ 官方支持信息
├── config/
│   └── .config                  # 编译配置文件
├── luci-apps/
│   └── luci-app-Secondsystem/   # 切换回官方系统插件
├── scripts/
│   ├── extract-firmware.sh      # 固件解包脚本
│   ├── 5g-setup.sh              # 5G模块配置脚本
│   └── switch-system.sh         # 双系统切换脚本
└── patches/
    └── README.md                # 补丁说明
```

## 快速开始

### 方法一：GitHub Actions 自动编译（最简单）

1. Fork 本仓库
2. 修改 `config/.config` 添加/删除插件
3. 推送到 master 分支
4. 自动编译，固件在 Actions 里下载

### 方法二：使用 OpenWrt 官方源码（推荐）

```bash
# 1. 克隆 OpenWrt 官方源码（包含 C8-668GL 支持）
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt

# 2. 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 添加自定义插件
cp -r /path/to/c8-650-openwrt/luci-apps/luci-app-Secondsystem package/

# 4. 使用配置
cp /path/to/c8-650-openwrt/config/.config .
make defconfig

# 5. 编译
make download -j8
make -j$(nproc) V=s
```

### 方法三：使用 ImmortalWrt 源码

```bash
# 1. 克隆 ImmortalWrt 源码
git clone -b openwrt-23.05 https://github.com/immortalwrt/immortalwrt.git
cd immortalwrt

# 2. 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 3. 添加自定义插件
cp -r /path/to/c8-650-openwrt/luci-apps/luci-app-Secondsystem package/

# 4. 使用配置
cp /path/to/c8-650-openwrt/config/.config .
make defconfig

# 5. 编译
make download -j8
make -j$(nproc) V=s
```

## 双系统切换

### 方法一：LuCI界面（推荐）

访问 `http://192.168.66.1` → 系统 → 官方系统 → 点击"切换到官方系统"

### 方法二：SSH命令

```bash
# 切换到官方系统（系统1）
fw_setenv boot_system 0
reboot

# 切换到OpenWrt（系统2）
fw_setenv boot_system 1
reboot
```

### 方法三：物理按键

断电 → 按住Reset键 → 通电 → 等待电源灯亮起 → 松开按键

## 5G模块配置

### 检查模块状态

```bash
# 检查USB设备
lsusb | grep 2c7c

# 检查串口
ls /dev/ttyUSB*

# 测试AT指令
echo "AT" | picocom -b 115200 /dev/ttyUSB2
```

### 拨号配置

```bash
# 编辑网络配置
uci set network.wwan=interface
uci set network.wwan.proto='ncm'
uci set network.wwan.device='/dev/ttyUSB2'
uci set network.wwan.apn='cmnet'  # 移动:cmnet, 联通:3gnet, 电信用:ctnet
uci commit network
```

## 已知问题

1. **WiFi配置**：首次启动需要手动配置WiFi密码
2. **5G模块**：部分模块可能需要手动添加VID/PID到驱动
3. **存储空间**：eMMC空间有限，建议使用Docker时挂载外部存储

## 参考资料

- [OpenWrt 官方源码](https://git.openwrt.org/openwrt/openwrt)
- [ImmortalWrt 官方仓库](https://github.com/immortalwrt/immortalwrt)
- [OpenWrt C8-668GL 支持提交](https://git.openwrt.org/openwrt/openwrt/commit?id=6b32a5d768847b7d0e9222adecbcb66e367abbfc)
- [恩山论坛 C8-650 帖子](https://www.right.com.cn/forum/thread-8367374-1-1.html)
- [Quectel RM500U 驱动文档](https://forumschinese.quectel.com/)
- [OpenWrt Wiki](https://openwrt.org/docs/start)

## 致谢

- [manper](https://www.right.com.cn/forum/thread-8367374-1-1.html) - 原始固件编译者
- [OpenWrt 社区](https://openwrt.org/) - 官方支持
- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) - 基础源码

## 许可证

本项目基于 GPL-2.0 许可证开源。
