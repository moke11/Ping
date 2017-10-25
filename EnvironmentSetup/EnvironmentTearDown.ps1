function _deleteStack()
{
    $stack = (Get-CFNStack -StackName "Ping" | Where-Object {$_.StackName -eq "Ping"})
    if($stack -ne $null)
    {
        Write-Host "Deleting CloudFormation existing stack"
        Remove-CFNStack $stack.StackName -Force
    }
}

function _deleteCodeDeployPrimitives()
{
    $applications = Get-CDApplicationList | Where-Object {$_.StartsWith("Ping")}
    foreach($application in $applications)
    {
        $deploymentGroups = Get-CDDeploymentGroupList -ApplicationName $application
        foreach($deploymentGroup in $deploymentGroups.DeploymentGroups)
        {
            Write-Host ("Deleting Deployment Group " + $deploymentGroup)
            Remove-CDDeploymentGroup -ApplicationName $application -DeploymentGroupName $deploymentGroup -Force
        }

        Write-Host ("Deleting CodeDeploy Application " + $application)
        Remove-CDApplication -ApplicationName  $application -Force
    }
}

_deleteCodeDeployPrimitives
_deleteStack