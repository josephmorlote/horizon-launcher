# Fire TV tune-up from a Windows PC: the same clean-up as Horizon's Settings > Device Tune-Up, for
# Fire TVs whose Fire OS version doesn't let an app on the TV do it.
#
# Before running:
#   1. On the Fire TV: Settings > My Fire TV > Developer Options > ADB Debugging > On.
#      (No Developer Options? My Fire TV > About, press Select on the device name 7 times.)
#   2. Find its address: Settings > My Fire TV > About > Network > IP Address.
#   3. The PC has to be on the same Wi-Fi as the Fire TV.
#   4. Get Google's "platform-tools" (https://developer.android.com/tools/releases/platform-tools),
#      unzip it, and put this file in the same folder as adb.exe (or pass -Adb "path\to\adb.exe").
#
#   powershell -ExecutionPolicy Bypass -File tune-up-firetv.ps1 -Ip 192.168.1.50                 # optimize
#   powershell -ExecutionPolicy Bypass -File tune-up-firetv.ps1 -Ip 192.168.1.50 -LiveTv -Alexa  # also turn off Live TV / Alexa voice
#   powershell -ExecutionPolicy Bypass -File tune-up-firetv.ps1 -Ip 192.168.1.50 -BlockUpdates   # also turn off the Fire OS updater
#   powershell -ExecutionPolicy Bypass -File tune-up-firetv.ps1 -Ip 192.168.1.50 -Undo           # put everything back
#
# The first time, the TV asks "Allow USB debugging?": tick Always allow and choose Allow.
# Everything here is "disable", never "uninstall", so -Undo (or a factory reset) restores it.
# Fire OS protects some of these and refuses; those lines say so and nothing is forced.
param(
    [string]$Ip,
    [switch]$LiveTv, [switch]$Alexa, [switch]$BlockUpdates, [switch]$Undo,
    [string]$Adb = "$PSScriptRoot\adb.exe"
)
# Run with no address (double-clicking "Tune Up Fire TV.cmd" does): ask for everything.
if (-not $Ip) {
    Write-Host "Fire TV tune-up. On the TV, Horizon's Settings > Device Tune-Up shows the address to type here."
    $Ip = Read-Host "Fire TV address (like 192.168.1.50)"
    $choice = Read-Host "Type 1 to optimize, 2 to put everything back"
    if ($choice -eq "2") { $Undo = $true } else {
        if ((Read-Host "Also turn off Live TV? The remote's Live TV button stops working (y/n)") -eq "y") { $LiveTv = $true }
        if ((Read-Host "Also turn off Alexa voice? The microphone button stops working (y/n)") -eq "y") { $Alexa = $true }
        if ((Read-Host "Also turn off the Fire OS updater? No more system updates or security fixes (y/n)") -eq "y") { $BlockUpdates = $true }
    }
}
# adb: next to this file, on the PATH, or fetched from Google (their official "platform-tools" download).
if (-not (Test-Path $Adb)) {
    $found = Get-Command adb -ErrorAction SilentlyContinue
    if ($found) { $Adb = $found.Source } else {
        $tools = "$PSScriptRoot\platform-tools"
        if (-not (Test-Path "$tools\adb.exe")) {
            Write-Host "Getting Google's platform-tools (adb)..."
            $zip = "$PSScriptRoot\platform-tools.zip"
            Invoke-WebRequest "https://dl.google.com/android/repository/platform-tools-latest-windows.zip" -OutFile $zip -UseBasicParsing
            Expand-Archive $zip -DestinationPath $PSScriptRoot -Force
            Remove-Item $zip
        }
        $Adb = "$tools\adb.exe"
    }
}
$device = "${Ip}:5555"

# Keep these lists the same as DeviceTune.kt in Horizon.
$extras = @(
    # Ads, tracking and usage reporting.
    "com.amazon.tv.acr", "com.amazon.hybridadidservice", "com.amazon.kso.blackbird", "com.amazon.sneakpeek",
    "com.amazon.ftvads.deeplinking", "com.amazon.media.recommendations",
    "com.amazon.dp.logger", "com.amazon.wirelessmetrics.service", "com.amazon.perfcollection",
    "com.amazon.device.crashmanager", "com.amazon.device.logmanager", "com.amazon.logan",
    "com.amazon.neo.minerva.logcat", "com.amazon.device.telemetry.emitter",
    # Shopping, promotions and Amazon home's own features.
    "com.amazon.shoptv.client", "com.amazon.shoptv.firetv.client", "com.amazon.minitv.android.app",
    "com.amazon.tv.ftvambient", "com.amazon.gamehub", "com.amazon.tahoe", "com.amazon.smarthomemapviewapp",
    "com.amazon.tv.earlyaccess", "com.amazon.tv.releasenotes", "com.amazon.tv.website_launcher",
    "com.amazon.whisperjoin.middleware.v2.np",
    # Tutorials and tips.
    "com.amazon.storm.lightning.tutorial", "com.amazon.tmm.tutorial", "com.android.protips",
    "com.android.printservice.recommendation"
)
$liveTvApps = @("com.amazon.tv.livetv")     # off: the remote's Live TV button does nothing
$alexaApps = @("com.amazon.vizzini", "com.amazon.alexamediaplayer.runtime.ftv", "com.amazon.alexa.datastore.app")   # off: the microphone button does nothing
$updateApps = @("com.amazon.device.software.ota", "com.amazon.device.software.ota.override", "com.amazon.tv.forcedotaupdater.v2", "com.amazon.tv.easyupgrade")

& $Adb connect $device | Out-Null
if ((& $Adb -s $device get-state) -ne "device") { throw "Couldn't reach the Fire TV at $Ip. Check the address, ADB Debugging, and the Allow box on the TV." }
$installed = (& $Adb -s $device shell "pm list packages") -replace "package:", ""
function Available { [int]((& $Adb -s $device shell "grep MemAvailable /proc/meminfo") -replace '\D', '') / 1024 }

function Set-Apps($packages, [bool]$on) {
    foreach ($p in $packages) {
        if ($installed -notcontains $p) { continue }
        $out = (& $Adb -s $device shell $(if ($on) { "pm enable $p" } else { "pm disable-user --user 0 $p" })) -join " "
        if (-not $on) { & $Adb -s $device shell "am force-stop $p" | Out-Null }
        Write-Host ("{0,-44} {1}" -f $p, $(if ($out -match "new state") { $(if ($on) { "on" } else { "off" }) } else { "Fire OS wouldn't allow it" }))
    }
}

if ($Undo) {
    Set-Apps ($extras + $liveTvApps + $alexaApps + $updateApps) $true
    & $Adb -s $device shell "settings put global window_animation_scale 1; settings put global transition_animation_scale 1"
    Write-Host "`nEverything is back on. Restart the Fire TV to finish."
    return
}

$before = Available
Set-Apps $extras $false
if ($LiveTv) { Set-Apps $liveTvApps $false }
if ($Alexa) { Set-Apps $alexaApps $false }
if ($BlockUpdates) { Set-Apps $updateApps $false }
& $Adb -s $device shell "settings put global window_animation_scale 0.5; settings put global transition_animation_scale 0.5"
# Free memory now: drop every app that's only cached in the background, and clear app caches.
& $Adb -s $device shell "am kill-all; pm trim-caches 999G" | Out-Null
Start-Sleep -Seconds 3
Write-Host ("`nMemory available: {0:N0} MB before, {1:N0} MB now. Restart the Fire TV to finish." -f $before, (Available))
