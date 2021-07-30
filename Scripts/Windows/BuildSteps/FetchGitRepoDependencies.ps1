class GitDependenciesException : Exception {
	$ExitCode

	GitDependenciesException([int] $exitCode) : base("GitDependencies.exe exited with code ${exitCode}") { $this.ExitCode = $exitCode }
}

cd "${PSScriptRoot}\..\..\..\UE"
& .\Engine\Binaries\DotNET\GitDependencies.exe
if (${LASTEXITCODE} -ne 0) {
    throw [GitDependenciesException]::new($Process.ExitCode)
}
