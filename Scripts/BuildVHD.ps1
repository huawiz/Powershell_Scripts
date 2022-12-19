<#build-VHD -Path 'E:\lab\test' -Parent 'E:\VM\WinServer2019\base.vhdx' -List "AD","Server1","Server2","Server3"
.Usage
1. build-VHD -Path <你要建立的位置> -Parent <父系磁碟位置> -List <主機列表>
2. $string | build-VHD <你要建立的位置> <父系磁碟位置>
#>
# 快速建立差異硬碟
# 可以多對一，例如好幾台都要安裝乾淨的WinServer，那就輸入多台VM的名稱和一個父系硬碟就好
function build-VHD {
    Param (
        [parameter(position = 0, mandatory = $true)][string]$Path, 
        [parameter(position = 1, mandatory = $true)][string]$Parent, 
        [parameter(ValueFromPipeline = $true)][string[]]$List,
        [parameter(position = 2, mandatory = $false)][Alias("open", "run")][switch]$openVM
    )
    begin {
        write-host "Begin."
        # 如果指定父系磁碟不存在即離開
        if (-not(Test-Path $Parent)) {
            write-host "The parent is not defined."
            exit
        }
        # 如果指定目錄不存在，就建立目錄
        if (-not(Test-Path $Path)) {
            Write-Host "Build ${Path}"
            [void](mkdir $Path)
        }
        else {
            write-host "${Path} exists."
        }
    }
    process {
        # 關閉開啟中的主機
        $runningVM = get-vm -name $List | ? { $_.State -eq 'Running' } 
        if ($runningVM -ne $null) {
            stop-vm $runningVM -Force
        }
        Foreach ($VMName in $List) {
            $VHDPath = "${Path}\${VMName}.vhdx"
            if (-not(Test-Path $VHDPath)) {
                # 狀態表示
                Write-Progress -Activity "Building VHD..." -Status "Building ${VMName}..." -PercentComplete ((($List.indexof($VMName) + 1) / $List.count) * 100)
                # 建立差異硬碟
                [void](new-vhd -path $VHDPath -ParentPath $Parent -diff)
                Write-Host "${VHDPath} is finished."
            }
            else {
                Write-Host "${VMName} exists."
            }
            # 設定同名的硬碟到同名的主機
            if (-not(get-VMHardDiskDrive -VMNAME $VMNAME)) {
                Add-VMHardDiskDrive -VMName $VMName -path $VHDPath
            }
            else {
                Set-VMHardDiskDrive -VMName $VMName -path $VHDPath
            }
        }
        # 順便開啟VM
        if ($openVM) {
            start-vm -name $List
            write-host "Running ${List}"
        }
        else {
            $Open = Read-Host "Starts the servers?(Y/N)"
            if ($Open -eq 'Y') {
                start-vm -name $List
                write-host "Running ${List}"
            }
        }
    }
    end {
        write-host "End."
    }
}