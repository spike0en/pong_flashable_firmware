:: SPDX-FileCopyrightText: spike0en
:: SPDX-License-Identifier: MIT

@echo off
setlocal enabledelayedexpansion
title Nothing Phone (2) Flashable Firmware Repacker Script

echo.
echo #######################################################
echo #                                                     #
echo #       Pong Flashable Firmware Repacker Script       #
echo #    https://github.com/spike0en/nothing_archive      #
echo #  https://github.com/spike0en/pong_firmware_flasher  #
echo #                                                     #
echo #######################################################
echo.

echo ################################################
echo #                7-Zip Checking                #
echo ################################################
echo.

set /p install_7zip="Is 7-Zip installed on your system? (Y/N): "

if /i "%install_7zip%"=="Y" (
    echo 7-Zip check passed. Proceeding with the script...
) else (
    echo 7-Zip is not installed. Please install it from: https://www.7-zip.org/
    pause
    exit /b
)

echo.
echo #################################################
echo #      Getting Current Script Directory         #
echo #################################################
echo.

set script_dir=%~dp0
echo Script Directory: %script_dir%

echo.
echo #################################################
echo #           Fetch Required Binaries             #
echo #################################################
echo.

echo Downloading the latest META-INF from the repository...

set repo_zip_url=https://github.com/spike0en/pong_firmware_flasher/archive/refs/heads/main.zip
set meta_inf_dir=%script_dir%META-INF

curl -L -o "%script_dir%pong_flasher.zip" "%repo_zip_url%"

if not exist "%script_dir%pong_flasher.zip" (
    echo Failed to download repository ZIP. Exiting...
    pause
    exit /b
)

echo.
if exist "%meta_inf_dir%" (
    echo Existing META-INF found. It will be overwritten.
) else (
    echo No existing META-INF found. Extracting fresh...
)

"c:\Program Files\7-Zip\7z.exe" x "%script_dir%pong_flasher.zip" -o"%script_dir%" -aoa >nul
if %errorlevel%==0 (
    echo META-INF extracted successfully.
) else (
    echo Failed to extract META-INF. Exiting...
    pause
    exit /b
)

if exist "%script_dir%pong_firmware_flasher-main\META-INF" (
    echo Moving META-INF to the correct location...
    xcopy /E /Y "%script_dir%pong_firmware_flasher-main\META-INF" "%meta_inf_dir%" >nul
    rd /s /q "%script_dir%pong_firmware_flasher-main"
)

del "%script_dir%pong_flasher.zip"
echo META-INF has been successfully downloaded and updated.

echo.
echo #################################################
echo #        Preparing Required Directories         #
echo #################################################
echo.

if exist "%script_dir%firmware-update" (
    echo Deleting existing firmware-update directory...
    rd /s /q "%script_dir%firmware-update"
)
mkdir "%script_dir%firmware-update"
if %errorlevel%==0 (
    echo firmware-update directory prepared successfully.
) else (
    echo Failed to create firmware-update directory. Exiting...
    pause
    exit /b
)

if exist "%script_dir%tmp" (
    echo Deleting existing tmp directory...
    rd /s /q "%script_dir%tmp"
)
mkdir "%script_dir%tmp"
if %errorlevel%==0 (
    echo Temporary directory prepared successfully.
) else (
    echo Failed to create tmp directory. Exiting...
    pause
    exit /b
)

echo.
echo #################################################
echo #      Ask for Firmware and Boot File URLs      #
echo #################################################
echo.

echo "The required firmware files can be found on the following GitHub page:"
echo "https://github.com/spike0en/nothing_archive/releases?q=pong&expanded=true"
echo.
set /p open_github="Would you like to open this page in your browser? (Y/N): "

if /i "%open_github%"=="Y" (
    start "" "https://github.com/spike0en/nothing_archive/releases?q=pong&expanded=true"
    echo The GitHub page has been opened in your default browser.
) else (
    echo Please manually open the link in your browser.
)

echo.
echo Navigate to the 'Assets' section of the latest release and find the following files:
echo - Copy the direct download link for the file ending with **-image-boot.7z** (Boot)
echo - Copy the direct download link for the file ending with **-image-firmware.7z** (Firmware)
echo.
pause

echo.
echo #################################################
echo #      Enter Firmware and Boot File URLs        #
echo #################################################
echo.

echo Enter the URL for the boot category (-image-boot.7z):
set /p "boot_url=>> "

echo Enter the URL for the firmware category (-image-firmware.7z):
set /p "firmware_url=>> "

if "%boot_url%"=="" (
    echo Boot URL cannot be empty. Exiting...
    pause
    exit /b
)
if "%firmware_url%"=="" (
    echo Firmware URL cannot be empty. Exiting...
    pause
    exit /b
)

echo.
echo URLs received successfully. Proceeding with the download.

echo.
echo #################################################
echo #           Downloading Firmware Files          #
echo #################################################
echo.

echo Downloading boot category file...
curl -L -o "%script_dir%tmp\boot.7z" "%boot_url%"
if exist "%script_dir%tmp\boot.7z" (
    echo Boot category file downloaded successfully.
) else (
    echo Failed to download boot category file. Exiting...
    pause
    exit /b
)

echo Downloading firmware category file...
curl -L -o "%script_dir%tmp\firmware.7z" "%firmware_url%"
if exist "%script_dir%tmp\firmware.7z" (
    echo Firmware category file downloaded successfully.
) else (
    echo Failed to download firmware category file. Exiting...
    pause
    exit /b
)

echo.
echo #################################################
echo #          Extracting Downloaded Files          #
echo #################################################
echo.

"c:\Program Files\7-Zip\7z.exe" x "%script_dir%tmp\boot.7z" -o"%script_dir%tmp" -y >nul
if %errorlevel%==0 (
    echo Boot file extracted successfully.
) else (
    echo Failed to extract boot file. Exiting...
    pause
    exit /b
)

"c:\Program Files\7-Zip\7z.exe" x "%script_dir%tmp\firmware.7z" -o"%script_dir%tmp" -y >nul
if %errorlevel%==0 (
    echo Firmware file extracted successfully.
) else (
    echo Failed to extract firmware file. Exiting...
    pause
    exit /b
)

echo.
echo #################################################
echo #    Removing Recovery and Vbmeta Image Files   #
echo #################################################
echo.

del "%script_dir%tmp\recovery.img" >nul 2>&1
if not exist "%script_dir%tmp\recovery.img" (
    echo recovery.img removed successfully or not found.
) else (
    echo Failed to remove recovery.img.
)

del "%script_dir%tmp\vbmeta.img" >nul 2>&1
if not exist "%script_dir%tmp\vbmeta.img" (
    echo vbmeta.img removed successfully or not found.
) else (
    echo Failed to remove vbmeta.img.
)

echo.
echo #################################################
echo #       Moving Files to Firmware-Update         #
echo #################################################
echo.

move /Y "%script_dir%tmp\*.img" "%script_dir%firmware-update\" >nul
if %errorlevel%==0 (
    echo Image files moved successfully.
) else (
    echo Failed to move image files. Exiting...
    pause
    exit /b
)

rd /s /q "%script_dir%tmp"
if not exist "%script_dir%tmp" (
    echo Temporary folder cleaned up.
) else (
    echo Failed to clean up the temporary folder.
)

echo.
echo #################################################
echo #        Set Build Number for Firmware          #
echo #################################################
echo.

set /p build_no="Enter the build number for the firmware (e.g., Pong-V3.0-250113-1723_3.0): "
echo You entered: %build_no%

echo.
echo ################################################
echo #   Creating Flashable Firmware ZIP Package    #
echo ################################################
echo.

set zip_name=FW_%build_no%.zip
"c:\Program Files\7-Zip\7z.exe" a -tzip -mx=6 "%script_dir%%zip_name%" "%script_dir%firmware-update" "%script_dir%META-INF"

if %errorlevel% neq 0 (
    echo Failed to create zip file. Exiting...
    pause
    exit /b
)

echo.
echo #################################################
echo #     Firmware Package Successfully Created     #
echo #################################################
echo.

echo Firmware update files have been compressed and saved as %zip_name%.
pause