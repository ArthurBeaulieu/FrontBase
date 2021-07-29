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

echo.
echo Creating js and scss files in src/js and src/scss subdirectory
mkdir src && mkdir src\js && mkdir src\scss
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
echo Source files successfully created

:: Replacing strings in files to properly prepare the folder

echo.
echo Fill configuration files with the information you provided
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
echo Configuration files are up and ready

:: Using npm install if any, display error otherwise

set installed=
call :isNpmInstalled installed
if %installed% == no (
  echo npm is not installed on the system. Please manually install it and run npm install to complete installation.
	exit /B -1
)

echo.
echo Running npm install to finalize component installation
npm install

:: Clearing both .bat and .sh files
echo.
echo This script will now self-destruct to let you a properly set up dev environment
del init.sh
(goto) 2>nul & del "%~f0"

echo.

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
