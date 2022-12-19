<#
.reference
https://learn.microsoft.com/zh-tw/windows-server/failover-clustering/create-failover-cluster
#>

# 安裝服務
Install-WindowsFeature –Name Failover-Clustering –IncludeManagementTools

# 建立叢集
New-Cluster –Name Cluster01 –Node Server1, Server2 –StaticAddress 192.168.0.8

# 設定檔案共同見證(需開啟叢集電腦對此資料夾"完全控制"的權限)
Set-ClusterQuorum -FileShareWitness \\ADDC\ClusterFolder

# 摧毀叢集
Remove-Cluster -Cluster Cluster01