pipeline {
    agent {
        label 'DockerBuildAgent'
    }
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        
        stage('workscpace cleanup') {
            steps {
                cleanWs()
            }
        }
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Ajay-48/PrimeApp.git'
            }
        }
        stage('Sonar Scanner') {
            steps {
                withSonarQubeEnv('sonar') 
                {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=PrimeApp -Dsonar.projectKey=PrimeApp \
                            '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                waitForQualityGate abortPipeline: false, 
                credentialsId: 'sonar'
            }
        }
        stage('Trivy File Scan') {
            steps {
                sh "trivy fs --format table -o fs.html ."
            }
        }
        stage('Build') {
            steps {
                sh "docker build -t ajay048/primeapp:${BUILD_NUMBER} ."
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --format table -o image.html ajay048/primeapp:${BUILD_NUMBER}"
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script{
                withDockerRegistry(credentialsId: 'docker', toolName: 'Docker') {
                    sh "docker push ajay048/primeapp:${BUILD_NUMBER}"
                }
                }
            }
        }
        stage('Remove Docker Images') {
            steps {
                script{
                    sh "docker image prune -a -f"
                }
            }
        }
        stage('update tag'){
            steps{
                sh "chmod +x update-manifest.sh"
                sh "./update-manifest.sh"
                echo "updated local repo"
            }
        }
        stage('pushing to git'){
            steps{
                script{
                    withCredentials([gitUsernamePassword(credentialsId: 'git', gitToolName: 'Default')]) {
                        sh '''
                        git config user.email "ajaykumarbolakonda048@gmail.com"
                        git config user.name "Ajay-48"
                        git add ./k8s_files/deployment.yaml
                        git commit -m "updated manifestfile"
                        git push origin main
                        '''
                    }
                }
            }
        }
        stage('Deploy to kubernetes') {
            steps {
                script {
    sh '''
        ssh -o StrictHostKeyChecking=no root@44.204.20.48 'bash -s' <<EOF
            pwd 
            hostname
            cd /tmp
            git clone https://github.com/Ajay-48/PrimeApp.git
            kubectl apply -f PrimeApp/k8s_files/deployment.yaml 
            kubectl apply -f PrimeApp/k8s_files/service.yaml
            rm -rf *
        
    '''
}


            }
        }
    }
}
