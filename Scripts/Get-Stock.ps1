function get-stock {
    param(
        [parameter(position = 0, mandatory = $true)][string]$LastDate,
        [parameter(position = 1, Mandatory = $true)][string]$StockID
    )
    
    #stock api
    $web = 'https://www.twse.com.tw/exchangeReport/STOCK_DAY?response=json&'
    $condition = "date=$LastDate&stockNo=$StockID"

    $stock = Invoke-RestMethod ($web+$condition)

    #detail
    $YM = $stock.title.Split(' ')[0]
    $title = $stock.title.Split(' ')[2]

    #header,body for combine csv
    $h = ($stock.fields -join ';') + "`n"
    $b = ($stock.data | % { $_ -join ';' }) -join "`n"
    $csv = $h + $b

    #output
    write-host "$title 資訊如下:  ($YM)"
    convertfrom-csv $csv -Delimiter ';' | ft
}
