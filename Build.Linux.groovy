
pipeline {
  agent {
    kubernetes { yaml """
metadata:
  labels:
    app: jenkins-agent
spec:

  # Schedule this pod onto a node in the jenkins agent node pool
  nodeSelector:
    jenkins-agent-node-pool: "true"

  # Ensure this pod is not scheduled onto a node that already has another jenkins agent pod
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

  containers:
  - name: jnlp
"""
    }
  }
  stages {
    stage('Fetch Git repo dependencies') {
      steps {

        sh "cd UE/Engine/Build/BatchFiles/Linux && ./Setup.sh"

      }
    }
    
    stage('Build Engine (Linux)') {
    
      steps {

        sh "./Scripts/Linux/BuildEngine.sh"

      }
    }
  }
}
