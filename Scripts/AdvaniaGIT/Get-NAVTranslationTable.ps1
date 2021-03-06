﻿Function Get-NAVTranslationTable
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [String]$TranslationFile,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyname=$true)]
        [String]$LanguageNo,
        [Parameter(Mandatory=$False, ValueFromPipelineByPropertyname=$true)]
        [hashtable]$TranslateTable,
        [Parameter(Mandatory=$False, ValueFromPipelineByPropertyname=$true)]
        [Switch]$SaveToCSV
    )

    Write-Host "Loading translation data from ${TranslationFile}..."
    $File = Get-Item -Path $TranslationFile
    if ($File.Extension -ieq 'csv') {
        $TranslateTable = Import-Csv -Path $TranslationFile -Encoding UTF8
    } else {
        $CALTranslateFile = Get-Content -Encoding Oem -Path $TranslationFile
        $NoOfLines = $CALTranslateFile.Count
        $LinesRead = 0;
        $LanguageNo = '-A' + $LanguageNo
        $enuTable = New-Object System.Collections.Hashtable
        $transTable = New-Object System.Collections.Hashtable
        foreach ($CALTranslateLine in $CALTranslateFile) {    
            $LinesRead += 1
            $transTable.Add($CALTranslateLine.Substring(0,$CALTranslateLine.IndexOf(':')),$CALTranslateLine.Substring($CALTranslateLine.IndexOf(':') + 1))
            Write-Progress -Activity "Reading CAL Translation File" -PercentComplete (100 * $LinesRead / $NoOfLines)
        }
    
        $NoOfLines = $transTable.Count
        $LinesRead = 0;
        foreach ($key in $transTable.Keys) {
            $LinesRead += 1
            if ($key -match '-A1033') {
                $lang = $key.Replace('-A1033',$LanguageNo)
                if (!$TranslateTable.ContainsKey($transTable.Item($key))) {
                    if ($transTable.ContainsKey($lang)) {                
                       $TranslateTable.Add($transTable.Item($key),$transTable.Item($lang))
                    }            
                }
            }
            Write-Progress -Activity "Adding translation" -PercentComplete (100 * $LinesRead / $NoOfLines)
        }
        if ($SaveToCSV) {
            $TranslationFile = "$(Join-Path $File.Directory $File.BaseName).csv"
            $TranslateTable.GetEnumerator() | Select Key,Value | Export-Csv -Path $TranslationFile -Encoding UTF8
        }
    }
    
    return $TranslateTable    
}
