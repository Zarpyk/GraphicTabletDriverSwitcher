::https://github.com/Zarpyk/GraphicTabletDriverSwitcher/tree/main#extra
@echo off

::Set path to current folder
set "currentPath=%~dp0"
::Set driver folder names
set "driver1Name=Huion"
set "driver2Name=Wacom"

::Set Huion App location
set "huionApp=C:\Program Files\HuionTablet"
::Set Quick Access Location
set "quickAccess=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Switch Drivers"
set "changeToDriver1FileName=Switch to %driver1Name% Drivers.lnk"
set "changeToDriver2FileName=Switch to %driver2Name% Drivers.lnk"

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
echo "Se ha cambiado el driver a los de %driver1Name%"
::Huion need this app to work
start "" /D "%huionApp%" "HuionTablet.exe"
ren "%quickAccess%\%changeToDriver1FileName%" "%changeToDriver2FileName%"
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
echo "Se ha cambiado el driver a los de %driver2Name%"
::Wacom need this service to work
net start WTabletServicePro
ren "%quickAccess%\%changeToDriver2FileName%" "%changeToDriver1FileName%"
::Skip to final
goto final

::Tag for "goto"
:errorfinal
echo "No se ha podido cambiar los drivers correctamente, comprueba que todos los programas de arte esten cerrados."
::Tag for "goto"
:final
pause