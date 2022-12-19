param(
    [parameter(position = 0)]
    [string] $Path
)


$docFiles = (Get-ChildItem $Path -Include *.docx, *.doc -Recurse)
$word = New-Object -com Word.Application

# 顯示word動作畫面
$word.visible = $true
foreach ($docFile in $docFiles) {
    # 進度條
    if ($docFiles.count -ge 2) {
        Write-Progress -Activity "Running ..." -Status "Editting ${docFile}..." -PercentComplete ((($docFiles.indexof($docFile) + 1) / $docFiles.count) * 100) -ErrorAction stop
    }
    else {
        write-host "Editting ${docFile}..." -ErrorAction stop
    }
    # 開啟目錄Word檔案
    $doc = $word.Documents.Open($docFile.FullName)
    $docname = $docFile.Name
    # 轉換為A4大小
    $doc.PageSetup.PaperSize = [Microsoft.Office.Interop.Word.WdPaperSize]::wdPaperA4
    # 設定自動換行
    $doc.Paragraphs.WordWrap = 0  
    # 存檔與關閉
    $doc.Save()
    $doc.Close()
}
Write-Progress -Completed -Activity "Finished."
$word.Quit()
Write-Host "Finished."
cmd /c pause