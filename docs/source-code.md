# 源码仓库

## 官方源码仓库

**找到了！** 完整的 OpenWrt 编译系统源码：

https://github.com/zhongweijie95/NRadio-CPE-NO2

### 仓库信息

| 项目 | 值 |
|------|-----|
| **源码基础** | https://github.com/hanwckf/immortalwrt-mt798x |
| **设备支持** | NRadio-C8/650/660/668/680/688/688-Pro/C5800 |
| **5G模块** | RM500U, X62 (RM520N) |
| **双系统** | ✅ 支持 |
| **iStore** | ✅ 集成 |

### 自定义 LuCI 插件

| 插件 | 功能 |
|------|------|
| luci-app-ModemATSD | AK68 控制器 |
| luci-app-WTModem | 内置蜂窝控制器 |
| luci-app-cellscan | 基站扫描 |
| luci-app-Secondsystem | 系统切换器 |
| luci-app-Secondsystem660 | 系统切换器 (660) |
| luci-app-Smstrun | 短信转发 |

### 使用方法

```bash
# 1. 克隆源码
git clone https://github.com/zhongweijie95/NRadio-CPE-NO2.git
cd NRadio-CPE-NO2

# 2. 初始化编译环境
./init_build_environment.sh

# 3. 配置编译选项
make menuconfig

# 4. 编译固件
make -j$(nproc) V=s

# 5. 固件位置
ls bin/targets/mediatek/mt798x/
```

### 编译环境要求

- Ubuntu 20.04 LTS (推荐)
- 至少 4GB RAM
- 至少 25GB 磁盘空间
- 稳定的网络连接

### 参考链接

- [原始分支](https://github.com/hanwckf/immortalwrt-mt798x)
- [X62 蜂窝程序](https://github.com/Zy143L/luci-app-zmodem)
- [OpenWrt 官方](https://openwrt.org)
