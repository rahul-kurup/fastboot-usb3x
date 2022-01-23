@echo off

title Fastboosted USB 3.x

:: Toggle auto privilege prompt | start
for %%i in (powershell.exe) do if "%%~$path:i"=="" (set hasPowershell=0) else (set hasPowershell=1)

if %hasPowershell% == 1 (
	net file 1>nul 2>nul && goto :RUN || powershell -ex unrestricted -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c %~fnx0 %*'"
	goto :EOF
)
:: Toggle auto privilege prompt | end

:RUN
	@echo off

	echo:
	echo  ********** Fastboosted USB 3.x ********** 
	echo:
	echo:
	echo  This utility toggles ABD/Fastboot debugging on USB 3.x ports, by manipulating registry entries
	echo:
	echo  [ Detecting admin privileges... ]
	echo:

	net session >nul 2>&1
	if %errorLevel% == 0 (
	  echo  [ Utility running in elevated mode. ]
		echo:
	  echo  Press highlighted key and enter to execute.
		echo  - [E]nable ABD/Fastboot on USB 3.x ports
		echo  - [D]isable ABD/Fastboot on USB 3.x ports
		echo  - [R]eset USB 3.x port settings
		echo  - E[x]it without doing any changes
		echo:
		set /p choice="Execute (E/D/R/X): "
		goto CHOICES
	) else (
	  echo  ERROR: Run the utility as administrator to continue!
	)
	goto END_QUITELY

	:CHOICES
		if %choice% == E goto ENABLE_BRIDGE
		if %choice% == e goto ENABLE_BRIDGE
		if %choice% == D goto DISABLE_BRIDGE
		if %choice% == d goto DISABLE_BRIDGE
		if %choice% == R goto RESET_BRIDGE
		if %choice% == r goto RESET_BRIDGE
		goto END_QUITELY

	:RESET_BRIDGE
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "osvc" /t REG_BINARY /d "0000" /f >nul
		goto DISABLE_BRIDGE

	:ENABLE_BRIDGE
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "osvc" /t REG_BINARY /d "0000" /f >nul
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipContainerIdQuery" /t REG_BINARY /d "01000000" /f >nul
		reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipBOSDescriptorQuery" /t REG_BINARY /d "01000000" /f >nul
		echo  Bridge enabled successfully
		echo:
		goto END_QUITELY

	:DISABLE_BRIDGE
		reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipContainerIdQuery" /f >nul
		reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\usbflags\18D1D00D0100" /v "SkipBOSDescriptorQuery" /f >nul
		echo  Bridge disabled / reset to original values successfully
		echo:
		goto END_QUITELY

	:END_QUITELY
		pause >nul
