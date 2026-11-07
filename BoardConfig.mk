# Kernel
TARGET_KERNEL_CONFIG := ford_defconfig
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive

# inherit from common mt8127
-include device/amazon/mt8127-common/BoardConfigCommon.mk

# inherit from the proprietary version
-include vendor/amazon/mt8127-common/BoardConfigVendor.mk

# Properties (appended: the Go profile already sets TARGET_SYSTEM_PROP, which
# replaces the default device/amazon/ford/system.prop)
TARGET_SYSTEM_PROP += device/amazon/ford/system.prop

# Assert
TARGET_OTA_ASSERT_DEVICE := ford

TARGET_BOOTLOADER_BOARD_NAME := ford

# TWRP
DEVICE_RESOLUTION := 600x1024
