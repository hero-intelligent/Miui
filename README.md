# How to Compile Custom AOSP along with TWRP from Scratch for Redmi K60 Pro (socrates)

# Introduction

From [this page](https://forum.xda-developers.com/t/guide-noob-friendly-how-to-compile-twrp-from-source-step-by-step.3404024/), I have learned that the necessities for building TWRP is `kernel`, `vendor`, and `device tree`

The kernel has been released at [this repo](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/socrates-t-oss) by Xiaomi, and device tree must be hand written. As for vendor, it can be extracted from official firmware, but it probably **won't work with custom ROM**.

Anyways, I'd like to go for it, and see if my guess is wrong.

**NOTES:** 

This tutorial, or journal, is started with a non-modified phone with older official Chinese firmware for Redmi K60 Pro `MIUI 14.0.23.0.TMKCNXM`

Use Linux with GUI support. In my case it is freshly installed Debian 12.

It is better to use Docker to keep your system clean, unless in unsupported circumstances.

**PREREQUISITES:**

You need to unlock your bootloader.

# Extract Official ROM

1. Download Official ROM and extract. 
You can manually download the official ROM at [this page](https://miuirom.org/phones/redmi-k60-pro) when you are not in China region, and extract both manually. Or, you can run the following commands for convenience.

```bash
cd ~ && mkdir Miui && cd Miui
wget https://bigota.d.miui.com/V14.0.23.0.TMKCNXM/miui_SOCRATES_V14.0.23.0.TMKCNXM_b423194d4e_13.0.zip
wget https://bigota.d.miui.com/V14.0.23.0.TMKCNXM/socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
unzip miui_SOCRATES_V14.0.23.0.TMKCNXM_b423194d4e_13.0.zip -d Recovery_extracted
tar -xvzf socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
rm miui_SOCRATES_V14.0.23.0.TMKCNXM_b423194d4e_13.0.zip
rm socrates_images_V14.0.23.0.TMKCNXM_20230327.0000.00_13.0_cn_0bac074c38.tgz
```

--------USELESS-----------------
2. Get necessary tools
```bash
git clone --depth=1 https://hub.fastgit.org/AEnjoy/unpackandroidrom.git
```

3. Make Dockerfile

```Dockerfile

FROM python:3.7
COPY



# TO BE CONTINUED
```
--------USELESS-END-------------

# PREPARING TO BUILD A DEVICE TREE



The following steps are from[This turtorial](https://www.alexenferman.com/articles/TWRP/how-to-create-a-twrp-device-tree#kernelcmd).

```bash
sudo apt-get update && sudo apt-get upgrade
sudo apt-get openjdk-17-jdk

cd ~/Miui
wget https://github.com/GameTheory-/mktool/releases/download/v5.4/mktool-5.4.zip
unzip mktool-5.4.zip
cp socrates_images_V14.0.23.0.TMKCNXM_13.0/images/recovery.img mktool/input/recovery.img
cp socrates_images_V14.0.23.0.TMKCNXM_13.0/images/boot.img mktool/input/boot.img

cd mktool
java -jar mktool.jar
```

After that, go to the "Unpack" tab, select your boot image, and click on "Unpack Image". 
Take a note of the output of the console at the bottom. You will need it later. In my case it is:
```
ANDROID! magic found at: 0
BOARD_KERNEL_CMDLINE 
BOARD_PAGE_SIZE 4096
BOARD_HEADER_VERSION 4
BOARD_HEADER_SIZE 1584
```


