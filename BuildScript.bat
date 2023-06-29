@REM : BUILD SCRIPT AND REMOTE DEPLOYMENT
@REM : THIS ASSUMES SERVER IP = %SERVER_IP%
@REM : I HAVE DYNAMIC IP. SO I NEED TO CHANGE THE SERVER EVERY TIME IN THIS SCRIPT

SET WORK_FOLDER=%~dp0
SET WORK_FOLDER=%WORK_FOLDER:~0,-1%
echo %~dp0

@REM SERVER_IP IS DYNAMIC IP SO I HAVE TO CHANGE THAT ALWAYS.
SET SERVER_IP=192.168.87.1
SET SERVER_ADMINUSER=development
@REM SERVER_FOLDER sould be present on server
SET SERVER_FOLDER=c:\tmp

SET PATH=%SystemRoot%\System32\WindowsPowerShell\v1.0\;%PATH%

@echo STARTING BUILD NOW

dotnet build

dotnet publish -p:PublishProfile=IISProfile

@REM ABOVE command produces following files (because of IISProfile.pubxml)
@REM .\bin\debug\PilaniDevOpBackendCode.deploy-readme.txt
@REM .\bin\debug\PilaniDevOpBackendCode.deploy.cmd
@REM .\bin\debug\PilaniDevOpBackendCode.Parameters.xml
@REM .\bin\debug\PilaniDevOpBackendCode.SetParameters.xml
@REM .\bin\debug\PilaniDevOpBackendCode.SourceManifest.xml
@REM .\bin\debug\PilaniDevOpBackendCode.zip

@REM Now to install I need to copy these file to server (scp command) and run following command (ssh command)
@REM .\bin\debug\PilaniDevOpBackendCode.deploy.cmd /Y

@ECHO COPYING FILES ON SERVER.
scp -r %WORK_FOLDER%\bin\debug %SERVER_ADMINUSER%@%SERVER_IP%:%SERVER_FOLDER%\debug

@ECHO DOING SERVER INSTALLATION NOW USING PASSWORDLESS SSH. THIS WOULD FAIL IF USER/JENKINS/SCRIPT DONT HAVE ADMIN ACCESS.
ssh %SERVER_ADMINUSER%@%SERVER_IP% " %SERVER_FOLDER%\debug\PilaniDevOpBackendCode.deploy.cmd /Y "

@REM : testing api on SERVER
curl http://%SERVER_IP%/PilaniDevOpBackendCode/user

@ECHO DONE BUILD AND DEPLOYMENT
exit /b 0