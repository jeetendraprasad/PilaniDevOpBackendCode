echo %~dp0

SET PATH=%SystemRoot%\System32\WindowsPowerShell\v1.0\;%PATH%

@echo STARTING BUILD NOW

powershell -command " 'dotnet version is' ; dotnet --version; "

dotnet build

@REM ssh jeete@192.168.87.1 dir

@REM exit /b 0

dotnet publish -p:PublishProfile=IISProfile

@ECHO DOING LOCAL INSTALLATION NOW
powershell -command " .\bin\debug\PilaniDevOpBackendCode.deploy.cmd /Y "

@REM PENDING is deployment in
@REM local macine : C:\tmp\client
@REM server : development@192.168.x.y

@ECHO DONE BUILD AND DEPLOYMENT
exit /b 0