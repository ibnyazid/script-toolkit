<#
.SYNOPSIS
    Downloads a YouTube video as MP3 with embedded thumbnail and metadata using yt-dlp and ffmpeg.
.DESCRIPTION
    Automatically downloads the portable version of yt-dlp locally if not found.
    Embeds the thumbnail and sets the Artist tag (defaulting to the uploader). Requires ffmpeg.
#>

# Ensure UTF-8 encoding for proper character display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== YouTube to MP3 Downloader with Thumbnail & Metadata ===" -ForegroundColor Cyan

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

# Check if ffmpeg is available (required for audio conversion and embedding)
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

Write-Host "`n[1/3] Downloading audio, embedding thumbnail and artist metadata..." -ForegroundColor Green

# Extract audio, embed metadata (defaulting artist to uploader), and embed/clean up thumbnail
& $ytDlpBinary `
    --extract-audio `
    --audio-format mp3 `
    --audio-quality 0 `
    --embed-metadata `
    --parse-metadata "%(artist,uploader)s:%(meta_artist)s" `
    --embed-thumbnail `
    --convert-thumbnails jpg `
    -o "%(title)s.%(ext)s" `
    $url

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nSuccess! MP3 created with embedded thumbnail and artist metadata." -ForegroundColor Green
} else {
    Write-Host "`nAn error occurred during the download/conversion process." -ForegroundColor Red
}
