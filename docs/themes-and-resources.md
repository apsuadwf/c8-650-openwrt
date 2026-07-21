# 主题与资源分析

## 主题列表

固件包含 **4个主题**：

| 主题 | 说明 | 大小 |
|------|------|------|
| **argon** | Argon主题 (默认) | 2.1MB |
| **bootstrap** | Bootstrap主题 | - |
| **bootstrap-dark** | Bootstrap暗黑模式 | 符号链接到bootstrap |
| **bootstrap-light** | Bootstrap亮色模式 | 符号链接到bootstrap |

## Argon主题结构

```
www/luci-static/argon/
├── background/          # 背景图片目录
├── css/                 # 样式文件
├── favicon.ico          # 网站图标
├── fonts/               # 字体文件
├── icon/                # 图标文件
│   ├── android-icon-192x192.png
│   ├── apple-icon-144x144.png
│   ├── apple-icon-60x60.png
│   ├── apple-icon-72x72.png
│   ├── arrow.svg
│   ├── browserconfig.xml
│   ├── favicon-16x16.png
│   ├── favicon-32x32.png
│   ├── favicon-96x96.png
│   ├── manifest.json
│   ├── ms-icon-144x144.png
│   └── spinner.svg
├── img/                 # 图片文件
└── js/                  # JavaScript文件
```

## 自定义主题

### 更换背景图片

```bash
# 上传新背景图
scp background.jpg root@192.168.1.1:/www/luci-static/argon/background/

# 修改CSS引用
vi /www/luci-static/argon/css/cascade.css
```

### 更换Logo

```bash
# 上传新Logo
scp logo.png root@192.168.1.1:/www/luci-static/argon/icon/

# 修改主题配置
uci set luci.theme.argon.logo='/luci-static/argon/icon/logo.png'
uci commit luci
```

## iStore资源

```
www/luci-static/istore/
├── i18n/        # 国际化文件
├── index.js     # 主JavaScript (247KB)
├── style.css    # 样式文件 (18KB)
└── vendor.js    # 第三方库 (174KB)
```

## 快速开始资源

```
www/luci-static/quickstart/
├── index.js     # 主JavaScript (337KB)
├── style.css    # 样式文件 (230KB)
└── vendor.js    # 第三方库 (583KB)
```

## 系统Banner

```
.___                               __         .__
|   | _____   _____   ____________/  |______  |  |
|   |/     \ /     \ /  _ \_  __ \   __\__  \ |  |
|   |  Y Y  \  Y Y  (  <_> )  | \/|  |  / __ \|  |__
|___|__|_|  /__|_|  /\____/|__|   |__| (____  /____/
          \/      \/  BE FREE AND UNAFRAID  \/
 -----------------------------------------------------
 ImmortalWrt 21.02-SNAPSHOT, r0-3fa9687
 -----------------------------------------------------
```

## 自定义Banner

```bash
# 编辑banner文件
vi /etc/banner

# 添加自定义信息
echo "C8-650 Custom Firmware" >> /etc/banner
echo "Built by: Your Name" >> /etc/banner
```
