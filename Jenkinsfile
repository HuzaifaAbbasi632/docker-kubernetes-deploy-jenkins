pipeline{
    agent any
    environment{
        DOCKER_TAG = getDockerTag()
    }
    stages{
        stage("Build Docker Image"){
            steps{
                sh "docker build -t huzaifaabbasi1122/node-web-app:${DOCKER_TAG} . "
            }
        }
    }
}
