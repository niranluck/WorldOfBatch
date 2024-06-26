@echo off
REM Check if exactly two arguments are provided
if "%~2"=="" (
    echo Usage: BackupFile_s_d.bat source_file destination_file
    exit /b 1
)

REM Assign arguments to variables
set source_file=%1
set destination_file=%2

REM Check if source file exists
if not exist "%source_file%" (
    echo Source file does not exist: %source_file%
    exit /b 1
)

REM Check file size not equal 0
for %%A in ("%source_file%") do if %%~zA NEQ 0 (

  REM Check if destination file exists and delete if it does
  if exist "%destination_file%" (
    del "%destination_file%"
    if %errorlevel% neq 0 (
        echo Failed to delete existing destination file: %destination_file%
        exit /b 1
    )
  )

  REM Copy the file
  copy "%source_file%" "%destination_file%"
)

REM Check if copy was successful
if %errorlevel% equ 0 (
    echo File copied successfully.
) else (
    echo Error occurred while copying the file.
)