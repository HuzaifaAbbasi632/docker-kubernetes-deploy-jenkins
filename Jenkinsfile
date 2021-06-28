pipeline{
    agent any
    environment {
        //DOCKER_TAG = getDockerTag()
        EMAIL_INFORM = 'zaifyabbasi51@gmail.com;muhammad.huzaifa@aksa-sds.com'
    }
    stages {
        stage('Tag Validation'){
           steps{
              script {
               try {
                    timeout(time:60, unit:'SECONDS') {
                        DOCKER_TAG = input message: 'Please Enter Version', ok: 'OK', parameters: [string(defaultValue: '', description: 'Version', name: 'Version')] 
                    }
                }
                catch (err){
                   error("No Value Entered ${err}")
                }
            }
        }
    }
        stage('Build Docker Image') {
            steps {
                sh "docker build . -t huzaifaabbasi1122/jenkins-react:${DOCKER_TAG} "
            }
        }
        stage('Docker Hub Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub_id', variable: 'dockerhubPwd')]) {
                    sh "docker login -u huzaifaabbasi1122 -p ${dockerhubPwd}"
                    sh "docker push huzaifaabbasi1122/jenkins-react:${DOCKER_TAG}"
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                sh 'chmod +x changeTag.sh'
                sh "./changeTag.sh ${DOCKER_TAG}"
                withCredentials([string(credentialsId: 'machine_pass', variable: 'machine_pass')]) {
                    sh '''
                       sshpass -p ${machine_pass} scp -o StrictHostKeyChecking=no node-app-pod.yml root@192.168.136.22:~
                       sshpass -p ${machine_pass} scp -o StrictHostKeyChecking=no services.yml root@192.168.136.22:~
                       sshpass -p ${machine_pass} ssh root@192.168.136.22 kubectl apply -f node-app-pod.yml
                       sshpass -p ${machine_pass} ssh root@192.168.136.22 kubectl apply -f services.yml
                    '''
                }
            }
        }
    }
    post {
        always {
            emailext attachLog: true,
            subject: "Build Notification: ${JOB_NAME}-Build# ${BUILD_NUMBER} ${currentBuild.result}",
            body: "Status ${currentBuild.currentResult}:\nJOB ${env.JOB_NAME}\nBUILD# ${env.BUILD_NUMBER}\nMore info at: ${env.BUILD_URL}",
            to: "${EMAIL_INFORM}"
        }
    }
}
/*def getDockerTag() {
    def tag = input message: 'Please Enter Value', parameters: [string(defaultValue: '', description: '', name: 'Version Number')]
    return tag
}*/
