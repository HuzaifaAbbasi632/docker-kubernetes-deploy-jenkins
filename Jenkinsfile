pipeline {
    agent any
    stages {
        stage('Docker Version Validation'){
           steps{ 
              script { 
               try {
                    timeout(time:10, unit:'SECONDS') {
                        days = input message: 'Please Enter Number', ok: 'Fetch Statistics', parameters: [string(defaultValue: '', description: 'Version', name: 'Version', trim: true)] 
                    }
                }
                catch (err){
                   error("No custom value has been entered for number of days.")
                }
            }
        }
    }
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
                       sshpass -p ${machine_pass} scp -o StrictHostKeyChecking=no node-app-pod.yml root@192.168.136.21:~
                       sshpass -p ${machine_pass} scp -o StrictHostKeyChecking=no services.yml root@192.168.136.21:~
                       sshpass -p ${machine_pass} ssh root@192.168.136.21 kubectl apply -f .
                    '''
                }
            }
        }
    }
}
