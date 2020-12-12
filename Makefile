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

	mkdir --parents $(PWD)/build/Boilerplate.AppDir/etcher
	apprepo --destination=$(PWD)/build appdir boilerplate libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/etcher' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'UUC_VALUE=`cat /proc/sys/kernel/unprivileged_userns_clone 2> /dev/null`' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'if [ -z "$${UUC_VALUE}" ]' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    then' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/etcher/balena-etcher-electron --no-sandbox "$${@}"' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    else' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/etcher/balena-etcher-electron "$${@}"' >> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    fi' >> $(PWD)/build/Boilerplate.AppDir/AppRun

	wget --output-document=$(PWD)/build/build.zip https://github.com/balena-io/etcher/releases/download/v1.5.111/balena-etcher-electron-1.5.111-linux-x64.zip
	unzip $(PWD)/build/build.zip -d $(PWD)/build

	chmod +x $(PWD)/build/balenaEtcher-*.AppImage
	cd $(PWD)/build && $(PWD)/build/balenaEtcher-*.AppImage --appimage-extract

	rm -f $(PWD)/build/squashfs-root/*.png
	rm -f $(PWD)/build/squashfs-root/*.desktop	
	rm -f $(PWD)/build/squashfs-root/usr/share/metainfo/desktopeditors.appdata.xml

	cp --force --recursive $(PWD)/build/squashfs-root/usr/share/* $(PWD)/build/Boilerplate.AppDir/share
	cp --force --recursive $(PWD)/build/squashfs-root/usr/lib/* $(PWD)/build/Boilerplate.AppDir/lib64

	rm -rf $(PWD)/build/squashfs-root/usr

	rm -rf $(PWD)/build/Boilerplate.AppDir/etcher/AppRun | true
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.desktop | true
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.svg | true
	rm -rf $(PWD)/build/Boilerplate.AppDir/*.png | true

	cp --force --recursive $(PWD)/build/squashfs-root/* $(PWD)/build/Boilerplate.AppDir/etcher
	cp --force --recursive $(PWD)/AppDir/*.desktop $(PWD)/build/Boilerplate.AppDir
	cp --force --recursive $(PWD)/AppDir/*.svg $(PWD)/build/Boilerplate.AppDir | true
	cp --force --recursive $(PWD)/AppDir/*.png $(PWD)/build/Boilerplate.AppDir | true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/Boilerplate.AppDir $(PWD)/Etcher.AppImage
	chmod +x $(PWD)/Etcher.AppImage

clean:
	rm -rf $(PWD)/build
