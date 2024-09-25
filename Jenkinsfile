pipeline {
    agent any
    environment {
        DOCKER_FILE = "Dockerfile"
        IMAGE = "mengsoklay/nextjs"
        TAG = "0.0.0"
        VERSION = "${env.Build_ID}"
    }
    stages {
        stage("Build Image") {
            steps {
                script {
                    echo "Build nextjs image."
                    sh "docker build -t ${IMAGE}:${TAG}.${VERSION} ."
                }
            }
        }
        stage("Push image to registry (Docker Hub)") {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' } 
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-token', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                        echo "Login Docker Hub"
                        sh "docker login -u $USERNAME -p $PASSWORD"
                        sh "docker push ${IMAGE}:${TAG}.${VERSION}"
                    }
                }
            }
        }
        stage("Update to image in the kubernetes manifest file to latest images") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'git-token', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                        git credentialsId: 'git-token', url: 'https://github.com/soklaymeng/deployment_next.git'
                        echo "Update Image Tag"
          
                        echo "Git Config for pushing latest update."
                        sh "git config --global user.email 'mengsoklay2222@gmail.com'"
                        sh "git config --global user.name 'soklaymeng'"
                        sh "git commit -am 'Update image tag'"
                        echo "User name: $USERNAME"
                        echo "User password: $PASSWORD"
                        sh "git push https://${USERNAME}:${PASSWORD}@github.com/soklaymeng/deployment_next"
                    }
                }
            }
        }
    }
}
