. ${PSScriptRoot}\Ensure-TestToolVersions.ps1

BeforeAll {

	. ${PSScriptRoot}\Upsync-EngineBuild.ps1

}

Describe 'Upsync-EngineBuild' {

	It "Reports error if the engine build location does not exist" {

		Mock Resolve-Path { throw "Path cannot be resolved" }

		Mock Start-Process { }

		{ Upsync-EngineBuild -EngineBuildLocation "UE" -CloudStorageBucket "storage-bucket" -EngineBuildId "build-id" } |
			Should -Throw "Path cannot be resolved"

		Assert-MockCalled -Times 0 Start-Process
	}

	It "Reports success if Start-Process returns zero" {

		Mock Resolve-Path { "C:\ExamplePath" }

		Mock Start-Process { @{ ExitCode = 0 } }

		{ Upsync-EngineBuild -EngineBuildLocation "UE" -CloudStorageBucket "storage-bucket" -EngineBuildId "build-id" } |
			Should -Not -Throw

		Assert-MockCalled -Times 1 Start-Process
	}

	It "Reports error if Start-Process returns another exit code" {

		Mock Resolve-Path { "C:\ExamplePath" }

		Mock Start-Process { @{ ExitCode = 1234 } }

		{ Upsync-EngineBuild -EngineBuildLocation "UE" -CloudStorageBucket "storage-bucket" -EngineBuildId "build-id" } |
			Should -Throw

        Assert-MockCalled -Times 1 Start-Process
    }

}