pipeline {
  agent {
    kubernetes { 

      // The given PersistentVolumeClaim will be mounted where the workspace folder typically is located.
	    // The PVC must have been created beforehand, outside of Jenkins.
	    // The PVC ensures that a persistent disk of a given size has been created.
	    // It enables incremental builds.
      workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'build-engine-linux', readOnly: false)

      yaml """
metadata:
  labels:
    app: jenkins-agent

spec:

  # Schedule this pod onto a node in the jenkins agent node pool
  nodeSelector:
    jenkins-agent-node-pool: "true"

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

  # Allow this pod to be scheduled onto nodes in the jenkins agent node pool
  tolerations:
  - key: jenkins-agent-node-pool
    operator: Equal
    value: "true"
    effect: NoSchedule

  # Use root uid for volumes
  securityContext:
    fsGroup: 1000

  containers:
  - name: jnlp
  - name: ue-jenkins-buildtools
    image: ${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE}:${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE_TAG}
"""
    }
  }

  stages {

    stage('Fetch Git repo dependencies') {
      steps {
        sh "ls -al"
        sh "cd UE/Engine/Build/BatchFiles/Linux && ./Setup.sh"
      }
    }
    
//    stage('Build Engine (Linux)') {
//    
//      steps {
//
//        sh "./Scripts/Linux/BuildEngine.sh"
//
//      }
//    }

  }
}
