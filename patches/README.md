# 补丁说明

本目录用于存放编译时需要的补丁文件。

## 常用补丁

### 1. 5G模块VID/PID补丁

如果RM500U模块无法自动识别，需要添加VID/PID到option驱动。

**文件**: `rm500u-vid-pid.patch`

```diff
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -xxx,6 +xxx,7 @@ static const struct usb_device_id option_ids[] = {
+	{ USB_DEVICE(0x2c7c, 0x0900) },  /* Quectel RM500U */
 	{ } /* Terminating entry */
 };
```

### 2. 内核配置补丁

用于启用特定的内核功能。

**文件**: `kernel-config.patch`

### 3. LuCI界面补丁

用于修改LuCI界面。

**文件**: `luci-ui.patch`

## 使用方法

```bash
# 应用补丁
cd /path/to/immortalwrt
git apply /path/to/c8-650-openwrt/patches/xxx.patch

# 或者使用quilt
quilt push -a
```

## 注意事项

1. 补丁文件需要与源码版本匹配
2. 应用补丁前建议备份源码
3. 如果补丁应用失败，检查上下文是否匹配

## 参考

- [OpenWrt补丁系统](https://openwrt.org/docs/guide-developer/toolchain/use-patches-with-buildsystem)
- [Quilt使用指南](https://wiki.debian.org/UsingQuilt)
