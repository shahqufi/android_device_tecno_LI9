#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := LI9

# Architecture
TARGET_ARCH                := arm64
TARGET_ARCH_VARIANT        := armv8-a
TARGET_CPU_ABI             := arm64-v8a
TARGET_CPU_ABI2            := 
TARGET_CPU_VARIANT         := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

TARGET_2ND_ARCH                := arm
TARGET_2ND_ARCH_VARIANT        := armv7-a-neon
TARGET_2ND_CPU_ABI             := armeabi-v7a
TARGET_2ND_CPU_ABI2            := armeabi
TARGET_2ND_CPU_VARIANT         := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a55

# Boot image
BOARD_BOOT_HEADER_VERSION := 4
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_RAMDISK_USE_LZ4 := true
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_KERNEL_CMDLINE += bootopt=64S3,32N2,64N2
BOARD_KERNEL_CMDLINE += androidboot.init_fatal_reboot_target=recovery

BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE := 0x3fff8000
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x26f08000
BOARD_KERNEL_TAGS_OFFSET := 0x07c88000
BOARD_DTB_OFFSET := 0x07c88000

BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)

# Broken Rules
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_VENDOR_PROPERTY_NAMESPACE := true

# Flash Block Size (Kernel Page Size * 64)
BOARD_FLASH_BLOCK_SIZE := 262144

# Partition Sizes (from fastboot getvar)
BOARD_BOOTIMAGE_PARTITION_SIZE := 41943040
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608

# Super Partition Configuration
BOARD_SUPER_PARTITION_SIZE := 10307817472
BOARD_SUPER_PARTITION_GROUPS := mtk_dynamic_partitions

# Dynamic Partitions inside Super Partition
BOARD_MTK_DYNAMIC_PARTITIONS_PARTITION_LIST := product system system_ext vendor
BOARD_MTK_DYNAMIC_PARTITIONS_SIZE := 9122611200

BOARD_EROFS_PCLUSTER_SIZE := 262144

# Enable metadata partition (needed for encryption and dynamic partitions)
BOARD_USES_METADATA_PARTITION := true

# Make GApps installation possible
ifneq ($(WITH_GMS),true)
    BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
    BOARD_PRODUCTIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 614400000

    BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
    BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 906969088

    BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
    BOARD_SYSTEM_EXTIMAGE_EXTFS_INODE_COUNT := -1
    BOARD_SYSTEM_EXTIMAGE_PARTITION_RESERVED_SIZE := 92160000
else
    BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
    BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
    BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
endif

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs

# Define partition output locations
TARGET_COPY_OUT_SYSTEM := system
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor

# Platform
TARGET_BOARD_PLATFORM := mt6833 
BOARD_HAS_MTK_HARDWARE := true

# Power
TARGET_TAP_TO_WAKE_NODE := "/proc/gesture_function"
TARGET_POWER_LIBPERFMGR_MODE_EXTENSION_LIB := //$(DEVICE_PATH):libperfmgr-ext-transsion

#TODO
# Properties
TARGET_SYSTEM_PROP += $(COMMON_PATH)/configs/properties/system.prop
TARGET_VENDOR_PROP += $(COMMON_PATH)/configs/properties/vendor.prop






# Force any prefer32 targets to be compiled as 64 bit.
IGNORE_PREFER32_ON_DEVICE := true

# Audio 
BOARD_USES_ALSA_AUDIO := true
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := true



# Boot image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

# Display
TARGET_SCREEN_DENSITY := 480

# DTB
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbo.img
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtb

# Kernel
TARGET_NO_KERNEL_OVERRIDE := true
LOCAL_KERNEL := $(KERNEL_PATH)/Image.gz
PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel

# Kernel modules
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(addprefix $(KERNEL_PATH)/ramdisk/, $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD))

# Also add recovery modules to vendor ramdisk
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/ramdisk/modules.load.recovery))
RECOVERY_MODULES := $(addprefix $(KERNEL_PATH)/ramdisk/, $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD))

# Prevent duplicated entries (to solve duplicated build rules problem)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(sort $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES) $(RECOVERY_MODULES))

# Vendor modules (installed to vendor_dlkm)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(KERNEL_PATH)/vendor_dlkm/modules.load))
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/vendor_dlkm/*.ko)

# OTA assert
TARGET_OTA_ASSERT_DEVICE := LI9,TECNO-LI9,li9

# Workaround to make lineage's soong generator work
TARGET_KERNEL_SOURCE := $(KERNEL_PATH)/kernel-headers

# Correct Wi-Fi configuration for MediaTek (MTK) devices
WPA_SUPPLICANT_VERSION := VER_2_10
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mtk
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mtk


# Inherit the proprietary files
include vendor/tecno/LI9/BoardConfigVendor.mk