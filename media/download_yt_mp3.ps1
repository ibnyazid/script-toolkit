<#
.SYNOPSIS
    Downloads a YouTube video as MP3 with embedded thumbnail using yt-dlp and ffmpeg.
.DESCRIPTION
    Automatically downloads the portable version of yt-dlp locally if not found. Requires ffmpeg.
#>

# Ensure UTF-8 encoding for proper character display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== YouTube to MP3 Downloader with Thumbnail ===" -ForegroundColor Cyan

# Determine script directory
if ($PSScriptRoot) {
    $scriptDir = $PSScriptRoot
} else {
    $scriptDir = (Get-Location).Path
}

$localYtDlp = Join-Path $scriptDir "yt-dlp.exe"
$ytDlpCmd = Get-Command "yt-dlp" -ErrorAction SilentlyContinue

# Check and auto-download yt-dlp if missing
if (-not $ytDlpCmd -and -not (Test-Path $localYtDlp)) {
    Write-Host "yt-dlp not detected. Downloading portable version to script directory..." -ForegroundColor Yellow
    $downloadUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $downloadUrl -OutFile $localYtDlp -UseBasicParsing
        Write-Host "Successfully downloaded yt-dlp.exe!" -ForegroundColor Green
    } catch {
        Write-Host "Error downloading yt-dlp: $_" -ForegroundColor Red
        Exit
    }
}

# Select the available executable
if (Test-Path $localYtDlp) {
    $ytDlpBinary = $localYtDlp
} else {
    $ytDlpBinary = "yt-dlp"
}

# Check if ffmpeg is available (required for audio conversion and thumbnail embedding)
if (-not (Get-Command "ffmpeg" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: 'ffmpeg' is not installed or not in your PATH." -ForegroundColor Red
    Write-Host "Install it via winget: winget install Gyan.FFmpeg" -ForegroundColor Yellow
    Exit
}

# Prompt user for YouTube URL
$url = Read-Host -Prompt "Enter the YouTube video URL"
if ([string]::IsNullOrWhiteSpace($url)) {
    Write-Host "URL cannot be empty. Exiting." -ForegroundColor Red
    Exit
}

Write-Host "`n[1/3] Downloading audio and thumbnail..." -ForegroundColor Green

# Run yt-dlp to extract audio, embed thumbnail, and save as MP3
& $ytDlpBinary --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --convert-thumbnails jpg -o "%(title)s.%(ext)s" $url

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSuccess! Download, conversion, and thumbnail embedding completed." -ForegroundColor Green
} else {
    Write-Host "`nAn error occurred during the download/conversion process." -ForegroundColor Red
}
