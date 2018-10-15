az group deployment create -n mf01rgdep -g mf01rg --template-file azuredeploy.json --debug

az group deployment show -g mf01rg -n mf01rgdep

"028da53d-e51e-4f77-b0d1-cf5694a9db56"

az group deployment show -g mf01rg -n mf01rgdep --query properties.correlationId

az group deployment operation list -g mf01rg -n mf01rgdep

az monitor activity-log list --correlation-id "028da53d-e51e-4f77-b0d1-cf5694a9db56"