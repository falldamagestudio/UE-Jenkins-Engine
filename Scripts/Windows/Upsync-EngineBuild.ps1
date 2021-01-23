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
    $VersionIndexURI = "gs://${CloudStorageBucket}/engine-win64/index/${EngineBuildId}.lvi"
    $StorageURI = "gs://${CloudStorageBucket}/engine-win64/storage"

    $Arguments = @(
        "upsync"
        "--source-path"
        $EngineBuildAbsoluteLocation
        "--target-path"
        $VersionIndexURI
        "--storage-uri"
        $StorageURI
    )

    $Process = Start-Process -FilePath $LongtailLocation -ArgumentList $Arguments -NoNewWindow -Wait -PassThru

    if ($Process.ExitCode -ne 0) {
        throw [LongtailException]::new($Process.ExitCode)
    }
}