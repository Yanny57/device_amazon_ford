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

# Bug-fix builds made on the same day as an earlier one get a number after the
# date: FORD_BUILD_REV=1 -> lineage-18.1-20261113-1-UNOFFICIAL-ford.zip (also
# in ro.lineage.version). Board config is read after product config, so this
# wins over vendor/lineage's LINEAGE_VERSION.
ifneq ($(FORD_BUILD_REV),)
LINEAGE_VERSION := $(shell echo '$(LINEAGE_VERSION)' | sed -E 's/^([0-9.]+-[0-9]{8})-/\1-$(FORD_BUILD_REV)-/')
LINEAGE_DISPLAY_VERSION := $(LINEAGE_VERSION)
endif
