@Library('jenkinssharedlibrary') _
import JenkinsCredentials

pipeline {
   environment {
      dockerImage = ''
      imageName = 'service-registry'
      clusterName = ''
      project = ''
      credential= ''
    }
  agent {label 'master'}
  stages {
      stage("Environment Selection"){
        steps {
          script {
              if (env.BRANCH_NAME == "qa") {
                clusterName = 'cfs-qa-cluster'
                project = 'cfs-dds-qa'
                credential = JenkinsCredentials.getCerCredentialsByID('cfs-gcp-access-qa','CFS').id;
              }
              else if (env.BRANCH_NAME ==~ /^sprint.*/) {
                clusterName = 'cfs-dev-cluster'
                project = 'cfs-dds-dev-mattressfirm'
                credential = JenkinsCredentials.getCerCredentialsByID('cfs-gcp-access','CFS').id;
              }
              else {
                  echo 'Canceling Pipeline...'
                  error('Stopping Pipeline')
              }
          }
        }
      }
      stage('Building image') {
        steps{
          script {
            dockerImage = docker.build("$project/$imageName:$BUILD_NUMBER")
          }
        }
      }
      stage('Deploy Image To GCR') {
        steps{
          script {
            docker.withRegistry('https://gcr.io', "gcr:$credential" ) {
              dockerImage.push("$BUILD_NUMBER")
              dockerImage.push('latest')
            }
          }
        }
      }
      stage('Deploying to GKE'){
          steps{
              sh "sed -i 's/$imageName:latest/$imageName:$BUILD_NUMBER/g' deployment.yaml"
              sh "sed -i 's|Project|${project}|' deployment.yaml"
              step([$class: 'KubernetesEngineBuilder', 
              projectId: "$project", 
              clusterName: "$clusterName", 
              location: 'us-central1-a', 
              manifestPattern: 'deployment.yaml', 
              credentialsId: "$credential", 
              verifyDeployments: false])
          } 
      }
      stage('Cleaning Up Images'){
        steps{
          sh "docker image rmi gcr.io/$project/$imageName:latest"
          sh "docker image rmi gcr.io/$project/$imageName:$BUILD_NUMBER"
          sh "docker image rmi $project/$imageName:$BUILD_NUMBER"
        }
      }
  }
}