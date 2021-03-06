﻿Function Remove-NAVAzureDnsZoneRecordSet {
    param(
        [Parameter(Mandatory=$False, ValueFromPipelineByPropertyname=$true)]
        [PSObject]$DnsZone,
        [Parameter(Mandatory=$True, ValueFromPipelineByPropertyname=$true)]
        [String]$DnsHostName
    )

    if (!$DnsZone) { $DnsZone = Get-NAVAzureDnsZone -DnsHostName $DnsHostName }
    Remove-AzureRmDnsRecordSet -Name $DnsHostName.Split('.').GetValue(0) -ZoneName $DnsZone.Name -ResourceGroupName $DnsZone.ResourceGroupName -RecordType CNAME -ErrorAction SilentlyContinue
}