SOURCE="https://github.com/balena-io/etcher/releases/download/v1.5.81/balena-etcher-electron-1.5.81-linux-x64.zip"
DESTINATION="build.zip"
OUTPUT="Etcher.AppImage"

all:
	echo "Building: $(OUTPUT)"
	wget --output-document=$(DESTINATION)  --continue $(SOURCE)
	unzip build.zip
	chmod +x $(DESTINATION)
	./balenaEtcher-*-x64.AppImage --appimage-extract
	rm -f squashfs-root/*.png
	rm -f squashfs-root/*.desktop	
	rm -f squashfs-root/usr/share/metainfo/desktopeditors.appdata.xml
	cp icon.png squashfs-root/icon.png
	cp Etcher.desktop squashfs-root/Etcher.desktop
	export ARCH=x86_64 && bin/appimagetool.AppImage squashfs-root $(OUTPUT)
	rm -rf squashfs-root
	rm -rf balenaEtcher-*-x64.AppImage
	rm -rf $(DESTINATION)
