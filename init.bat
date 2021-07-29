@set vers=0.1.0

:: Scrip welcome message and explanation

echo OFF
echo ## ---------------------------------- ##
echo ##        FrontBase installer         ##
echo ##          2021 -- GPL-3.0           ##
echo ##              v%vers%                ##
echo ## ---------------------------------- ##
echo.
echo This installer will update the configuration files to match your newly created project.
echo It will also create for you the es6 JavaScript class and the scss file.
echo First, we need several information about it :
echo.

:: Ask user mandatory information

set /p username="What is your username (GitHub account or else) ? "
set /p component="What is the name of this project ? "
set /p version="What is its version number ? "

:: Creating .scss and .js files

echo OFF
echo * { box-sizing: border-box }>%CD%\src\scss\%component%.scss
(
	echo import '../scss/%component%.scss';
	echo.
	echo class %component% {
	echo   constructor^(^) {}
	echo }
	echo.
	echo export default %component%;
)>%CD%\src\js\%component%.js

:: Replacing strings in files to properly prepare the folder

echo.
echo Replacing in demo/example.html
call :replaceInFile demo\example.html COMPONENT %component%
call :replaceInFile demo\example.html VERSION %version%

echo Replacing in doc/jsDoc.json
call :replaceInFile doc/jsDoc.json COMPONENT %component%

echo Replacing in webpack/plugins.js
call :replaceInFile webpack/plugins.js COMPONENT %component%

echo Replacing in webpack/webpack.common.js
call :replaceInFile webpack/webpack.common.js COMPONENT %component%

echo Replacing in package.json
call :replaceInFile package.json USERNAME %username%
call :replaceInFile package.json COMPONENT %component%
call :replaceInFile package.json VERSION %version%

:: Using npm install if any, display error otherwise

set installed=
call :isNpmInstalled installed
if %installed% == no (
  echo npm is not installed on the system. Please manually install it and run npm install to complete installation.
	exit /B -1
)

echo Running npm install to finalize component installation
rem npm install

exit /B %ERRORLEVEL%

:: Function definition

:replaceInFile
setlocal EnableDelayedExpansion
set INTEXTFILE=%~1
set SEARCHTEXT=%~2
set REPLACETEXT=%~3
powershell -NoP -C "(Get-Content $ENV:INTEXTFILE) -Replace $ENV:SEARCHTEXT,$ENV:REPLACETEXT|Set-Content $ENV:INTEXTFILE"
goto :eof

:isNpmInstalled
where node -v >nul 2>&1 && set %1=yes || set %1=no
goto :eof
