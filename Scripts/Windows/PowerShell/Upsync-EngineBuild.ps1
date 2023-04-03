class LongtailException : Exception {
	$ExitCode

	LongtailException([int] $exitCode) : base("longtail-win32-x64.exe exited with code ${exitCode}") { $this.ExitCode = $exitCode }
}

function Upsync-EngineBuild {

    param (
        [Parameter(Mandatory)] [string] $EngineBuildLocation,
        [Parameter(Mandatory)] [string] $CloudStorageBucket,
        [Parameter(Mandatory)] [string] $EngineBuildId
    )

    $LongtailLocation = "${PSScriptRoot}\longtail-win32-x64.exe"
    $EngineBuildAbsoluteLocation = "\\?\$(Resolve-Path ${EngineBuildLocation} -ErrorAction Stop)"
    $VersionJsonURI = "gs://${CloudStorageBucket}/ue-win64/${EngineBuildId}.json"

    $Arguments = @(
        "put"
        "--source-path"
        $EngineBuildAbsoluteLocation
        "--target-path"
        $VersionJsonURI
    )

    $Process = Start-Process -FilePath $LongtailLocation -ArgumentList $Arguments -NoNewWindow -Wait -PassThru

    if ($Process.ExitCode -ne 0) {
        throw [LongtailException]::new($Process.ExitCode)
    }
}
