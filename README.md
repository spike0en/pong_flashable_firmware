# Flashable Firmware for Nothing Phone (2)

[![Total Downloads](https://img.shields.io/github/downloads/spike0en/pong_flashable_firmware/total?logo=github&logoColor=white&label=Total%20Downloads&color=007377)](https://github.com/spike0en/pong_flashable_firmware/releases)
[![Latest Release](https://img.shields.io/github/release/spike0en/pong_flashable_firmware?label=Latest%20Release&logo=git&logoColor=white&color=1E6091)](https://github.com/spike0en/pong_flashable_firmware/releases/latest)

[![Stars](https://img.shields.io/github/stars/spike0en/pong_flashable_firmware?logo=github&color=D4AF37)](https://github.com/spike0en/pong_flashable_firmware/stargazers)
[![Contributors](https://img.shields.io/github/contributors/spike0en/pong_flashable_firmware?logo=github&color=9B5DE5)](https://github.com/spike0en/pong_flashable_firmware/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/spike0en/pong_flashable_firmware?logo=github&color=468FAF)](https://github.com/spike0en/pong_flashable_firmware/network/members)

## About 

- This is a collection of flashable firmwares for Nothing Phone (2) aka `Pong`. 
- The firmware images can be flashed by default to both slots, and they can also be targeted towards a single slot (A/B) based on user input using the volume up and down buttons.
- It supports all regional variants (`IND`/`EEA`/`GLO`) of the device. 
- The corresponding images have been fetched from [here](https://github.com/spike0en/nothing_archive) and repacked along with the script in a supported flashable template.

## Use Cases

- This script is helpful when flashing custom ROM builds that require a specific firmware version but do not ship the same in the build itself.
- [NothingMuch ROM](https://xdaforums.com/t/nothingmuchrom-for-nothing-phone-2.4623411/) can be easily dirty updated by flashing the firmware zip, followed by flashing the provided `super` and optional `vbmeta` images accordingly.

## Partitions

The following partition images would be flashed to both slots:
```sh
`abl`, `aop`, `aop_config`, `bluetooth`, `boot`, `cpucp`, `devcfg`, `dsp`, `dtbo`, `featenabler`, `hyp`, `imagefv`, `keymaster`, `modem`, `multiimgoem`, `multiimgqti`, `qupfw`, `qweslicstore`, `shrm`, `tz`, `uefi`, `uefisecapp`, `vbmeta_system`, `vbmeta_vendor`, `vendor_boot`, `xbl`, `xbl_config`, `xbl_ramdump`
```

## Flashing Procedure

1. Download the firmware zip file corresponding to the target Nothing OS version (check the file name) from the download link given below.
2. The firmware zip file can be flashed from a custom recovery via adb sideload or it can be directly flashed from the Internal Storage on the Phone (using TWRP/Orangefox).
3. It doesn't matter which Nothing OS version you are on or if you are on a custom or stock ROM; you can just flash or sideload the firmware file.
4. The script will automatically flash the firmware to both slots, so there's no need to flash it twice!
5. Disable your antivirus scanner on Windows before adb sideloading the file.
6. The Firmware flasher will not touch your data partition, so it will not format or modify your data.

## Download
- Refer to the [releases](https://github.com/spike0en/pong_flashable_firmware/releases) section.


## Credits
- Nixsuki for the initial version of the Oneplus Flashable Firmwares.
- [WishmasterFlo](https://github.com/Wishmasterflo) for the [Oneplus Firmware Flasher](https://github.com/Wishmasterflo/Firmware_flasher).
