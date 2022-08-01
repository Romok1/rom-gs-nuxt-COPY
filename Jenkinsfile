pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        durabilityHint('PERFORMANCE_OPTIMIZED')
        disableConcurrentBuilds()
    }
    triggers {
        pollSCM 'H/5 * * * *'
    }
    environment {
        SLACK_TEAM_DOMAIN="wcmc"
        SLACK_TOKEN=credentials('slack-token-gef')
        SLACK_CHANNEL="#jenkins-cicd-gefspatial"
        COMPOSE_PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}".replaceAll("/", "-").replaceAll(" ", "").toLowerCase()
        COMPOSE_FILE = "docker-compose.yml:docker-compose-ci.yml"
        RAILS_ENV = "test"
	GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
    }
    stages {
        stage ('Start') {
               steps {
                slackSend(
                            teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                            token: "${env.SLACK_TOKEN}",
                            channel: "${env.SLACK_CHANNEL}",
                            color: "#FFFF00",
                            message: "STARTED: ['${env.BRANCH_NAME} ${env.GIT_COMMIT_MSG}'] Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
                    )
	           }
        }
        stage("Build") {
             when {
                  branch 'gf-docker-ci'
                }
            steps { 
	       script {
	         CI_ERROR = "Failed: Build stage"
                 BuildProject() }
	    }
        }
        stage("Test DB") {
              when {
                  branch 'gf-docker-ci'
                }
             steps { 
		 script {
		 CI_ERROR = "Failed: Test DB stage"
                 Preparedatabase() }
	     }
        }
        stage("Rspec test") {
              when {
                  branch 'gf-docker-ci'
                }
             steps { 
		script {
		 CI_ERROR = "Failed: Rspec test stage"
                 Raketest() }
	     }
        }
        stage('Clean') {
              when {
                  branch 'gf-docker-ci'
                }
            steps{
              sh "docker-compose down --remove-orphans --rmi all"
              
            }
        }
        stage('Scan for vulnerabilities') {
            steps {
             script {
	      CI_ERROR = "Failed: Snyk scan failed, check the snyk site for details "${SNYK_API}""
              echo 'Scanning...'
              snykSecurity(
                snykInstallation: 'snyk@latest',
                snykTokenId: 'snyktoken',
              )
		}
            }
        }
        stage("Deploy") {
             when {
                  branch 'gf-docker-ci'
                }
             steps { 
               script {
		 CI_ERROR = "Failed: Deploy stage"
                 sh '''#!/bin/bash -l
                 ls
                 printenv
                git branch
                echo "bundle exec cap staging deploy" 
                 '''}
              }
             post {
                  success{
                      slackSend color : "good", message: "Deploy to staging environment successful", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                  }
                  failure{
                      slackSend color : "danger", message: "Failed to deploy to staging environment, check the logs and confirm error", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                  }
              }
        }
    }
    post {
                always {
			script{
				imagecleanup()
				cleanWs()
			}
		}
	        success {
                    slackSend(
                            teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                            token: "${env.SLACK_TOKEN}",
                            channel: "${env.SLACK_CHANNEL}",
                            color: "good",
                            message: "Job:  ${env.JOB_NAME}\n Status: *SUCCESS* \n"
                    )
                }

                failure {
                    slackSend(
                            teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                            token: "${env.SLACK_TOKEN}",
                            channel: "${env.SLACK_CHANNEL}",
                            color: "danger",
                            message: "Job:  ${env.JOB_NAME}\n Status: *FAILURE*\n Error description: ${CI_ERROR} \n"
                    )
                }
    }
}


def BuildProject() {
    sh 'echo "Building Project.............."'
    sh 'docker-compose --project-name=${JOB_NAME} build'
    sh "docker-compose run web bundle install"
   sh "docker-compose up -d"
  sh "docker-compose logs"
}

def Preparedatabase() {
    COMMAND="bin/rails db:create db:migrate db:seed RAILS_ENV=test"
	sh "docker-compose logs"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def Raketest() {
    COMMAND="bundle exec rake test"
	sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def Rspectests() {
    COMMAND="bundle exec rspec spec"
    sh 'docker-compose --project-name=${JOB_NAME} run web $COMMAND'
}

def imagecleanup() {
   sh "docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null"
   sh "docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null"
   sh "docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
   sh "docker rm -v `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
   sh "docker rmi `docker images --filter 'dangling=true' -q --no-trunc` &> /dev/null || true &> /dev/null"
}
