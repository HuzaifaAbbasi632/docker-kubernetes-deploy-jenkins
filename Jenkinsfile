pipeline{
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage("Build Docker Image"){
            steps{
                sh "docker build . -t huzaifaabbasi1122/react:${DOCKER_TAG} "
            }
        }
    }
}
def getDockerTag(){
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
