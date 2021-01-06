pipeline {
  agent {
    kubernetes { 

      // The given PersistentVolumeClaim will be mounted where the workspace folder typically is located.
	    // The PVC must have been created beforehand, outside of Jenkins.
	    // The PVC ensures that a persistent disk of a given size has been created.
	    // It enables incremental builds.
      workspaceVolume persistentVolumeClaimWorkspaceVolume(claimName: 'build-engine-windows', readOnly: false)

      yaml """
metadata:
  labels:
    app: jenkins-agent

spec:

  # Schedule this pod onto a node in the jenkins agent Windows node pool
  nodeSelector:
    jenkins-agent-windows-node-pool: "true"

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

  # Allow this pod to be scheduled onto nodes in the jenkins agent Windows node pool
  tolerations:
  - key: jenkins-agent-windows-node-pool
    operator: Equal
    value: "true"
    effect: NoSchedule
  # Allow this pod to be scheduled onto nodes with Windows as host OS
  - key: node.kubernetes.io/os
    operator: Equal
    value: "windows"
    effect: NoSchedule

  # Use root uid for volumes
  securityContext:
    fsGroup: 1000

  containers:
  - name: jnlp
    image: jenkins/inbound-agent:windowsservercore-ltsc2019
"""
    }
  }

  stages {

    stage('Fetch Git repo dependencies') {
      steps {
          bat "echo hello"
/*
        container('ue-jenkins-buildtools-windows') {
          sh "cd UE && ./Setup.bat"
        }
*/
      }
    }
    
    // stage('Build Engine (Windows)') {
    //   steps {
    //     container('ue-jenkins-buildtools-windows') {
    //       sh "./Scripts/Windows/BuildEngine.ps1"
    //     }
    //   }
    // }
  }
}
