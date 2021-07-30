pipeline {
  agent {
    kubernetes { 

 
      // The given PersistentVolumeClaim will be mounted where the workspace folder typically is located.
      // The PVC must have been created beforehand, outside of Jenkins.
      // The PVC ensures that a persistent disk of a given size has been created.
      // It enables incremental builds.
      //
      // The current automation does not offer any means for creating these PVCs. If you want to
      // take advantage of persistent workspaes for Kubernetes builds, you must create the PVCs yourself.
      //
      // workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'build-engine-linux-git-kubernetes', readOnly: false)

      yaml """
metadata:
  labels:
    app: jenkins-agent

spec:

  # Schedule this pod onto a node in the jenkins agent Linux node pool
  nodeSelector:
    jenkins-agent-linux-node-pool: "true"

  # Ensure this pod is not scheduled onto a node that already has another jenkins agent pod on it
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - jenkins-agent
        topologyKey: "kubernetes.io/hostname"

  # Allow this pod to be scheduled onto nodes in the jenkins agent Linux node pool
  tolerations:
  - key: jenkins-agent-linux-node-pool
    operator: Equal
    value: "true"
    effect: NoSchedule

  # Use root uid for volumes
  securityContext:
    fsGroup: 1000

  containers:
  - name: jnlp
  - name: ue-jenkins-buildtools-linux
    image: ${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE}
    # Add dummy command to prevent container from immediately exiting upon launch
    command:
    - cat
    tty: true
"""
    }
  }

  stages {

    stage('Patch Git repo contents') {
      steps {
        container('ue-jenkins-buildtools-linux') {
          sh """
              ./Scripts/Linux/BuildSteps/ApplyPatches.sh
            """
        }
      }
    }


    stage('Fetch Git repo dependencies') {
      steps {
        container('ue-jenkins-buildtools-linux') {
          sh """
              ./Scripts/Linux/BuildSteps/FetchRepoDependencies.sh
            """
        }
      }
    }
    
    stage('Build Engine (Linux)') {
      steps {
        container('ue-jenkins-buildtools-linux') {
          sh """
              ./Scripts/Linux/BuildEngine.sh
            """
        }
      }
    }

    stage('Upload Engine') {
      steps {
        container('ue-jenkins-buildtools-linux') {
          sh """
              ./Scripts/Linux/BuildSteps/UploadUE.sh ${LONGTAIL_STORE_BUCKET_NAME} ${GIT_COMMIT}
            """
        }
      }
    }

  }
}
