rmdir /s/q ..\PakTemp
mkdir ..\PakTemp
CScript zip.vbs . ..\PakTemp\Hackmaster4e.zip
ren ..\PakTemp\Hackmaster4e.zip Hackmaster4e.pak
xcopy /s/y ..\PakTemp\Hackmaster4e.pak "C:\Users\drplo\AppData\Roaming\Fantasy Grounds\rulesets\"
xcopy /s/y ..\PakTemp\Hackmaster4e.pak "C:\Users\drplo\AppData\Roaming\SmiteWorks\Fantasy Grounds\rulesets\"
pause

