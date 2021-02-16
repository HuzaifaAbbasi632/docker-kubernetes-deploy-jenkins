pipeline {
    agent any
    environment {
        DOCKER_TAG = getDockerTag()
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh "docker build . -t huzaifaabbasi1122/react:${DOCKER_TAG} "
            }
        }
        stage('Docker Hub Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub_id', variable: 'dockerhubPwd')]) {
                    sh "docker login -u huzaifaabbasi1122 -p ${dockerhubPwd}"
                    sh "docker push huzaifaabbasi1122/react:${DOCKER_TAG}"
                }
            }
        }
    }
}
def getDockerTag() {
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
