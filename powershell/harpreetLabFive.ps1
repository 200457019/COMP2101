param ( [switch]$Disks, [switch]$Network , [switch]$System)

if ( !($System) -and !($Disks) -and !($Network)) {
    hardwareDataInfo
    processDataInfo
    osDataInfo
    primaryMemoryInfo
    graphicDataInfo
    diskDriveInfo
    networkDataInfo
}

if ($System) {
    hardwareDataInfo
    processDataInfo
    osDataInfo
    primaryMemoryInfo
    graphicDataInfo
}
if ($Disks) {
    diskDriveInfo
}
if ($Network) {
    networkDataInfo
}