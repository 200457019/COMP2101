# Function to show hardware data
function hardwareDataInfo {
    write "++++++++++++++++++ HARDWARE DATA ++++++++++++++++++"
    gwmi win32_computersystem | 
    fl model, name, domain, manufacturer, totalphysicalmemory
}
# Function to show OS data
function osDataInfo {
    write "++++++++++++++++++ OS DATA ++++++++++++++++++"
    gwmi win32_operatingsystem | select Caption, Version, OSArchitecture | fl
}
# Function to show processor data
function processDataInfo {
    write "++++++++++++++++++ PROCESSOR DATA ++++++++++++++++++"
    gwmi win32_processor | 
    select name, currentclockSpeed, maxclockspeed, numberofcores, 
    @{  n = "L1CacheSize"; e = { 
            switch ($_.L1CacheSize) {
                0 { $valueData = 0 }
                $null { $valueData = "Data Not Found" }
                Default { $valueData = $_.L1CacheSize }
            };
            $valueData }
    },
    @{  n = "L2CacheSize"; e = { 
            switch ($_.L2CacheSize) {
                0 { $valueData = 0 }
                $null { $valueData = "Data Not Found" }
                Default { $valueData = $_.L2CacheSize }
            };
            $valueData }
    },
    @{  n = "L3CacheSize"; e = { switch ($_.L3CacheSize) {
                $null { $valueData = "Data Not Found" }
                0 { $valueData = 0 }
                Default { $valueData = $_.L3CacheSize }
            };
            $valueData }
    } | fl
}
# Function to show ram data
function primaryMemoryInfo {
    write "++++++++++++++++++ PRIMARY MEMORY DATA ++++++++++++++++++"
    $totalPrimaryStorageCapacity = 0
    gwmi win32_physicalmemory |
    ForEach-Object {
        $thisRAM = $_ ;
        New-Object -TypeName psObject -Property @{
            Manufacturer = $thisRAM.Manufacturer
            Description  = $thisRAM.Description
            "Size(in GB)"= $thisRAM.Capacity / 1gb
            Bank         = $thisRAM.banklabel
            Slot         = $thisRAM.devicelocator
        }
        $totalPrimaryStorageCapacity += $thisRAM.Capacity
    } |
    ft manufacturer, description, "Size(in GB)", Bank, Slot -AutoSize
    write "Total RAM Capacity = $($totalPrimaryStorageCapacity/1gb) GB"
}
# Function to show disk data
function diskDriveInfo {
    write "++++++++++++++++++ DISKDRIVE DATA ++++++++++++++++++"
    $allDiskDrives = Get-CIMInstance CIM_diskdrive | Where-Object DeviceID -ne $null
    foreach ($currentDisk in $allDiskDrives) {
        $allPartitions = $currentDisk | get-cimassociatedinstance -resultclassname CIM_diskpartition
        foreach ($currentPartition in $allPartitions) {
            $allLogicalDisks = $currentPartition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($currentLogicalDisk in $allLogicalDisks) {
                new-object -typename psobject -property @{
                    Model          = $currentDisk.Model
                    Manufacturer   = $currentDisk.Manufacturer
                    Location       = $currentPartition.deviceid
                    Drive          = $currentLogicalDisk.deviceid
                    "Size(in GB)"  = [string]($currentLogicalDisk.size / 1gb -as [int]) + 'gb'
                    FreeSpace      = [string]($currentLogicalDisk.FreeSpace / 1gb -as [int]) + 'gb'
                    "FreeSpace(%)" = ([string]((($currentLogicalDisk.FreeSpace / $currentLogicalDisk.Size) * 100) -as [int]) + '%')
                } | ft -AutoSize
            } 
        }
    }   
}
# Function to show network data
function networkDataInfo {
    write "++++++++++++++++++ NETWORK DATA ++++++++++++++++++"
    get-ciminstance win32_networkadapterconfiguration | Where-Object { $_.ipenabled -eq 'True' } | 
    select Index, IPAddress, Description, 
    @{
        n = 'Subnet';
        e = {
            switch ($_.Subnet) {
                $null { $valueData = 'Data Not Found' }
                Default { $valueData = $_.Subnet }
            };
            $valueData
        }
    }, 
    DNSDomain, DNSServerSearchOrder |
    ft Index, IPaddress, Description, Subnet, DNSDomain, DNSserversearchorder
}
# Function to show graphics data
function graphicDataInfo {
    write "++++++++++++++++++ GRAPHICS DATA ++++++++++++++++++"
    $videoData = gwmi win32_videocontroller
    $videoData = New-Object -TypeName psObject -Property @{
        Name             = $videoData.Name
        Description      = $videoData.Description
        ScreenResolution = [string]($videoData.CurrentHorizontalResolution) + 'px * ' + [string]($videoData.CurrentVerticalResolution) + 'px'
    } | fl Name, Description, ScreenResolution
    
    $videoData
}
    
    
hardwareDataInfo
osDataInfo
processDataInfo
primaryMemoryInfo
diskDriveInfo
networkDataInfo
graphicDataInfo