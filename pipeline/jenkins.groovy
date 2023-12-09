pipeline {
    agent any
    environment {
        REPO = 'https://github.com/pavelbabakin/buddybot'
        BRANCH = 'main'
        REGISTRY = 'ghcr.io/pavelbabakin'
        APP = 'pavelbabakin'
        GHCR = 'https://ghcr.io'

    }
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick architectory')

    }
    stages {
        stage("clone") {
            steps {
                echo 'clone'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }

        stage("tests") {
            steps {
                echo 'tests'
                sh 'make test'
            }
        }

        stage("build") {
            steps {
                echo 'build'
                sh 'make build'
            }
        }

        stage("image") {
            steps {
                echo 'IMAGE STARTED'
                sh 'make image REGISTRY=${REGISTRY} APP=${APP}'
            }
        }
        stage("login") {
            steps {
                echo 'login'
                withCredentials([usernamePassword(credentialsId: 'github-token', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker login -u $USERNAME -p $PASSWORD ${GHCR}'
                }

            }
        }

        stage("push") {
            steps {
                echo 'push'
                sh 'make push'
            }
        }
    }
}