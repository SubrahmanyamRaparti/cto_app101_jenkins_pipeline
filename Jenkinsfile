pipeline {
    agent none
//    agent any
//    tools {
//        maven 'Apache-maven#3.8.6'
//    }
    environment {
        DOCKER_BUILD_TAG = "1.0.${env.BUILD_NUMBER}"
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Git') {
            agent any
            steps {
                git branch: 'main', url: 'https://github.com/SubrahmanyamRaparti/cto_app101_jenkins_pipeline.git'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'maven:3.8.6-amazoncorretto-11'
                }
            }
            steps {
                sh '''
                    mvn -DskipTests clean package
                    java -version
                '''
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'maven:3.8.6-amazoncorretto-11'
                }
            }
            steps {
                sh '''
                    mvn test
                '''
            }
        }
        stage('Sonar code qulity') {
            agent {
                docker {
                    image 'maven:3.8.6-amazoncorretto-11'
                }
            }
            steps {
                withSonarQubeEnv(installationName: 'sonarqube-community') {
                sh '''
                    mvn sonar:sonar
                '''
                }
            }
        }
        stage('Quality gate') {
            agent {
                docker {
                    image 'maven:3.8.6-amazoncorretto-11'
                }
            }
            steps {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build docker image') {
            agent any
            steps {
                sh '''
                    docker image build --compress -t $DOCKERHUB_CREDENTIALS_USR/simple-java-maven-app:$DOCKER_BUILD_TAG .
                    docker image tag $DOCKERHUB_CREDENTIALS_USR/simple-java-maven-app:$DOCKER_BUILD_TAG $DOCKERHUB_CREDENTIALS_USR/simple-java-maven-app:latest
                '''
            }
        }
        stage('Push docker image') {
            agent any
            steps {
//              environment variable can also be used to access username as a separate entity by appending
//              USR & PSW to the environment variable i.e. DOCKERHUB_CREDENTIALS_USR & DOCKERHUB_CREDENTIALS_PSW.
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push $DOCKERHUB_CREDENTIALS_USR/simple-java-maven-app:$DOCKER_BUILD_TAG
                    docker push $DOCKERHUB_CREDENTIALS_USR/simple-java-maven-app:latest
                    docker logout
                '''
            }
        }
        stage('Image cleanup') {
            agent any
            steps {
                sh '''
                    docker image rm $DOCKERHUB_CREDENTIALS_USR/simple-java-maven-app:$DOCKER_BUILD_TAG
                '''
            }
        }
    }
}