# Exports the data from SQL Server into docs\data.js for the web page.
# Usage (from this folder):   .\export_data.ps1
# Another server:             .\export_data.ps1 -Server "localhost"

param([string]$Server = "(localdb)\MSSQLLocalDB")

# -y 0 = don't cut off long text (the JSON is one long value)
$output = sqlcmd -S $Server -E -b -y 0 -i "$PSScriptRoot\sql\04_export_json.sql"
if ($LASTEXITCODE -ne 0) { throw "Export failed. Did you run the scripts in the sql folder first?" }

# sqlcmd prints a column header before the value; keep only the JSON part.
$text = $output -join ""
$json = $text.Substring($text.IndexOf("{"), $text.LastIndexOf("}") - $text.IndexOf("{") + 1)

# Save as a .js file so the page also works when opened straight from disk.
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText("$PSScriptRoot\docs\data.js", "window.DATA = $json;", $utf8)
Write-Host "Saved docs\data.js. Open docs\index.html in your browser."
