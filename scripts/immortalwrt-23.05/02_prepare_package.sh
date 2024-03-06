#!/bin/bash

. ../scripts/funcations.sh

./scripts/feeds update -a
./scripts/feeds install -a

### Prepare package
# dae ready
cp -rf ../immortalwrt_pkg/net/dae ./feeds/packages/net/dae
ln -sf ../../../feeds/packages/net/dae ./package/feeds/packages/dae
cp -rf ../immortalwrt_pkg/net/daed ./feeds/packages/net/daed
ln -sf ../../../feeds/packages/net/daed ./package/feeds/packages/daed
cp -rf ../lucidaednext/daed-next ./package/new/daed-next
cp -rf ../lucidaednext/luci-app-daed-next ./package/new/luci-app-daed-next
# Luci-app-amlogic
git clone --depth 1 https://github.com/ophub/luci-app-amlogic.git ./package/luci-app-amlogic
# Wget
rm -rf ./feeds/packages/net/wget
cp -rf ../lede_pkg/net/wget ./feeds/packages/net/wget
# Mosdns
cp -rf ../mosdns ./package/luci-app-mosdns
rm -rf ./feeds/packages/net/v2ray-geodata
cp -rf ../mosdns_pkg ./package/v2ray-geodata
# samba4
sed -i 's,nas,services,g' package/feeds/luci/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json
# cpufreq
sed -i 's,system,services,g' package/feeds/luci/luci-app-cpufreq/root/usr/share/luci/menu.d/luci-app-cpufreq.json
# hd-idle
sed -i 's,nas,services,g' package/feeds/luci/luci-app-hd-idle/root/usr/share/luci/menu.d/luci-app-hd-idle.json
# vsftpd
pushd package/feeds/luci/luci-app-vsftpd
move_2_services nas
popd
# filebrowser
sed -i "s,PKG_VERSION:=.*,PKG_VERSION:=2\.27\.0," package/feeds/packages/filebrowser/Makefile
sed -i "s,PKG_HASH:=.*,PKG_HASH:=3a60cf26d6ded863d730bc671ee8df6dc342cab6dd867c16370eecb186fff655," package/feeds/packages/filebrowser/Makefile
# rclone
sed -i -e 's,\"nas\",\"services\",g' -e 's,NAS,Services,g' package/feeds/luci/luci-app-rclone/luasrc/controller/rclone.lua
# dockerman
pushd package/feeds/luci/luci-app-dockerman
docker_2_services
popd
# nlbw
sed -i 's,services,network,g' package/feeds/luci/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
# verysync
pushd package/feeds/luci/luci-app-verysync
move_2_services nas
popd
# curl 8.6.0 passwall 冲突降级
sed -i "s,PKG_VERSION:=.*,PKG_VERSION:=8\.5\.0," ./feeds/packages/net/curl/Makefile
sed -i "s,PKG_HASH:=.*,PKG_HASH:=ce4b6a6655431147624aaf582632a36fe1ade262d5fab385c60f78942dd8d87b," ./feeds/packages/net/curl/Makefile

exit 0
