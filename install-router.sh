#!/bin/sh
set -eu

cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
	echo "Run this script as root on the OpenWrt router." >&2
	exit 1
fi

if [ ! -d /usr/share/ucode/luci/template/themes ] || [ ! -d /www/luci-static/resources ]; then
	echo "A modern LuCI installation with ucode templates is required." >&2
	exit 1
fi

for template in ucode/template/themes/mmwx/*.ut; do
	if grep -q '{% else:' "$template"; then
		echo "Invalid LuCI template syntax in $template: use {% else %}." >&2
		exit 1
	fi
done

previous_theme="$(uci -q get luci.main.mediaurlbase || true)"
echo "Previous theme: ${previous_theme:-unknown}"

cp -R htdocs/. /www/
cp -R ucode/. /usr/share/ucode/luci/

uci set luci.themes.MMWX='/luci-static/mmwx'
uci set luci.main.mediaurlbase='/luci-static/mmwx'
uci commit luci

rm -f /tmp/luci-indexcache.*
/etc/init.d/rpcd reload >/dev/null 2>&1 || true

echo "MMWX theme installed and selected. Refresh LuCI in the browser."
