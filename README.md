# How to Compile Custom AOSP along with TWRP from Scratch for Redmi K60 Pro (socrates)

# Introduction

From [this page](https://forum.xda-developers.com/t/guide-noob-friendly-how-to-compile-twrp-from-source-step-by-step.3404024/), I have learned that the necessities for building TWRP is `kernel`, `vendor`, and `device tree`.

The kernel has been released at [this repo](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/socrates-t-oss) by Xiaomi, ~~and device tree must be hand written.~~ I accidentally find a tool called [twrpdtgen](https://github.com/twrpdtgen/twrpdtgen) which automatically makes the device tree from `recovery.img`, which is a great help to me. As for vendor, it can be extracted from official firmware, but it probably **won't work with custom ROM**.

Anyways, I'd like to go for it, and see if my guess is wrong. I began to write this tutorial or journal on about 20 Aug 2023 and reproduce these steps on my own computer at the same time. I'd like to use terminal because it is easy to repeat next time by just copying and pasting.

**NOTES:** 

This tutorial, or journal, is started with a non-modified phone with older official Chinese firmware for Redmi K60 Pro `MIUI 14.0.23.0.TMKCNXM`

Use Linux with GUI support. In my case it is freshly installed Debian 12.

It is better to use Docker to keep your system clean, unless in unsupported circumstances. So, please install it in your system in advance. you can install it using this command: `curl -fsSL get.docker.com | bash`

**PREREQUISITES:**

You need to unlock your bootloader.

# Extract Official ROM

Download Official ROM and extract. You can manually download the official ROM (fastboot version) at [this page](https://miuirom.org/phones/redmi-k60-pro) when you are not in China region, and extract manually. Or, you can run the following commands for convenience.

```sh
cd ~ && mkdir Miui && cd Miui
wget https://bigota.d.miui.com/V14.0.23.0.TMKCNXM/socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
tar -xvzf socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
rm socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
```

# PREPARING DEVICE TREE

The following steps are based on [This tutorial](https://forum.xda-developers.com/t/how-to-build-basic-twrp-for-a-android-device-android-9.4562703/)

You need a tool called [twrpdtgen](https://github.com/twrpdtgen/twrpdtgen) to build your device tree. You can do it in your self approach, or follow my steps using docker for convenience and tidiness. 

1. this is the content for `twrpdtgen.Dockerfile`. If you didn't clone my repository, please make the file with the content below:

```Dockerfile
FROM python:3.8

RUN apt update && apt install cpio -y
RUN pip install twrpdtgen
```

2. run the following command to build an image. It will take some time depending on your network access:

```bash
sudo docker build -t twrpdtgen -f ./twrpdtgen.Dockerfile
```

3. run the following command to build the device tree:
```bash
mkdir device

sudo docker run -it --rm \
-v ~/Miui/socrates_images_V14.0.23.0.TMKCNXM_13.0/images/recovery.img:/images/recovery.img \
-v ~/Miui/output:/output \
twrpdtgen \
python3 -m twrpdtgen /images/recovery.img

cp -r output device
```

4. modify the generated device tree (following next chapter).
OK, the directories `output` and `device` are the same as each other in content, as the directory `device` is a copy of `output`. Besides, modifying `output` directory needs root access. So, we will be focusing on the `device` directory, and the other one will sit there untouched for backup or for future use.


# Build TWRP

I've kind of gave up!

`repo.Dockerfile`

```Dockerfile
FROM ubuntu:22.04

RUN apt update && apt upgrade -y && apt install rsync repo -y

RUN git config --global user.email "you@example.com" && git config --global user.name "Your Name"

WORKDIR /workspace

```

```bash
sudo docker build -t repo -f repo.Dockerfile .
sudo docker run -it --rm -v ~/Miui/workspace:/workspace repo bash
```

```bash
repo init --depth=1 --no-repo-verify -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1 -g default,-mips,-darwin,-notdefault​

repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

exit
```

```bash
sudo docker run -it --rm -v ~/Miui/workspace:/workspace -v ~/Miui/device:/workspace/device repo bash
```

```bash
. build/envsetup.sh
lunch
# TO BE CONTINUED
```
















































# TO BE CONTINUED


# Further Readings

articles about TWRP

1. [GitHub - TeamWin/android_bootable_recovery](https://github.com/TeamWin/android_bootable_recovery)

2. [[GUIDE][NOOB FRIENDLY]How to compile TWRP from source step by step | XDA Forums](https://forum.xda-developers.com/t/guide-noob-friendly-how-to-compile-twrp-from-source-step-by-step.3404024/)

3. [[DEV]How to compile TWRP touch recovery | XDA Forums](https://forum.xda-developers.com/t/dev-how-to-compile-twrp-touch-recovery.1943625/)

4. [How to Build Basic TWRP for a Android Device Android 9+ | XDA Forums](https://forum.xda-developers.com/t/how-to-build-basic-twrp-for-a-android-device-android-9.4562703/)

5. [Make A TWRP Tree For Your Device & Build.md · GitHub](https://gist.github.com/rokibhasansagar/15c8e728d94a6bd35a687aac73ef79a5)

6. [How to create a TWRP device tree - Alexenferman](https://www.alexenferman.com/articles/TWRP/how-to-create-a-twrp-device-tree#kernelcmd)


4. [android-prepare-vendor/README.md at master · anestisb/android-prepare-vendor · GitHub](https://github.com/anestisb/android-prepare-vendor/blob/master/README.md)


