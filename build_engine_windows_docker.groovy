pipeline {

  agent {
		docker {
      // The entire job will run on one specific node
			label 'test-vm'

      // All steps will be performed within this container
			image env.UE_JENKINS_BUILDTOOLS_WINDOWS_IMAGE

			// Ensure that cmd.exe is running as soon as the container has started.
			// Without this, if the container default to, for example, powershell, then Docker will report the following error:
			//  ERROR: The container started but didn't run the expected command. Please double check your ENTRYPOINT does execute the command passed as docker run argument, as required by official docker images (see https://github.com/docker-library/official-images#consistency for entrypoint consistency requirements).
			//  Alternatively you can force image entrypoint to be disabled by adding option `--entrypoint=''`.
			// The error is benign (the job will continue and will work succrssfully), but confusing.
			args '--entrypoint=cmd.exe'

      // Use a specific workspace folder, with a shorter folder name (Jenkins will default to C:\J\workspace\build_engine_windows_docker).
      // Building UE results in some long paths, and paths longer than 260 characters are problematic under Windows.
      // This shorter custom workspace name minimizes the risk that we'll run into too-long path names.
      customWorkspace "C:\\W\\Engine-Win64"
		}
	}

  stages {

    stage('Fetch Git repo dependencies') {
      steps {
        powershell "cd UE; & .\\Engine\\Binaries\\DotNET\\GitDependencies.exe; if (\${LASTEXITCODE} -ne 0) { throw \"GitDependencies.exe failed\" }"
      }
    }

    stage('Build Engine (Windows)') {
      steps {
        powershell ".\\Scripts\\Windows\\BuildEngine.ps1"
      }
    }

    stage('Upload Engine (Windows)') {
      steps {
        powershell ".\\Scripts\\Windows\\UploadUE.ps1 -CloudStorageBucket ${LONGTAIL_STORE_BUCKET_NAME} -BuildId ${GIT_COMMIT}"
      }
    }

  }
}
