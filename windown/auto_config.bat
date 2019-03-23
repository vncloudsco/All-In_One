tzutil /s "SE Asia Standard Time"
net start audiosrv
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
REG ADD HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters\ /v AllowEncryptionOracle /t REG_DWORD /d 2
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v ColorPrevalence /t REG_DWORD /d 1 /f
Reg Add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v ColorPrevalence /t REG_DWORD /d 1 /f
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco install googlechrome -y
START chrome.exe
choco install flashplayerplugin -y
choco install jre8 -y
choco install winrar -y
choco install putty.install -y
choco install firefox -y
choco install directx -y
choco install vnc-viewer -y
choco install winscp -y
choco install brave -y
choco install notepadplusplus.install -y
taskkill /f /im explorer.exe
start explorer.exe
start taskmgr.exe
