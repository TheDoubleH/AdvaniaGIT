﻿if ($BranchSettings.dockerContainerId -gt "") {
    if ([Bool](Get-Module $SetupParameters.containerHelperModuleName)) {
        Import-TestToolkitToNavContainer -containerName $BranchSettings.dockerContainerName -includeTestLibrariesOnly -doNotUpdateSymbols
    } else {
        Start-DockerCustomAction -BranchSettings $BranchSettings -ScriptName $MyInvocation.MyCommand.Name -BuildSettings $BuildSettings
    }
} else {        
    # Import Standard Test Tool Kit
    if (Test-Path (Join-Path $env:SystemDrive 'TestToolKit')) {
        Load-ModelTools -SetupParameters $SetupParameters
        foreach ($testObjectFile in (Get-ChildItem -Path (Join-Path $env:SystemDrive 'TestToolKit\CALTestLibraries*.fob'))) {
            Import-NAVApplicationGITObject -SetupParameters $SetupParameters -BranchSettings $BranchSettings -Path $testObjectFile.FullName -ImportAction Overwrite -SynchronizeSchemaChanges Force
        }
        UnLoad-ModelTools
    }    
}
        

