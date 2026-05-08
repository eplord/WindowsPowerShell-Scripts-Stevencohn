<#
.SYNOPSIS
Enables or disables the screensaver and related locking behavior for RDP sessions.

.PARAMETER Disable
If specified then the screensaver and all locking behavior will be disabled.
If not specified then enables the default screensaver and locking behavior.
#>
param(
    [switch] $Disable
)

Begin
{
    function DisableScreensaver
    {
        # --- Disable Screensaver ---
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value "0"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name SCRNSAVE.EXE -Value ""
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaverIsSecure -Value "0"

        # --- Disable Lock Screen Timeout (Console) ---
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveTimeOut -Value "0"

        # --- Disable Winlogon Inactivity Timeout ---
        New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies" -Name System -Force | Out-Null
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name InactivityTimeoutSecs -Value 0

        # --- Disable RDP Idle Timeout ---
        New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows NT" -Name 'Terminal Services' -Force | Out-Null
        Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows NT\Terminal Services" -Name MaxIdleTime -Value 0

        # --- Disable Console Auto-Lock ---
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name LockScreenAutoLock -Value "0"

        Write-Host "Screensaver and all locking behavior disabled." -fo Magenta
    }

    function EnableScreensaver
    {
        # --- Restore Screensaver Defaults ---
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value "1"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name SCRNSAVE.EXE -Value "C:\WINDOWS\system32\scrnsave.scr"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaverIsSecure -Value "1"
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name ScreenSaveTimeOut -Value "900"   # 15 minutes

        # --- Restore Winlogon Inactivity Timeout ---
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name InactivityTimeoutSecs -ErrorAction SilentlyContinue

        # --- Restore RDP Idle Timeout ---
        Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows NT\Terminal Services" -Name MaxIdleTime -ErrorAction SilentlyContinue

        # --- Restore Auto-Lock ---
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name LockScreenAutoLock -Value "1"

        Write-Host "Screensaver and lock behavior restored to defaults." -fo Green
    }
}
Process
{
    if ($Disable)
    {
        DisableScreensaver
    }
    else
    {
        EnableScreensaver
    }
}