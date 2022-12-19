<#SendMail V1 
#.DESCRIPTION
簡易使用原版PS的Send-MailMessage指令寫成的發信程式
不過此指令已經不符合安全規範，微軟說明文件建議改用mailkit
#>



# 範例資料(from Google Sheet)
$Person = @{ 
	#UserData
	Name = "UserName"
	}

# 密碼通行證，要用二階段認證，並且取得應用程式用的密碼
$From = "test@gmail.com"
$Password = "Password" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

# 寄送資料
$props = @{
	From = "test@gmail.com" #寄送帳戶
	To = "$($Person.Name)<$($Person.email)>"
	Body = "Hello,{{Person}}<br>BR,<br>MyName"
	Subject = "Email Title" #標題
	UseSsl = $true
	Port = 587
	BodyAsHtml = $true
	Attachments = "" #若要在Email插入圖片，需要附加檔案
	SmtpServer = "smtp.gmail.com"
    encoding = "utf8" #Unicode
    Credential = $Credential
}




# Replace 信件內容，把資料更新成User資料
$props.Body = $props.Body.Replace('{{Person}}',$Person.Name)



# Send Email
Send-MailMessage @props


