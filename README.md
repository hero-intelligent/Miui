# How to Compile Custom AOSP along with TWRP from Scratch for Redmi K60 Pro (socrates)

# Introduction

From [this page](https://forum.xda-developers.com/t/guide-noob-friendly-how-to-compile-twrp-from-source-step-by-step.3404024/), I have learned that the necessities for building TWRP is `kernel`, `vendor`, and `device tree`

The kernel has been released at [this repo](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/socrates-t-oss) by Xiaomi, and device tree must be hand written. As for vendor, it can be extracted from official firmware, but it probably **won't work with custom ROM**.

Anyways, I'd like to go for it, and see if my guess is wrong. I began to write this tutorial or journal on about 20 Aug 2023 and reproduce these steps on my own computer at the same time.

**NOTES:** 

This tutorial, or journal, is started with a non-modified phone with older official Chinese firmware for Redmi K60 Pro `MIUI 14.0.23.0.TMKCNXM`

Use Linux with GUI support. In my case it is freshly installed Debian 12.

It is better to use Docker to keep your system clean, unless in unsupported circumstances. So, please 

**PREREQUISITES:**

You need to unlock your bootloader.

# Extract Official ROM

1. Download Official ROM and extract. 
You can manually download the official ROM (fastboot version) at [this page](https://miuirom.org/phones/redmi-k60-pro) when you are not in China region, and extract manually. Or, you can run the following commands for convenience.

```sh
cd ~ && mkdir Miui && cd Miui
wget https://bigota.d.miui.com/V14.0.23.0.TMKCNXM/socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
tar -xvzf socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
rm socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
```

# PREPARING TO BUILD A DEVICE TREE

The following steps are based on [This turtorial](https://gist.github.com/rokibhasansagar/15c8e728d94a6bd35a687aac73ef79a5)

You need a tool called [twrpdtgen](https://github.com/twrpdtgen/twrpdtgen) to build your device tree. You can do it in your self approach, or follow my steps using docker for convenience and tidiness. 

1. this is the content for `twrpdtgen.Dockerfile`, please check it out:

```Dockerfile
FROM python:3.8

RUN apt update && apt install cpio -y
RUN pip install twrpdtgen
```

2. run the following command to build an image:

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

cp -r output device && sudo rm -rf output
```


