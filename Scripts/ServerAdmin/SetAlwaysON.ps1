<#開啟SQL Server AlwaysON功能#>

# 新增防火牆規則，加入連接埠1433與5022
New-NetFirewallRule -DisplayName FireWallRule -Action allow -LocalPort 1433,5022 -Direction Inbound -Protocol TCP

# 開啟指定Instance的AlwaysON服務
# Default會連接到此台主機上的MSSQLSERVER的Instance
Enable-SqlAlwaysOn -Path "SQLSERVER:\Sql\Server1\Default" -Force 

# 創DB
Invoke-Sqlcmd -Query "Create Database Test"
Invoke-Sqlcmd -Query "Use Test;Create table t1(c1 int,c2 int)"

# Set AG群組
$PrimaryServer = Get-Item "SQLSERVER:\SQL\Server1\Default"
$SecondaryServer = Get-Item "SQLSERVER:\SQL\Server2\Default"
$PrimaryReplica = New-SqlAvailabilityReplica -Name "Server1\Default" -EndpointUrl "TCP://server1.company.ad:5022" -FailoverMode "Automatic" -AvailabilityMode "SynchronousCommit" -AsTemplate -Version ($PrimaryServer.Version)
$SecondaryReplica = New-SqlAvailabilityReplica -Name "Server2\Default" -EndpointUrl "TCP://server2.company.ad:5022" -FailoverMode "Automatic" -AvailabilityMode "SynchronousCommit" -AsTemplate -Version ($SecondaryServer.Version) 
New-SqlAvailabilityGroup -InputObject $PrimaryServer -Name "MainAG" -AvailabilityReplica ($PrimaryReplica, $SecondaryReplica) -Database @("Test","Test")