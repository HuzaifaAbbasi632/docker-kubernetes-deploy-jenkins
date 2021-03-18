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
        stage('Deploy to K8s') {
            steps {
                sh 'chmod +x changeTag.sh'
                sh "./changeTag.sh ${DOCKER_TAG}"
                withCredentials([string(credentialsId: 'machine_pass', variable: 'machine_pass')]) {
                    sh '''
                        sshpass -p ${machine_pass} ssh -t -o StrictHostKeyChecking=no root@192.168.136.21 << Here
                          scp -o StrictHostKeyChecking=no node-app-pod.yml root@192.168.136.21:~
                          scp -o StrictHostKeyChecking=no services.yml root@192.168.136.21:~
                          kubectl apply -f .
                    '''
                }
            }
        }
    }
}
def getDockerTag() {
    def tag  = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
