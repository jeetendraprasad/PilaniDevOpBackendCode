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

@REM : PRE INSTALLATION testing api on localhost
curl http://localhost/PilaniDevOpBackendCode/user

@ECHO DOING LOCAL INSTALLATION NOW. THIS WOULD FAIL IF USER/JENKINS/SCRIPT DONT HAVE ADMIN ACCESS.
powershell -command " $F=$Env:WORK_FOLDER; &$F\bin\debug\PilaniDevOpBackendCode.deploy.cmd /Y "

@REM : testing api on localhost
curl http://localhost/PilaniDevOpBackendCode/user

@ECHO COPYING FILES ON SERVER.
scp -r %WORK_FOLDER%\bin\debug %SERVER_ADMINUSER%@%SERVER_IP%:%SERVER_FOLDER%\debug

@REM : PRE INSTALLATION testing api on SERVER
curl http://%SERVER_IP%/PilaniDevOpBackendCode/user

@ECHO DOING SERVER INSTALLATION NOW USING PASSWORDLESS SSH. THIS WOULD FAIL IF USER/JENKINS/SCRIPT DONT HAVE ADMIN ACCESS.
ssh %SERVER_ADMINUSER%@%SERVER_IP% " %SERVER_FOLDER%\debug\PilaniDevOpBackendCode.deploy.cmd /Y "

@REM : testing api on SERVER
curl http://%SERVER_IP%/PilaniDevOpBackendCode/user

@ECHO DONE BUILD AND DEPLOYMENT
exit /b 0