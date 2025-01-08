# Firmware Flasher for Nothing Phone (2)

A Flashing script for Pong that flashes the firmware images to both A/B slots. It supports all regional variants (IND/EEA/GLO) of the device. The corresponding images have been fetched from [here](https://github.com/spike0en/nothing_archive) and repacked along with the script in a supported flashable template.

## Use Cases
- This script is helpful when flashing custom ROM builds that require a specific firmware version but do not ship the same in the build itself.
- [NothingMuch ROM](https://xdaforums.com/t/nothingmuchrom-for-nothing-phone-2.4623411/) can be easily dirty updated by flashing the firmware zip, followed by flashing the provided super and optional vbmeta images accordingly.

## Flashing Procedure
1. Download the firmware zip file corresponding to the target Nothing OS version (check the file name) from the download link given below.
2. The firmware zip file can be flashed from a custom recovery via adb sideload or it can be directly flashed from the Internal Storage on the Phone (using TWRP/Orangefox).
3. It doesn't matter which Nothing OS version you are on or if you are on a custom or stock ROM; you can just flash or sideload the firmware file.
4. The script will automatically flash the firmware to both slots, so there's no need to flash it twice!
5. Disable your antivirus scanner on Windows before adb sideloading the file.
6. The Firmware flasher will not touch your data partition, so it will not format or modify your data.

## Download
- [Sourceforge](https://sourceforge.net/projects/nothing-archive/files/Pong/recovery_flashable_firmware/)
- [Internet Archive](https://archive.org/download/nothing-archive/pong_flashable_firmware/)


## Credits
- Nixsuki for the initial version of the Oneplus Flashable Firmwares.
- [WishmasterFlo](https://github.com/Wishmasterflo) for the [Oneplus Firmware Flasher](https://github.com/Wishmasterflo/Firmware_flasher).
