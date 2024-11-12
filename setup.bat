@echo off
setlocal enabledelayedexpansion

:: Create the "PowerPlans" folder if it doesn't already exist
if not exist "PowerPlans" (
    mkdir "PowerPlans"
)

:: Get the list of all power plans and process it
for /f "tokens=*" %%A in ('powercfg /list') do (
    set /a counter+=1
    :: Skip the first two lines (headers or blank lines)
    if !counter! geq 3 (
        set line=%%A
        :: Look for lines that contain a GUID (usually they start with "*")
        echo !line! | findstr /i "Power Scheme" > nul
        if !errorlevel! equ 0 (
            :: Extract GUID and the name of the power plan
            for /f "tokens=2,* delims=:" %%B in ("!line!") do (
                set GUID=%%B
                set planName=%%B

                :: Clean up the GUID and plan name (remove leading/trailing spaces and extra characters)
                set GUID=!GUID:~1,36!
                set planName=!planName:~40,-1!
		if "!planName!" == "Balanced) " (
			set planName=!planName:~0,-1!
			set planName=!planName:~0,-1!
		)
		set planNameTrimmed=!planName: =!
		
		set fileName="PowerPlans\SetPowerPlan!planNameTrimmed!.bat"

                :: Create a new .bat file for this power plan in the "PowerPlans" folder
	    	echo @echo off >> !fileName!
            	echo powercfg /setactive !GUID! >> !fileName!
            	echo echo !planName! Power Plan Activated. >> !fileName!

		echo [!GUID!] !planName! created at !fileName!.
            )
        )
    )
)