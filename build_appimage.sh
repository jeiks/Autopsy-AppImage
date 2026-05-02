#!/bin/bash
# Author: Jacson RC Silva <jacsonrcsilva@gmail.com>

TARGET_DIR='./Autopsy.AppDir'


get_md5sum() {
    md5sum $1 2> /dev/null | awk '{print $1}'
}

echo "Checking appimagetool..."
if [ "$(get_md5sum appimagetool-x86_64.AppImage)" != "43264887ffe43cdc02171b3463912168" ];then
    rm -f appimagetool-x86_64.AppImage
    wget -O appimagetool-x86_64.AppImage https://github.com/AppImage/appimagetool/releases/download/1.9.1/appimagetool-x86_64.AppImage
    chmod +x appimagetool-x86_64.AppImage
fi

echo "Checking sleuthkit-java..."
if [ "$(get_md5sum sleuthkit-java_4.14.0-1_amd64.deb)" != "857a0d4e316e59ddb710b4201581729d" ];then
    wget -O sleuthkit-java_4.14.0-1_amd64.deb https://github.com/sleuthkit/sleuthkit/releases/download/sleuthkit-4.14.0/sleuthkit-java_4.14.0-1_amd64.deb
fi

echo "Checking autopsy..."
if [ "$(get_md5sum autopsy-4.22.1_v2.zip)" != "85688714ff298b62634ec0c122b3b10b" ];then
    wget -O autopsy-4.22.1_v2.zip https://github.com/sleuthkit/autopsy/releases/download/autopsy-4.22.1/autopsy-4.22.1_v2.zip
fi

if ! mkdir $TARGET_DIR;then
    echo "ERROR: Could not create the directory \`$TARGET_DIR'." >&2
    exit 1
fi

mkdir debs
cd debs
#libde265-dev libheif-dev libpq-dev libafflib-dev libewf-dev libvhdi-dev libvmdk-dev libvslvm-dev 
apt download libde265-0 libheif1 libpq5 libjpeg62-turbo libafflib0t64 libafflib0v5 libewf2 libvhdi1 libvmdk1 libvslvm1t64 libvslvm1 testdisk libgstreamer1.0-0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
#for i in *.deb;do apt-cache depends -i ${i%%_*} | awk '/Depends:/ {print $2}' | xargs apt download;done
#rm -f *-dev*
cd ..
for i in debs/*.deb;do dpkg -x $i x;done
dpkg -x sleuthkit-java_4.14.0-1_amd64.deb x/

mkdir ${TARGET_DIR}/{bin,libs}

mv x/usr/bin/* ${TARGET_DIR}/bin/
mv x/usr/lib/x86_64-linux-gnu/* ${TARGET_DIR}/libs/
mv x/usr/share/java/* ${TARGET_DIR}/libs/
rm -rf x debs

# To copy the symlinks' contents correctly:
RESP=$(dpkg -l openjdk-17-jre openjdk-17-jdk &> /dev/null;echo $?)
if [ $RESP = 1 ];then sudo apt install -y openjdk-17-jre openjdk-17-jdk;fi
cp -aL /usr/lib/jvm/java-1.17.0-openjdk-amd64/ ${TARGET_DIR}/jvm
if [ $RESP = 1 ];then sudo apt remove -y openjdk-17-*;fi

echo "Extracting autopsy..."
unzip -d ${TARGET_DIR} autopsy-4.22.1_v2.zip &> /dev/null
chmod a+x ${TARGET_DIR}/autopsy-4.22.1/autopsy/markmckinnon/export*
chmod a+x ${TARGET_DIR}/autopsy-4.22.1/autopsy/markmckinnon/parse*
chmod -R a+x ${TARGET_DIR}/autopsy-4.22.1/autopsy/solr/bin
chmod a+x ${TARGET_DIR}/autopsy-4.22.1/bin/autopsy
dos2unix ${TARGET_DIR}/autopsy-4.22.1/etc/autopsy.conf
echo 'jdkhome=""' >> ${TARGET_DIR}/autopsy-4.22.1/etc/autopsy.conf

find ${TARGET_DIR} -type f -name "*.dll" -delete
find ${TARGET_DIR} -type f -name "*.exe" -delete

echo '#!/bin/bash
#Author: Jacson RC Silva <jacsonrcsilva@gmail.com>

HERE="$(dirname "$(readlink -f "${0}")")"

export JAVA_HOME="${HERE}/jvm"
export PATH="${JAVA_HOME}/bin:${HERE}/bin:${PATH}"
export LD_LIBRARY_PATH="${HERE}/libs:${LD_LIBRARY_PATH}"

export SOLR_LOGS_DIR="/tmp/autopsy-solr-logs-$USER"
export SOLR_PID_DIR="/tmp/autopsy-solr-run-$USER"
mkdir -p "$SOLR_LOGS_DIR" "$SOLR_PID_DIR"

exec "${HERE}/autopsy-4.22.1/bin/autopsy" \
    --jdkhome "${JAVA_HOME}" \
    -J-Dsolr.log.dir="$SOLR_LOGS_DIR" \
    -J-XX:+IgnoreUnrecognizedVMOptions \
    "$@"
' > ${TARGET_DIR}/AppRun
chmod +x ${TARGET_DIR}/AppRun

echo '[Desktop Entry]
Name=Autopsy
Exec=AppRun
Icon=autopsy
Type=Application
Categories=Development;Security;System;
Comment=Digital Forensics Platform
Terminal=false
' > ${TARGET_DIR}/autopsy.desktop

convert ${TARGET_DIR}/autopsy-4.22.1/icon.ico autopsy.png
mv autopsy-0.png Autopsy.AppDir/autopsy.png
rm -f autopsy-?.png

rm -f Autopsy-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage Autopsy.AppDir
