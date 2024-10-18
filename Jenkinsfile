pipeline {
    agent any

    environment {
        IMAGE = "soklay515/stacknote-ui"
        DOCKER_IMAGE = "${IMAGE}:${BUILD_NUMBER}"
        DOCKER_HUB_CREDENTIAL = "dockerhub-token"
        MANIFEST_REPO = "stacknote-ui"
        GIT_MANIFEST_REPO = "https://github.com/12-Generation-Advanced-Course-Project/Stacknote-Manifest.git"
        GIT_CREDENTIALS_ID = "Stacknote"
        MANIFEST_FILE_PATH = "manifest/deployment.yaml"
    }

    stages {

        stage("Cleanup Workspace") {
            steps {
                echo "Cleaning workspace..."
                deleteDir() // Clean up workspace before proceeding
            }
        }

        stage("Install Dependencies") {
            steps {
                echo "Installing npm dependencies..."
                sh 'npm install'
            }
        }

        stage("Build Docker Image") {
            steps {
                echo "Building Docker Image..."
                sh "docker build -t ${DOCKER_IMAGE} ."
                sh "docker images | grep -i ${IMAGE}"
            }
        }

        stage("Push Image to Docker Hub") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CREDENTIAL, passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                    echo "Pushing the image to Docker Hub..."
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage("Clone Manifest File") {
            steps {
                script {
                    echo "Cloning manifest repo..."
                    sh '''
                    if [ -d "${MANIFEST_REPO}" ]; then
                        echo "Removing existing manifest repo directory..."
                        rm -rf ${MANIFEST_REPO}
                    fi
                    git clone -b main ${GIT_MANIFEST_REPO} ${MANIFEST_REPO}
                    '''
                }
            }
        }

        stage("Update Manifest File") {
            steps {
                script {
                    echo "Updating the image in the manifest file..."
                    sh """
                    sed -i 's|image: soklay515/stacknote-ui.*|image: ${DOCKER_IMAGE}|' ${MANIFEST_REPO}/${MANIFEST_FILE_PATH}
                    """
                }
            }
        }

        stage("Push Changes to Manifest Repo") {
            steps {
                script {
                    dir("${MANIFEST_REPO}") {
                        withCredentials([usernamePassword(credentialsId: GIT_CREDENTIALS_ID, passwordVariable: 'GIT_PASS', usernameVariable: 'GIT_USER')]) {
                            sh """
                            git config --global user.name "soklaymeng"
                            git config --global user.email "mengsoklay2222@gmail.com"
                            git add ${MANIFEST_FILE_PATH}
                            git commit -m "Updated image to ${DOCKER_IMAGE}"
                            git push https://${GIT_USER}:${GIT_PASS}@github.com/12-Generation-Advanced-Course-Project/Stacknote-Manifest.git
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Check the logs for errors."
        }
    }
}
