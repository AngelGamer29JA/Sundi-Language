@echo off
set version=0.0.1
set versionType=PROTOTYPE
set debug=false
set env_variables=debug=%debug%,version=%version%,versionType=%versionType%
set output=build\sundi.exe

echo Version %version% - %versionType%
echo Debug Mode %debug%
echo Output: %output%
echo env: %env_variables%
echo Compilando...
if not exist build\ ( mkdir build\ )
dart compile exe bin\sundilang.dart -o %output% --define=%env_variables%
