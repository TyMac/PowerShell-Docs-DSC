[CmdletBinding()]
param()

begin {
    $SharedParameters = @{
        Name       = 'Service'
        ModuleName = 'PSDscResource'
        Properties = @{
            Name   = 'Service1'
            Ensure = 'Present'
            Path   = 'C:\FilePath\MyServiceExecutable.exe'
        }
    }

    $NonGetProperties = @(
        'Ensure'
        'Path'
    )
}

process {
    $TestResult = Invoke-DscResource -Method Test @SharedParameters

    if ($TestResult.InDesiredState) {
        $QueryParameters = $SharedParameters.Clone()

        foreach ($Property in $NonGetProperties) {
            $QueryParameters.Properties.Remove($Property)
        }

        Invoke-DscResource -Method Get @QueryParameters
    } else {
        Invoke-DscResource -Method Set @SharedParameters
    }
}
