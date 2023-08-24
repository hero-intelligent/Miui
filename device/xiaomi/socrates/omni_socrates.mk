#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2023 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/omni/config/common.mk)

# Inherit from socrates device
$(call inherit-product, device/xiaomi/socrates/device.mk)

PRODUCT_DEVICE := socrates
PRODUCT_NAME := omni_socrates
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := 22127RK46C
PRODUCT_MANUFACTURER := xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="socrates-user 13 TKQ1.220905.001 V14.0.23.0.TMKCNXM release-keys"

BUILD_FINGERPRINT := Redmi/socrates/socrates:13/TKQ1.220905.001/V14.0.23.0.TMKCNXM:user/release-keys
