# 完整包列表

基于固件解包分析，共包含 **280+** 个软件包。

## LuCI应用 (30个)

| 包名 | 功能 | 说明 |
|------|------|------|
| luci-app-Secondsystem | 切换回官方系统 | ⭐ 自定义插件 |
| luci-app-Smstrun | 短信功能 | ⭐ 自定义插件 |
| luci-app-advancedsetting | 高级设置 | 系统高级配置 |
| luci-app-arpbind | ARP绑定 | IP/MAC绑定 |
| luci-app-autotimeset | 定时设置 | 定时重启等 |
| luci-app-cellscan | 基站扫描 | 5G/4G基站扫描 |
| luci-app-cifs-mount | CIFS挂载 | SMB网络共享 |
| luci-app-ddnsto | DDNSTO | 内网穿透 |
| luci-app-diskman | 磁盘管理 | 分区、格式化 |
| luci-app-dockerman | Docker管理 | 容器管理界面 |
| luci-app-eqos-mtk | QoS | MTK专用QoS |
| luci-app-filetransfer | 文件传输 | 上传下载文件 |
| luci-app-firewall | 防火墙 | 网络防火墙 |
| luci-app-ipsec-vpnserver-manyusers | IPSec VPN | VPN服务端 |
| luci-app-mtwifi-cfg | WiFi配置 | MTK专用WiFi |
| luci-app-nlbwmon | 带宽监控 | 网络流量统计 |
| luci-app-openvpn | OpenVPN | VPN客户端 |
| luci-app-opkg | 软件包管理 | 安装卸载包 |
| luci-app-pppoe-server | PPPoE服务端 | 拨号服务端 |
| luci-app-quickstart | 快速开始 | 初始设置向导 |
| luci-app-ramfree | 释放内存 | 内存优化 |
| luci-app-samba4 | Samba | SMB文件共享 |
| luci-app-sms-tool | 短信工具 | AT指令、短信 |
| luci-app-store | iStore | 应用商店 |
| luci-app-timecontrol | 时间控制 | 定时开关机 |
| luci-app-ttyd | Web终端 | 浏览器终端 |
| luci-app-turboacc-mtk | 网络加速 | MTK专用加速 |
| luci-app-upnp | UPnP | 端口自动转发 |
| luci-app-webrestriction | 网站限制 | 上网行为管理 |
| luci-app-weburl | URL过滤 | 网址过滤 |
| luci-app-wol | 网络唤醒 | Wake-on-LAN |
| luci-app-zmodem | Zmodem | 文件传输协议 |

## 代理工具 (10个)

| 包名 | 说明 |
|------|------|
| xray-core | Xray核心 (VLESS/VMess/Trojan) |
| shadowsocks-libev-ss-local | SS客户端 |
| shadowsocks-libev-ss-redir | SS透明代理 |
| shadowsocksr-libev-ssr-local | SSR客户端 |
| shadowsocksr-libev-ssr-redir | SSR透明代理 |
| hysteria | Hysteria (基于QUIC) |
| chinadns-ng | 国内DNS分流 |
| dns2socks | DNS转SOCKS |
| ipt2socks | 透明代理转SOCKS |
| simple-obfs-client | Simple-Obfs混淆 |

## 5G/4G模块支持 (15个)

| 包名 | 说明 |
|------|------|
| kmod-usb-core | USB核心驱动 |
| kmod-usb2 | USB 2.0 |
| kmod-usb3 | USB 3.0 |
| kmod-usb-serial | USB串口 |
| kmod-usb-serial-option | Option驱动 (AT指令) |
| kmod-usb-serial-wwan | WWAN串口 |
| kmod-usb-serial-qualcomm | 高通串口 |
| kmod-usb-net | USB网卡 |
| kmod-usb-net-cdc-ncm | NCM网络 (主要) |
| kmod-usb-net-rndis | RNDIS网络 |
| kmod-usb-net-cdc-mbim | MBIM网络 |
| kmod-usb-net-cdc-ether | ECM网络 |
| kmod-usb-net-qmi-wwan | QMI网络 |
| usb-modeswitch | USB模式切换 |
| comgt | 拨号工具 |

## 网络工具 (20个)

| 包名 | 说明 |
|------|------|
| curl | HTTP客户端 |
| wget-ssl | 下载工具 |
| ip-full | IP工具 |
| tcpdump | 抓包工具 |
| ethtool | 网卡工具 |
| ipset | IP集合 |
| iptables | 防火墙 |
| ip6tables | IPv6防火墙 |
| dnsmasq-full | DNS/DHCP |
| miniupnpd | UPnP |
| mwan3 | 多WAN负载均衡 |
| nlbwmon | 带宽监控 |
| bridge | 网桥 |
| vlan | VLAN |
| bonding | 网卡绑定 |
| batctl-default | B.A.T.M.A.N. |
| wireless-tools | 无线工具 |
| wpad-mesh-openssl | Mesh网络 |
| hostapd-common | 热点 |
| iw | 无线工具 |

## 系统工具 (30个)

| 包名 | 说明 |
|------|------|
| bash | Bash Shell |
| htop | 进程监控 |
| nano | 文本编辑器 |
| vim | 文本编辑器 |
| tar | 压缩工具 |
| unzip | 解压工具 |
| coreutils | 基础工具 |
| procps-ng | 进程工具 |
| shadow | 用户管理 |
| sudo | 权限管理 |
| openssh-sftp-server | SFTP |
| ttyd | Web终端 |
| screen | 终端复用 |
| tmux | 终端复用 |
| rsync | 文件同步 |
| git | 版本控制 |
| python3 | Python3 |
| ruby | Ruby |
| lua | Lua |
| smartmontools | 硬盘监控 |
| parted | 分区工具 |
| lsblk | 块设备列表 |
| mount-utils | 挂载工具 |
| e2fsprogs | ext4工具 |
| btrfs-progs | Btrfs工具 |
| mdadm | RAID管理 |
| zram-swap | ZRAM交换 |
| irqbalance | 中断均衡 |
| sched-cake | CAKE队列 |
| sched-connmark | 连接标记 |

## Docker支持 (8个)

| 包名 | 说明 |
|------|------|
| docker | Docker CLI |
| dockerd | Docker守护进程 |
| containerd | 容器运行时 |
| runc | 容器运行时 |
| cgroupfs-mount | Cgroup挂载 |
| luci-lib-docker | LuCI Docker库 |
| luci-app-dockerman | Docker管理界面 |
| tini | init进程 |

## 内核模块 (100+个)

### USB相关
- kmod-usb-core, kmod-usb2, kmod-usb3
- kmod-usb-serial, kmod-usb-serial-option
- kmod-usb-net, kmod-usb-net-cdc-ncm
- kmod-usb-net-rndis, kmod-usb-net-cdc-mbim

### 网络相关
- kmod-nf-conntrack, kmod-nf-nat
- kmod-ipt-core, kmod-ipt-nat
- kmod-ipt-fullconenat, kmod-ipt-tproxy
- kmod-ipsec, kmod-wireguard
- kmod-macvlan, kmod-veth

### 存储相关
- kmod-scsi-core, kmod-ata-core
- kmod-fs-ext4, kmod-fs-btrfs
- kmod-fs-cifs, kmod-fs-nfsd
- kmod-dm, kmod-md-raid

### WiFi相关
- kmod-mt_wifi (MTK WiFi驱动)
- kmod-cfg80211, kmod-conninfra

## 主题 (2个)

| 包名 | 说明 |
|------|------|
| luci-theme-argon | Argon主题 (默认) |
| luci-theme-bootstrap | Bootstrap主题 |

## 协议支持

| 包名 | 说明 |
|------|------|
| strongswan | IPSec VPN |
| xl2tpd | L2TP |
| openvpn | OpenVPN |
| wireguard | WireGuard |
| ppp | PPP拨号 |
| ppp-mod-pppoe | PPPoE |
| ppp-mod-pppol2tp | PPPoL2TP |

## 其他服务

| 包名 | 说明 |
|------|------|
| samba4-server | SMB服务 |
| miniupnpd | UPnP服务 |
| vlmcsd | KMS服务 |
| ddnsto | DDNSTO服务 |
| wsdd2 | WS-Discovery |
| avahi-dbus-daemon | mDNS |
