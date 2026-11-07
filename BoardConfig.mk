# Kernel
TARGET_KERNEL_CONFIG := ford_defconfig
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive

# inherit from common mt8127
-include device/amazon/mt8127-common/BoardConfigCommon.mk

# inherit from the proprietary version
-include vendor/amazon/mt8127-common/BoardConfigVendor.mk

# Device properties go to /vendor/build.prop (a GSI replaces /system/build.prop)
TARGET_VENDOR_PROP := device/amazon/ford/vendor.prop

# Assert
TARGET_OTA_ASSERT_DEVICE := ford

TARGET_BOOTLOADER_BOARD_NAME := ford

# TWRP
DEVICE_RESOLUTION := 600x1024
