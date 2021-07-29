@set vers=0.1.0

:: Script welcome message and explanation

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

set /p username="What is your GitHub username ? "
set /p component="What is the name of this project ? "
set /p description="How would you describe it ? "
set /p version="What is its version number ? "
set /p license="Which distribution license do you want to use ? "

:: Creating .scss and .js files (source and test)

echo.
echo Handling js and scss files in src/js, test file and src/scss subdirectories
echo  -^> Creating required subdirectories
if not exist src ( mkdir src )
if not exist src\js ( mkdir src\js )
if not exist src\scss ( mkdir src\scss )
echo  -^> Creating source files
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
(
	echo import '../src/js/%component%.js';
	echo.
	echo describe^('%component% test', ^(^) =^> {
	echo   it^('Unit test', done =^> {
	echo     done^(^);
	echo   }^);
	echo }^);
)>%CD%\test\%component%.spec.js
echo Source files successfully created

:: Replacing strings in files to properly prepare the folder

echo.
echo Fill configuration files with the information you provided
echo  -^> Replacing in demo/example.html
call :replaceInFile demo\example.html COMPONENT %component%
call :replaceInFile demo\example.html VERSION %version%
echo  -^> Replacing in doc/jsDoc.json
call :replaceInFile doc/jsDoc.json COMPONENT %component%
echo  -^> Replacing in webpack/plugins.js
call :replaceInFile webpack/plugins.js COMPONENT %component%
echo  -^> Replacing in webpack/webpack.common.js
call :replaceInFile webpack/webpack.common.js COMPONENT %component%
echo  -^> Replacing in package.json
call :replaceInFile package.json USERNAME %username%
call :replaceInFile package.json COMPONENT %component%
call :replaceInFile package.json DESCRIPTION %description%
call :replaceInFile package.json PROJECT_VERSION %version%
call :replaceInFile package.json PROJECT_LICENSE %license%
echo Configuration files are up and ready

:: Clear README.md and prepare it with user information

echo.
echo Editing README.md to match project information
call :clearMD
echo README.md file now reflect the new project

:: Using npm install if any, display error otherwise

echo.
set installed=
call :isNpmInstalled installed
if %installed% == no (
  echo npm is not installed on the system. Please manually install it and run npm install to complete installation.
	exit /B -1
)

echo Running npm install to install component dependencies
call npm install
call npm run build

:: Clearing both .bat and .sh files

echo.
echo This script will now self-destruct to let you a properly use this dev environment
echo You can now start to develop. See package.json scripts commands for usage
del init.sh
(goto) 2>nul & del "%~f0"
exit /B %ERRORLEVEL%

:: Function definition

:replaceInFile
setlocal EnableDelayedExpansion
set INTEXTFILE=%~1
set SEARCHTEXT=%~2
set REPLACETEXT=%~3
powershell -NoP -C "(Get-Content $ENV:INTEXTFILE) -Replace $ENV:SEARCHTEXT,$ENV:REPLACETEXT|Set-Content $ENV:INTEXTFILE"
goto :eof

:clearMD
break>README.md
echo OFF
(
	echo ^# %component%
	echo.
	echo ![]^(https://badgen.net/badge/version/%license%/blue^)
	echo ![License]^(https://img.shields.io/github/license/%username%/%component%.svg^)
	echo ![Doc]^(https://badgen.net/badge/documentation/TODO/orange^)
	echo ![Test]^(https://badgen.net/badge/test/TODO/orange^)
	echo.
	echo %description%
	echo.
	echo %component% %version% - %license% - %username%
)>%CD%\README.md
goto :eof

:isNpmInstalled
where node -v >nul 2>&1 && set %1=yes || set %1=no
goto :eof
