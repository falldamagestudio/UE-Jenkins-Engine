param (
	[Parameter(Mandatory)] [string] $CloudStorageBucket,
	[Parameter(Mandatory)] [string] $BuildId
)

. ${PSScriptRoot}\..\PowerShell\Upsync-EngineBuild.ps1

$UELocation = "${PSScriptRoot}\..\..\..\UE"
$EngineBuildLocation = "${UELocation}\LocalBuilds\Engine\Windows"
$EngineBuildId = "engine-${BuildId}-win64"

Upsync-EngineBuild -EngineBuildLocation $EngineBuildLocation -CloudStorageBucket $CloudStorageBucket -EngineBuildId $EngineBuildId
