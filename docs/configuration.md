# 配置文件分析

## 配置文件列表

固件包含 **40+个** UCI配置文件：

| 配置文件 | 功能 | 说明 |
|---------|------|------|
| advancedsetting | 高级设置 | 系统高级配置 |
| apninfo | APN信息 | 5G模块APN配置 |
| autotimeset | 定时设置 | 定时重启等 |
| cifs | CIFS挂载 | SMB网络共享 |
| dawn | DAWN | 分布式AP管理 |
| ddnsto | DDNSTO | 内网穿透 |
| dhcp | DHCP | DHCP服务器 |
| dockerd | Docker | Docker守护进程 |
| dropbear | SSH | SSH服务 |
| eqos | QoS | 流量控制 |
| etherwake | 网络唤醒 | Wake-on-LAN |
| firewall | 防火墙 | 网络防火墙 |
| ipsec | IPSec | IPSec VPN |
| istore | iStore | 应用商店 |
| kcptun | KCP隧道 | KCP加速 |
| luci | LuCI | Web界面 |
| mdadm | RAID | 磁盘阵列 |
| microsocks | SOCKS代理 | SOCKS5服务 |
| modem | Modem | 5G模块配置 |
| mtkhqos | MTK QoS | MTK硬件QoS |
| mwan3 | 多WAN | 负载均衡 |
| nlbwmon | 带宽监控 | 流量统计 |
| openvpn_recipes | OpenVPN | VPN配方 |
| pppoe | PPPoE | 拨号上网 |
| pppoe-server | PPPoE服务端 | 拨号服务端 |
| qos | QoS | 流量控制 |
| quickstart | 快速开始 | 初始设置 |
| rpcd | RPC | 远程调用 |
| samba4 | Samba | SMB文件共享 |
| shadowsocks-libev | SS | Shadowsocks |
| sms_tool | SMS | 短信工具 |
| timecontrol | 时间控制 | 定时开关 |
| ttyd | Web终端 | 浏览器终端 |
| turboacc | TurboACC | 网络加速 |
| ucitrack | UCI跟踪 | 配置跟踪 |
| uhttpd | HTTP服务 | Web服务器 |
| umdns | mDNS | 多播DNS |
| upnpd | UPnP | 端口转发 |
| webrestriction | 网站限制 | 上网管理 |
| weburl | URL过滤 | 网址过滤 |
| xray | Xray | 代理工具 |

## 关键配置详解

### 1. SMS工具配置 (`/etc/config/sms_tool`)

```
config sms_tool 'general'
    option prefix '1'
    option sendport '/dev/ttyUSB2'    # 发送端口
    option ussdport '/dev/ttyUSB2'    # USSD端口
    option atport '/dev/ttyUSB2'      # AT指令端口
    option readport '/dev/ttyUSB2'    # 读取端口
    option storage 'ME'               # 存储位置
    option pnumber '86'               # 国家代码
    option mergesms '1'               # 合并长短信
    option information '0'
    option algorithm 'Advanced'
    option direction 'Start'
```

### 2. Modem配置 (`/etc/config/modem`)

```
config ndis
    option enable '1'                 # 启用NDIS
    option simsel '0'                 # SIM卡选择
    option smode '0'                  # 网络模式
    option bandlist_lte '0'           # LTE频段
    option bandlist_nr '0'            # 5G频段
    option pingen '0'                 # 启用ping
    option pingaddr '119.29.29.29'    # ping地址
    option count '5'                  # ping次数
```

### 3. Docker配置 (`/etc/config/dockerd`)

```
config globals 'globals'
    option data_root '/opt/docker/'   # Docker数据目录
    option log_level 'warn'           # 日志级别
    option iptables '1'               # 启用iptables

config firewall 'firewall'
    option device 'docker0'           # Docker网络设备
    list blocked_interfaces 'wan'     # 阻止WAN访问
```

### 4. 防火墙配置 (`/etc/config/firewall`)

**默认规则**:
- INPUT: ACCEPT
- OUTPUT: ACCEPT
- FORWARD: REJECT
- FullCone NAT: 禁用

**区域配置**:
- LAN: 允许所有
- WAN: 拒绝入站，允许出站

**转发规则**:
- LAN → WAN: 允许

**自定义规则**:
- Allow-DHCP-Renew: UDP 68
- Allow-Ping: ICMP echo
- Allow-IGMP: IGMP
- Allow-DHCPv6: UDP 546
- Allow-MLD: ICMPv6
- Allow-ICMPv6-Input: ICMPv6
- Allow-ICMPv6-Forward: ICMPv6
- Allow-IPSec-ESP: ESP
- Allow-ISAKMP: UDP 500
- Support-UDP-Traceroute: UDP 33434-33689 (禁用)

### 5. TurboACC配置 (`/etc/config/turboacc`)

```
config turboacc 'global'
    option set '0'                    # 禁用 (默认)

config turboacc 'config'
    # 各项加速功能配置
```

### 6. DDNSTO配置 (`/etc/config/ddnsto`)

```
config ddnsto
    option enabled '0'                # 禁用 (默认)
    option feat_port '3033'           # 功能端口
    option feat_enabled '0'           # 禁用功能
    option index '0'
```

## 自定义配置建议

### 启用FullCate NAT

```bash
uci set firewall.@defaults[0].fullcone='1'
uci commit firewall
/etc/init.d/firewall restart
```

### 修改LAN IP地址

```bash
uci set network.lan.ipaddr='192.168.10.1'
uci commit network
/etc/init.d/network restart
```

### 启用IPv6

```bash
uci set firewall.@defaults[0].disable_ipv6='0'
uci commit firewall
/etc/init.d/firewall restart
```

### 配置DNS

```bash
uci set dhcp.@dnsmasq[0].server='119.29.29.29'
uci set dhcp.@dnsmasq[0].noresolv='1'
uci commit dhcp
/etc/init.d/dnsmasq restart
```

### 配置WiFi

```bash
# 2.4GHz
uci set wireless.default_radio0.ssid='MyWiFi'
uci set wireless.default_radio0.key='password123'
uci set wireless.default_radio0.encryption='psk2'

# 5GHz
uci set wireless.default_radio1.ssid='MyWiFi-5G'
uci set wireless.default_radio1.key='password123'
uci set wireless.default_radio1.encryption='psk2'

uci commit wireless
wifi
```

### 启用Docker

```bash
uci set dockerd.@globals[0].data_root='/opt/docker/'
uci commit dockerd
/etc/init.d/dockerd start
```

### 配置5G模块

```bash
# 设置APN
uci set network.wwan=interface
uci set network.wwan.proto='ncm'
uci set network.wwan.device='/dev/ttyUSB2'
uci set network.wwan.apn='cmnet'
uci commit network
/etc/init.d/network restart
```

## 备份与恢复

### 备份配置

```bash
# 备份所有配置
sysupgrade -b /tmp/backup.tar.gz

# 下载备份
scp root@192.168.1.1:/tmp/backup.tar.gz ./
```

### 恢复配置

```bash
# 上传备份
scp backup.tar.gz root@192.168.1.1:/tmp/

# 恢复配置
sysupgrade -r /tmp/backup.tar.gz
```

### 恢复出厂设置

```bash
# 方法1: 命令行
firstboot -y && reboot

# 方法2: 物理按键
# 断电 → 按住Reset键10秒 → 通电 → 等待重启
```
