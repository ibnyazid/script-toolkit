<#
.SYNOPSIS
Download all tracks from a SoundCloud playlist as MP3 files.

.DESCRIPTION
Prompts the user for a SoundCloud playlist URL, then uses yt-dlp to download
all tracks as high-quality MP3 files. Metadata and thumbnails are embedded.

- Automatically creates a "downloads" folder if it does not exist
- Maintains an archive file to avoid re-downloading tracks
- Generates a log file per playlist
- Downloads yt-dlp automatically if not found locally or in PATH

.PARAMETER None
This script prompts for input interactively (playlist URL).

.EXAMPLE
Run the script and enter a playlist URL when prompted:

    .\download-soundcloud-playlist.ps1

.EXAMPLE
Example playlist URL input:

    https://soundcloud.com/user/sets/example-playlist

.OUTPUTS
- MP3 files saved to:
    ./downloads/<playlist_name>/

- Log file saved as:
    ./<playlist_name>.log

- Archive file:
    ./archive.txt

.REQUIREMENTS
- PowerShell 5.1+ (PowerShell 7 recommended)
- Internet connection
- yt-dlp (auto-downloaded if missing)
- ffmpeg (must be installed and available in PATH)

.NOTES
- Some parts of this script were generated or assisted by AI tools.
- Review before use, especially if modifying download behavior.
- Filenames are sanitized to avoid invalid characters on Windows.

#>
# Ask user for playlist URL
$playlistUrl = Read-Host "Enter SoundCloud playlist URL"

# Base paths
$basePath = Get-Location
$outputFolder = Join-Path $basePath "downloads"
$archiveFile = Join-Path $basePath "archive.txt"

# Ensure downloads folder exists
if (!(Test-Path $outputFolder))
{
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# ---- Resolve yt-dlp ----
$ytDlp = $null

if (Test-Path ".\yt-dlp.exe")
{
    $ytDlp = ".\yt-dlp.exe"
} elseif (Get-Command yt-dlp -ErrorAction SilentlyContinue)
{
    $ytDlp = "yt-dlp"
} else
{
    Write-Host "yt-dlp not found. Downloading latest version..."
    $downloadUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    $targetPath = Join-Path $basePath "yt-dlp.exe"

    try
    {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $targetPath
        $ytDlp = ".\yt-dlp.exe"
    } catch
    {
        Write-Error "Failed to download yt-dlp."
        exit
    }
}

# Temporary log file
$tempLog = Join-Path $basePath "temp_download.log"

"==== Download started: $(Get-Date) ====" | Out-File -FilePath $tempLog

# ---- Run yt-dlp (ONLY ONCE) ----
& $ytDlp `
    -f bestaudio `
    --extract-audio `
    --audio-format mp3 `
    --audio-quality 0 `
    --embed-metadata `
    --embed-thumbnail `
    --download-archive $archiveFile `
    -N 4 `
    --concurrent-fragments 4 `
    --retries 10 `
    --fragment-retries 10 `
    --retry-sleep 5 `
    --newline `
    -o "$outputFolder\%(playlist_title)s\%(title)s.%(ext)s" `
    $playlistUrl 2>&1 | Tee-Object -FilePath $tempLog -Append

"==== Download finished: $(Get-Date) ====" | Out-File -FilePath $tempLog -Append

# ---- Extract playlist title from log ----
$playlistTitle = Select-String -Path $tempLog -Pattern "Destination: .*\\(.+?)\\" |
    ForEach-Object {
        if ($_ -match "Destination: .*\\(.+?)\\")
        { $matches[1]
        }
    } | Select-Object -First 1

# Fallback if not found
if ([string]::IsNullOrWhiteSpace($playlistTitle))
{
    $playlistTitle = "playlist_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

# Sanitize filename
$playlistTitle = $playlistTitle -replace '[\\/:*?"<>|]', '_'

# Final log name
$finalLog = Join-Path $basePath "$playlistTitle.log"

# Rename temp log
Move-Item -Path $tempLog -Destination $finalLog -Force

Write-Host "Download complete! Log saved to $finalLog"
