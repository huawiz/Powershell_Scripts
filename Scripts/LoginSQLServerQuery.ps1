$DirName = ""
function ConnectSQLServerQuery {
  param(
    [parameter(position = 0, mandatory = $false, ValueFromPipeline = $true)][string[]]$CompanyName
  )
  begin {
    # 存放登入資訊路徑
    $configPath = $env:PSModulePath.Split(";")[0] + "\" + $DirName
    $configFile = $env:PSModulePath.Split(";")[0] + "\" + $DirName + "\config.json"
    # 初次使用(尚未建立設定檔案時)，建立設定檔案
    if (-not(Test-path $configPath)) {
      [void](mkdir $configPath)
    }
    if (-not(Test-path $configFile)) {
      [void](echo "" > $configFile)
    }
    if ((Get-Content $configFile) -eq "") {
      write-host "First time run this code. Please Login."
      $loginInfo = @{}
      $loginInfo.hostname = read-host "Host" -AsSecureString | ConvertFrom-SecureString
      $loginInfo.uid = read-host "Account" -AsSecureString | ConvertFrom-SecureString
      $loginInfo.pass = read-host "Password" -AsSecureString | ConvertFrom-SecureString
      $loginInfo | ConvertTo-Json | out-file $configFile
    }
    write-host "`nQuerying..." -BackgroundColor Yellow -ForegroundColor Black
    # 載入設定檔案並且轉成連線字串
    $loginInfo = Get-Content $configFile | ConvertFrom-Json
    $_host = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString -string $loginInfo.hostname)))
    $_uid = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString -string $loginInfo.uid)))
    $_pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString -string $loginInfo.pass)))
    $connectionStr = "Data Source=$_host;Initial Catalog=master;User ID=$_uid;Password=$_pass;ApplicationIntent=ReadOnly"
    # 建立連線
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionStr
    $connection.Open()
  
    # 查詢語法
    $query = ""
      
    #查詢
    $command = $connection.CreateCommand()
    $command.CommandText = $query
  
    # 存取輸出
    $result = $command.ExecuteReader()
    $table = New-Object System.Data.DataTable
    $table.Load($result)
  
    # 關閉連線
    $Connection.Close()
  }
  
  process {
    <#查詢結果要執行的動作#>
  }
  
  end {
    <#結尾動作#>
  }
}
  