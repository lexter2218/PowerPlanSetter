@echo off
setlocal enabledelayedexpansion

echo =================================== POWER PLAN SETTER ===================================

rem Set the path to the PowerPlans folder
set "PowerPlansFolder=PowerPlans"

rem Check if PowerPlans folder exists
if not exist "%PowerPlansFolder%" (
    echo Setting up your Power Plans...
    call setup.bat
    echo.
    echo.
)

rem Initialize a counter and display all .bat files in PowerPlans folder
set /a counter=0
for %%f in (%PowerPlansFolder%\SetPowerPlan*.bat) do (
    set /a counter+=1
    set "file[!counter!]=%%f"
    set "name=%%~nf"
    set "name=!name:SetPowerPlan=!"
    echo [!counter!] : !name!
)

rem Prompt user to select a file
set /p choice=Enter the number of the file you want to run: 
echo.

rem Validate the choice
if defined file[%choice%] (
    echo Running !name! Power Plan!
    call "!file[%choice%]!"
) else (
    echo Invalid selection.
)
echo.

rem Countdown before closing
set /a counter=3
:countdown
echo Closing in %counter% seconds...
set /a counter-=1
timeout /t 1 >nul
if %counter% GEQ 1 goto countdown

:end
pause