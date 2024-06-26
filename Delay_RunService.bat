@ECHO OFF
setlocal

REM Set temp file to record last executed time
set filepath=C:\Temp\Log\
set last_time_file=%filepath%last_execution_time.txt

REM Get current date and time
for /f "tokens=1-6 delims=/ " %%a in ('DATE /T') do set currdate=20%%c%%b%%a
set hh=%time:~0,2%
if "%time:~0,1%"==" " set hh=0%hh:~1,1%
set TIMESTAMP=%hh%:%time:~3,2%:%time:~6,2%
set current_datetime=%currdate%%TIMESTAMP%

REM echo %currdate%

REM Daily log file name
set log_file=%filepath%%currdate%.txt


REM Check for the existence and content of the last execution time file
if exist %last_time_file% (
    for /f %%i in (%last_time_file%) do set last_execution_time=%%i
) else (
    REM default datetime if the file doesn't exist
    set last_execution_time=
)

REM If last execution time is not set, skip the check and run the service
if not defined last_execution_time (
   goto run_service
)

REM Extract hours, minutes, and seconds from last execution time and current time
set last_date=%last_execution_time:~0,8%
set last_time=%last_execution_time:~8,8%

set last_hour=%last_time:~0,2%
set last_minute=%last_time:~3,2%
set last_second=%last_time:~6,2%
echo %last_date% %last_hour% %last_minute% %last_second%


set current_hour=%TIMESTAMP:~0,2%
set current_minute=%TIMESTAMP:~3,2%
set current_second=%TIMESTAMP:~6,2%
echo %currdate% %current_hour% %current_minute% %current_second%

REM Convert times to seconds since midnight for comparison
set /a last_secs=(%last_date% * 100000) + (%last_hour% * 3600 + %last_minute% * 60 + %last_second%)


set /a current_secs=(%currdate% * 100000) + (%current_hour% * 3600 + %current_minute% * 60 + %current_second%)
set /a time_diff=current_secs - last_secs

if %ERRORLEVEL% NEQ 0 goto run_service


echo param1 %current_secs% 
echo param2 %last_secs%
echo diff %time_diff% 


if %time_diff% LEQ 30 (
    echo %TIMESTAMP% Skip run from %last_execution_time% diff %time_diff% >> %log_file%
    goto quit
)

:run_service
REM Execute the program and capture output
REM "C:\Temp\DoService.exe"

if %ERRORLEVEL% NEQ 0 goto error

REM Update last execution time
echo %current_datetime% > %last_time_file%
echo %TIMESTAMP% Success run >> %log_file%
goto quit

:error
echo %TIMESTAMP% Error on batch file >> %log_file%
exit 1

:quit
