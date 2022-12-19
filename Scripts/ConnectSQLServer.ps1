# 連線資訊
## 使用SQLServer登入
$datasource = "server" 
$user = "account"
$pwd = "password"
$database = "databse"
$connectionString = "Data Source=$datasource;Initial Catalog=master;User ID=$user;Password=$pwd;ApplicationIntent=ReadOnly"

## 使用Windows登入
# $connectionString = "Data Source=<*InstanceName*>;Initial Catalog=master;Integrated Security=SSPI;ApplicationIntent=ReadOnly"

# 建立連線
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

# 查詢語法
$query = "SELECT * FROM DB_NAME"

#查詢
$command = $connection.CreateCommand()
$command.CommandText = $query

# 存取輸出
$result = $command.ExecuteReader()
$table = New-Object System.Data.DataTable
$table.Load($result)

# 輸出結果
$table | out-file result.txt

# 關閉連線
$Connection.Close()
