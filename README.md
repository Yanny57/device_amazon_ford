# LineageOS 15.1 for the Amazon Fire 7 (2015, "ford")

Unofficial LineageOS 15.1 (Android 8.1) device tree for the 5th generation
Fire 7 (MediaTek MT8127, 1 GB RAM, kernel 3.10). It builds on the CM 14.1 /
LineageOS 14.1 trees by the [cm14-mt8127](https://github.com/cm14-mt8127)
team (ggow and contributors).

## Status

Working:
- Boot, display and GPU (legacy Mali through patched HIDL gralloc)
- Audio and media codecs
- Wi-Fi
- Bluetooth
- Sensors and auto-rotate
- adb and MTP
- Android Go (low-RAM) profile

Known issues:
- Camera: the HAL opens and the sensor streams, but MTK's image processor
  (DpFramework) never produces preview frames, so the preview stays black.
- SELinux is permissive.

## Repositories

| Path | Branch |
| --- | --- |
| device/amazon/ford | lineage-15.1 |
| device/amazon/mt8127-common | lineage-15.1 |
| kernel/amazon/mt8127-common | lineage-15.1 |
| vendor/amazon/mt8127-common | lineage-15.1 |
| vendor/amazon/ford | cm-14.1 |

Some changes to LineageOS itself live as patches in
`device/amazon/mt8127-common/patches` (frameworks/av, frameworks/base,
hardware/interfaces, system/bt).

## Building

```bash
repo init -u https://github.com/LineageOS/android.git -b lineage-15.1
# add the local manifest (local_manifests/ford.xml) to .repo/local_manifests/
repo sync -c -j8
bash device/amazon/mt8127-common/patches/patch.sh
source build/envsetup.sh
breakfast ford
mka bacon
```

Build with Java 8. The kernel must be built with GCC 4.8 (arm-eabi-4.8):
GCC 4.9 kernels reset a few seconds into boot.

On modern hosts, set `LC_ALL=C` for the build. If you get Jack errors, also
set `JACK_REPOSITORY` and `ANDROID_JACK_VM_ARGS`.

## Credits

- ggow and the cm14-mt8127 team for the Nougat device, kernel and vendor trees
- The LineageOS team
