# 编入 LEDE / OpenWrt 固件

面向 LEDE R26.05.20 / LuCI `openwrt-25.12`。以下命令都从 Linux 编译主机上的固件源码根目录执行。主题仓库根目录就是 LuCI 软件包目录，不需要再复制内层目录。

## 下载并选择主题

先按固件项目的流程更新并安装 feeds，确保 `feeds/luci/luci.mk` 存在，再运行：

```sh
git clone --depth 1 --branch main https://github.com/Wyatt323/luci-theme-mmwx.git package/luci-theme-mmwx
./scripts/config --enable PACKAGE_luci-theme-mmwx
make defconfig
grep '^CONFIG_PACKAGE_luci-theme-mmwx=y$' .config
```

最后一条应输出 `CONFIG_PACKAGE_luci-theme-mmwx=y`。也可在 `make menuconfig` 的 `LuCI → 4. Themes` 下选为 `*`。选为 `M` 只会构建单独的软件包。

如果编译项目在后续步骤复制自定义 `.config`，请把 `CONFIG_PACKAGE_luci-theme-mmwx=y` 加到那份配置中，避免设置被覆盖。克隆命令只在目录尚不存在时执行，已有目录按下面的更新步骤操作。

## 首次启动默认使用 MMWX

```sh
mkdir -p files/etc/uci-defaults
cp package/luci-theme-mmwx/examples/99-mmwx-default files/etc/uci-defaults/99-mmwx-default
chmod 0755 files/etc/uci-defaults/99-mmwx-default
```

该脚本仅在主题文件存在时设置默认主题。只需内置而不设为默认时，跳过这一步。

然后按原固件项目的命令编译，例如 `make -j"$(nproc)" V=s`。当前仓库没有绑定特定硬件目标，也未在完整 LEDE 编译树中验证固件构建。

## GitHub Actions 接入

在你的固件编译流程中，更新和安装 feeds 后、生成最终配置前，加入：

```sh
git clone --depth 1 --branch main https://github.com/Wyatt323/luci-theme-mmwx.git package/luci-theme-mmwx
mkdir -p files/etc/uci-defaults
cp package/luci-theme-mmwx/examples/99-mmwx-default files/etc/uci-defaults/99-mmwx-default
chmod 0755 files/etc/uci-defaults/99-mmwx-default
```

在最终使用的 `.config` 中加入：

```text
CONFIG_PACKAGE_luci-theme-mmwx=y
```

再运行 `make defconfig` 和项目原有编译步骤。公开仓库可直接拉取，无需在编译脚本中放 GitHub Token。不要同时从其他 feed 安装同名包。

## 更新已拉取的主题

```sh
git -C package/luci-theme-mmwx pull --ff-only
make package/luci-theme-mmwx/clean
```

如使用默认主题脚本，再复制一次更新后的示例脚本，然后重新编译。需要固定版本以复现构建时，将克隆步骤改为检出指定提交或已有标签。

## 固件启动后验证

```sh
uci -q get luci.main.mediaurlbase
ls /usr/share/ucode/luci/template/themes/mmwx/header.ut
wget -qO- http://127.0.0.1/cgi-bin/luci/ | grep '/luci-static/mmwx'
```

默认主题路径应为 `/luci-static/mmwx`。安装后在浏览器中按 `Ctrl+F5` 刷新缓存。
