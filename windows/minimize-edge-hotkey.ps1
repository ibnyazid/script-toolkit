<#
.SYNOPSIS
Minimizes all Microsoft Edge windows.

.DESCRIPTION
Finds all running Microsoft Edge (msedge.exe) processes and minimizes
their main windows using the Windows User32 API (ShowWindow).

This is useful for quickly hiding all Edge windows via a script or hotkey.

.OUTPUTS
None

.REQUIREMENTS
- Windows OS
- PowerShell 5.1+ (or PowerShell 7+)
- Microsoft Edge installed

.NOTES
- Uses P/Invoke (user32.dll) to control window state.
- Only minimizes main windows; background processes are ignored.
- Some Edge windows (e.g., child or special UI windows) may not be affected.
- This script was written with AI assistance and manually reviewed.

#>
# Define user32.dll functions for window management
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    public const int SW_MINIMIZE = 2;
}
"@

# Function to minimize all Microsoft Edge windows
function Invoke-MinimizeEdgeWindows
{
    # Get all Edge processes
    $EdgeProcesses = Get-Process | Where-Object { $_.ProcessName -eq "msedge" }

    foreach ($process in $EdgeProcesses)
    {
        # Get the main window handle
        $hwnd = $process.MainWindowHandle
        if ($hwnd -ne [IntPtr]::Zero)
        {
            # Minimize the window
            [User32]::ShowWindow($hwnd, [User32]::SW_MINIMIZE)
        }
    }
}

# Call the function
Invoke-MinimizeEdgeWindows
