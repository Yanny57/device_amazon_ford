# LineageOS 18.1 for the Amazon Fire 7 (2015, "ford") — TESTING

Unofficial LineageOS 18.1 (Android 11) for the 5th generation Fire 7
(MediaTek MT8127, Mali-450 MP, 1 GB RAM, kernel 3.10). It builds on the
CM 14.1 / LineageOS 14.1 trees by the [cm14-mt8127](https://github.com/cm14-mt8127)
team (ggow and contributors) and their later 15.1/17.1 ports.

> **Testing build.** So far it has only run on one 8 GB unit, and that unit is
> a non-production prototype (efuse `prod=0`). Reports from retail units are
> very welcome. The 16 GB repartition path has not been tested on hardware.

## Status

Working:
- Boot, display, GPU (Mali-450, OpenGL ES 2.0), hardware video decoding
- Audio: speaker and microphone (the headphone jack is untested)
- Wi-Fi (including IPv6 networks and Wi-Fi in deep sleep), Bluetooth
- Sensors and auto-rotate, battery and charging, deep sleep
- Both cameras: preview, photos, HDR, video recording with sound
- adb, MTP, Android Go (low-RAM) profile
- Optional CPU overclock steps (up to 1508 MHz is stable on the test unit)
  through apps like SmartPack Kernel Manager

Known issues:
- SELinux is permissive.
- Video is encoded in software; 720p at a full 30 fps is not verified.
- WPA3 (SAE) is off: the MT6620 Wi-Fi chip fails SAE handshakes.
- The system WebView is pinned to Chromium 145, the last version that runs on
  an OpenGL ES 2.0 GPU. Don't switch WebView to a newer one.
- The camera provider can crash in rare cases; the camera recovers by itself.

The kernel version shows as `3.18.0-3.10.108...` in Settings and `uname`. The
kernel is really 3.10.108. The `3.18.0-` prefix is only there to get past
userspace version checks (ART needs it to use the backported `memfd_create`
for its JIT, which system_server requires). `/proc/version`, module vermagic
and `LINUX_VERSION_CODE` still report 3.10.

## Installing

You need the unlocked bootloader and TWRP for ford.

**Never write `boot.img` with dd or fastboot.** Always flash zips in TWRP: TWRP
adds the header the unlocked bootloader needs.

LineageOS 18.1 needs a `/vendor` partition, which ford doesn't have from the
factory. The repartition zips switch the eMMC between two layouts:

| Layout | system | vendor | cache | userdata |
| --- | --- | --- | --- | --- |
| stock (Amazon) | 1200 MiB | — | 250 MiB | rest |
| treble (LineageOS 18.1) | 2048 MiB | 256 MiB (p14) | 128 MiB | rest |

Only the partition table changes; the bootloader, boot, recovery and TEE
partitions stay where they are. **Switching layouts erases system, cache, data
and internal storage**; the microSD card is not touched. With a microSD card
in, the zip saves the old partition table to `ford-gpt-backup/` on it.

1. Back up everything you want to keep to a PC or microSD card.
2. In TWRP, flash `ford-repartition-treble-<date>.zip`.
3. Reboot to recovery (Reboot > Recovery).
4. Flash the LineageOS zip, and Android 11 ARM GApps if you want them.
5. Wipe Dalvik/cache and reboot. The first boot takes a few minutes.

Already on the treble layout (for example from an earlier 17.1/18.1 build)?
Skip steps 2-3. Flashing the treble zip again never wipes anything: it only
formats partitions that don't mount.

To go back to Fire OS 5 or a ROM for the stock layout, flash
`ford-repartition-stock-<date>.zip`, reboot to recovery, then flash that ROM.

## Repositories

| Path | Repository | Branch |
| --- | --- | --- |
| device/amazon/ford | Yanny57/device_amazon_ford | lineage-18.1 |
| device/amazon/mt8127-common | Yanny57/device_amazon_mt8127-common | lineage-18.1 |
| kernel/amazon/mt8127-common | Yanny57/kernel_amazon_mt8127-common | lineage-18.1 |
| vendor/amazon/mt8127-common | Yanny57/vendor_amazon_mt8127-common | lineage-18.1 |
| vendor/amazon/ford | Yanny57/vendor_amazon_ford | lineage-18.1 |

Changes to LineageOS itself (frameworks/av, hardware/interfaces,
packages/apps/AudioFX, packages/modules/NetworkStack, system/bt,
system/libhidl) are patches in `device/amazon/mt8127-common/patches`.

## Building

```bash
repo init -u https://github.com/LineageOS/android.git -b lineage-18.1
mkdir -p .repo/local_manifests
curl -o .repo/local_manifests/ford.xml \
    https://raw.githubusercontent.com/Yanny57/device_amazon_ford/lineage-18.1/local_manifests/ford.xml
repo sync -c -j8
bash device/amazon/mt8127-common/patches/patch.sh
source build/envsetup.sh
lunch lineage_ford-userdebug
mka bacon
```

The kernel is built with GCC 4.8 (arm-eabi-4.8, in the local manifest): GCC 4.9
kernels reset a few seconds into boot. Set `LC_ALL=C` for the build.

On hosts whose `/etc/mke2fs.conf` enables newer ext4 features (such as
`orphan_file`), the tree's mke2fs fails while building APEXes. Point
`MKE2FS_CONFIG` at a config without them and export `ALLOW_NINJA_ENV=true`, so
Soong passes it through.

The repartition zips:

```bash
m ford_repart
device/amazon/mt8127-common/repartition/mkzips.sh
```

## Credits

- ggow and the cm14-mt8127 team for the Nougat device, kernel and vendor trees
- The LineageOS team
- Everyone behind the ford bootloader unlock and TWRP
