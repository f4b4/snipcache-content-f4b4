Function WriteCommand($command)
{
    Write-Host -ForegroundColor Blue "##[command] $command"
}

Function WriteSection($message)
{
    Write-Host -ForegroundColor Green "##[section] $message"
}

# Writes a warning to build summary and to log in yellow text
# https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/powershell?view=azure-devops
Function WriteWarning($message)
{
    Write-Host -ForegroundColor Yellow "##vso[task.LogIssue type=warning;] $message"
}

# Writes an error to build summary and to log in red text and exits build with error code 1.
# https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/powershell?view=azure-devops
Function WriteError($message)
{
    Write-Host -ForegroundColor Red "##vso[task.LogIssue type=error;] $message"
}

Function CreateNewVersion($buildNumber, $defaultVersion)
{
    if (!$buildNumber) 
    { 
        return $defaultVersion 
    }

    # Extract version from the buildNumber
    $versionData = [regex]::matches($buildNumber, "\d+\.\d+\.\d+\.\d+")
    if ($versionData.Count -gt 0) 
    {
        return $versionData[0]
    }

    throw "Could not find version number data in '$buildNumber'."
}

Function RemoveItemsWithRetries($pathPattern)
{
    $maxRetries = 6
    $tryCount = 0
    $sleepTime = 1
    while ($true)
    {
        try
        {
            $tryCount++
            Remove-Item -Recurse -Force -Path "$pathPattern"
            if (!$?)
            {
                throw $_
            }
            break
        }
        catch
        {
            if ($tryCount -gt $maxRetries)
            {
                throw
            }
            WriteWarning "Remove items from '$pathPattern' FAILED, retry in $sleepTime seconds."
            [System.Threading.Thread]::Sleep([System.TimeSpan]::FromSeconds($sleepTime))
            $sleepTime *= 2
        }
    }
}

# Calls and logs powershell function.
Function Call($function)
{
    # write command text to console and log
    $expandedCmdText = $ExecutionContext.InvokeCommand.ExpandString($function)
    WriteCommand "$expandedCmdText"

    # execute command
    & $function
}

# Executes commandline process and checks exitcode.
# Taken from psake https://github.com/psake/psake
Function Exec($cmd)
{
    # write command text to console and log
    $expandedCmdText = $ExecutionContext.InvokeCommand.ExpandString($cmd)
    WriteCommand "$expandedCmdText"

    # execute command
    & $cmd

    # if exit code is not 0 then throw detailed error message
    if ($lastexitcode -ne 0) {
        $errorMessage = 
        "    Exec of the following command FAILED: 
                $expandedCmdText
        "
        throw ($errorMessage)
    }
}
