@REM : BUILD SCRIPT AND REMOTE DEPLOYMENT
@REM : THIS ASSUMES SERVER IP = %SERVER_IP%
@REM : I HAVE DYNAMIC IP. SO I NEED TO CHANGE THE SERVER EVERY TIME IN THIS SCRIPT

SET WORK_FOLDER=%~dp0
SET WORK_FOLDER=%WORK_FOLDER:~0,-1%
echo %~dp0

SET SERVER_IP=192.168.87.1
SET SERVER_ADMINUSER=development
@REM SERVER_FOLDER sould be present on server
SET SERVER_FOLDER=c:\tmp

SET PATH=%SystemRoot%\System32\WindowsPowerShell\v1.0\;%PATH%

@echo STARTING BUILD NOW

powershell -command " 'dotnet version is' ; dotnet --version; "

dotnet build

ping %SERVER_IP%

ssh %SERVER_ADMINUSER%@%SERVER_IP% "echo Hi From Server"

@REM exit /b 0

dotnet publish -p:PublishProfile=IISProfile

@ECHO DOING LOCAL INSTALLATION NOW
powershell -command " $Env:WORK_FOLDER\bin\debug\PilaniDevOpBackendCode.deploy.cmd /Y "

scp %WORK_FOLDER%\bin\debug %SERVER_ADMINUSER%@%SERVER_IP%:%SERVER_FOLDER%\debug

ssh %SERVER_ADMINUSER%@%SERVER_IP% " %SERVER_FOLDER%\debug\PilaniDevOpBackendCode.deploy.cmd /Y "

@ECHO DONE BUILD AND DEPLOYMENT
exit /b 0