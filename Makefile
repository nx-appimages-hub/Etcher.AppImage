# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)

all: clean	

	mkdir --parents $(PWD)/build
	
	wget --output-document=$(PWD)/build/build.zip https://github.com/balena-io/etcher/releases/download/v1.5.111/balena-etcher-electron-1.5.111-linux-x64.zip
	unzip $(PWD)/build/build.zip -d $(PWD)/build
	
	wget --output-document=$(PWD)/build/build.rpm http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/gtk3-3.22.30-5.el8.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatk-1_0-0-2.34.1-lp152.1.7.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatk-bridge-2_0-0-2.34.1-lp152.1.5.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..

	wget --output-document=$(PWD)/build/build.rpm https://ftp.lysator.liu.se/pub/opensuse/distribution/leap/15.2/repo/oss/x86_64/libatspi0-2.34.0-lp152.2.4.x86_64.rpm
	cd $(PWD)/build && rpm2cpio $(PWD)/build/build.rpm | cpio -idmv && cd ..


	chmod +x $(PWD)/build/balenaEtcher-*.AppImage
	cd $(PWD)/build && $(PWD)/build/balenaEtcher-*.AppImage --appimage-extract
	
	rm -f $(PWD)/build/squashfs-root/*.png
	rm -f $(PWD)/build/squashfs-root/*.desktop	
	rm -f $(PWD)/build/squashfs-root/usr/share/metainfo/desktopeditors.appdata.xml


	cp --force --recursive $(PWD)/build/usr/lib64/* $(PWD)/build/squashfs-root/usr/lib/
	cp --force --recursive $(PWD)/build/usr/share/* $(PWD)/build/squashfs-root/usr/share/
	cp --force --recursive $(PWD)/AppDir/* $(PWD)/build/squashfs-root/

	chmod +x $(PWD)/build/squashfs-root/AppRun
	chmod +x $(PWD)/build/squashfs-root/*.desktop

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/squashfs-root/ $(PWD)/Etcher.AppImage
	chmod +x $(PWD)/Etcher.AppImage

clean:
	rm -rf $(PWD)/build
