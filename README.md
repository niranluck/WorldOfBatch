Sample of batch command for the antique system script
1. BackupFile_s_d.bat
   - Input parameters BackupFile_s_d.bat source.xxx dest.xxx
   - Check source file exists
   - Check destination file size > 0 then remove and copy
2. Delay_RunService.bat
   - Store last execution time to repo file
   - Get the time and compare to current time
   - If repeated call within 30 sec then skip run and log recording
   - Time comparison error with no clue if error run the service anyway

Hope it can help
