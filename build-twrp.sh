#!/bin/sh
WORKSPACE=~/twrp
TWRP_SOURCE=https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git
TWRP_BRANCH=twrp-11
DEVICE_CODE=A12
DEVICE_MANUFACTURER=Samsung
DEVICE_SOURCE=https://github.com/edward0181/android_device_samsung_a12.git
DT_DIR=device/$DEVICE_MANUFACTURER/$DEVICE_CODE
GIT_USER_NANE=Edward0181
GIT_USER_EMAIL=edwardroggeveen@gmail.com
GIT_COLOR_UI=false
###################################################################################
git config --global user.name $GIT_USER_NANE
git config --global user.email $GIT_USER_EMAIL
git config --global color.ui $GIT_COLOR_UI

java -version
update-java-alternatives

if [ ! -d ~/bin ]; then
    echo "[I] Setting up repo !"
    mkdir ~/bin
fi

PATH=~/bin:$PATH
source ~/.bashrc
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

if [ ! -d $WORKSPACE ]; then
    echo "[I] Setting up TWRP source !"
    mkdir -p $WORKSPACE
fi

cd $WORKSPACE
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11
if [ ! -d $DT_DIR ]; then
    echo "[I] Setting up device tree !"
    mkdir -p $DT_DIR
    git clone $DEVICE_SOURCE $DT_DIR
fi
echo "[I] Preparing for build !"
export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch twrp_a12-eng
echo "[I] Build started !"
mka recoveryimage
curl --upload-file ./out/target/product/a12/recovery.img https://transfer.sh/twrp-a12-001.img