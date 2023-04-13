# GraphicTabletDriverSwitcher
This script use Wacom (Intuos S BT) and Huion (Inspiroy H1060P), but I think it works for any graphic tablet if you modify the drivers inside the folders (Not tested)

# How to use
1. **CLOSE ALL ART/DESIGN PROGRAM** (Clip studio paint, photoshop, illustrator...)
- Create windows shortcut of [Switch.bat](/Switch.bat) and change it's properties to open with admin rights
- Or open directly [Switch.bat](/Switch.bat) with admin rights

Extra info: You can edit the script right clicking and "Edit"

# How to update drivers
1. Install new drivers
2. Go to `System32` and `SysWOW64` on `C:/Windows` and copy the new files named same as current files
3. Paste these files in their respective folders

Current Version:
- Huion: v15.6.3.132 (**Inspiroy H1060P**)
- Wacom: v6.4.1-3 (**Intuos S BT**)

# Why don't work
Possible reasons:
- Open the script with Admin Rights (This is needed because script need copy file to System32 and SysWOW64)
- Check that all art program are closed
- Change the drivers to you graphic tablet, I don't know if each tablet has its own driver.
- Update the drivers
- Check if you have Huion App on `C:\Program Files\HuionTablet`, if not, change the path to the app on the script

# Why Wacom have more file than Huion?
It has more files, since copying less for some reason did not work the pressure in Clip Studio Paint and for test I put all Wacom files that were in System32 and it worked but I don't check what file is the reason :p

# How does it work

```bat
@echo off

::Set path to current folder
set "currentPath=%~dp0"
::Set driver folder names
set "driver1Name=Huion"
set "driver2Name=Wacom"

::Set Huion App location
set "huionApp=C:\Program Files\HuionTablet"

::Set driver path
set "driver1=%currentPath%%driver1Name%"
set "driver2=%currentPath%%driver2Name%"

::Set variable save file name
set "lastDriverFileName=lastDriver"
::Get the last driver used
set /p lastDriver=<"%lastDriverFileName%"
::Trim the lastDriver string
set "lastDriver=%lastDriver:~0,-1%"
::Set location of the drivers
set "driverLocation=C:\Windows\System32"
set "driverLocation2=C:\Windows\SysWOW64"

::Kill Huion apps
taskkill /f /im "HuionTablet.exe"
taskkill /f /im "HuionServer.exe"
taskkill /f /im "HuionTabletCore.exe"

::Kill Wacom apps
taskkill /f /im "WacomCenterUI.exe"
taskkill /f /im "WacomHost.exe"
taskkill /f /im "Wacom_UpdateUtil.exe"
taskkill /f /im "Wacom_TouchUser.exe"
taskkill /f /im "Wacom_TabletUser.exe"
taskkill /f /im "Wacom_Tablet.exe"
taskkill /f /im "WTabletServicePro.exe"


if "%lastDriver%" == "%driver1%" (
::If last driver is driver1 go to driver2
	goto driver2
) else if "%lastDriver%" == "%driver2%" (
::If last driver is driver2 go to driver1
	goto driver1
) else (
::If is first time, go to driver1
	set "lastDriver = %driver1%"
	goto driver1
)

::Tag for "goto"
:driver1
::Copy all drivers to driver location
xcopy /s /y /q "%driver1%\System32" "%driverLocation%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
xcopy /s /y /q "%driver1%\SysWOW64" "%driverLocation2%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
::Change last driver to driver 1
echo %driver1% > "%lastDriverFileName%"
::Show what driver is using after change
echo "Driver changed to %driver1Name% driver"
::Huion need this app to work
start "" /D "%huionApp%" "HuionTablet.exe"
::Skip to final
goto final

::Tag for "goto"
:driver2
::Copy all drivers to driver location
xcopy /s /y /q "%driver2%\System32" "%driverLocation%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
xcopy /s /y /q "%driver2%\SysWOW64" "%driverLocation2%"
if NOT %ERRORLEVEL% == 0 (
	goto errorfinal
)
::Change last driver to driver 2
echo %driver2% > "%lastDriverFileName%"
::Show what driver is using after change
echo "Driver changed to %driver1Name% driver"
::Wacom need this service to work
net start WTabletServicePro
::Skip to final
goto final

::Tag for "goto"
:errorfinal
echo "Failed changing drivers, check that all art programs are closed."
::Tag for "goto"
:final
pause
```
