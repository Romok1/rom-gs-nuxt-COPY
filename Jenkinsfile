pipeline {
    agent any
    options {
        // Number of build logs to keep
        // @see https://www.jenkins.io/doc/book/pipeline/syntax/
        buildDiscarder(logRotator(numToKeepStr: '5'))
        //Pipeline speed, much faster, Greatly reduces disk I/O - requires clean shutdown to save running pipelines
        durabilityHint('PERFORMANCE_OPTIMIZED')
        // Disallow concurrent executions of the Pipeline. Can be useful for preventing simultaneous accesses to shared resources
        disableConcurrentBuilds()
        overrideIndexTriggers(false)
    }
    triggers {
        // Accepts a cron-style string to define a regular interval at which Jenkins should check for new source changes 
	// If new changes exist, the Pipeline will be re-triggered
        pollSCM 'H/5 * * * *'
    }
    environment {
        SLACK_TEAM_DOMAIN = "wcmc"
        SLACK_TOKEN = credentials('slack-token-encore-inuse')
        SLACK_CHANNEL = "#jenkins-cicd-encore"
        COMPOSE_FILE = "docker-compose.yml"
	GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
	SNYK_URL = "https://app.snyk.io/org/informatics.wcmc/projects"
        jenkinsConsoleUrl = "$env.JOB_URL" + "$env.BUILD_NUMBER" + "/consoleText"
        DIR = "$JENKINS_HOME/workspace"
	rails_key = credentials('encore-rails_master_key')
    }
    stages {
        stage ('Start') {
            steps {
                slackSend(
                    teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                    token: "${env.SLACK_TOKEN}",
                    channel: "${env.SLACK_CHANNEL}",
                    color: "#FFFF00",
                    message: "STARTED: Branch -- ${env.BRANCH_NAME}\n Git Commit message: '${env.GIT_COMMIT_MSG}'\n Job: ${env.JOB_NAME} - [${env.BUILD_NUMBER}]' \n Build link: [(<${env.BUILD_URL} | View >)]"
                )
	          }
       	 }
	  stage("Build") {
            when {
                anyOf {
                    branch 'test-encore-temp'
                    branch 'develop'
                }
            }
            steps { 
	            script {
	            CI_ERROR = "Build Failed at stage: docker-compose build"
                    buildProject()
	        }
	      }
        }
        stage("Test DB") {
            when {
                anyOf {
                    branch 'test-encore-temp'
                    branch 'develop'
                }
            }
            steps { 
		   script {
		        CI_ERROR = "Build Failed at stage: Test DB - Running db migrate"
                    prepareDatabase() 
		          }
	          }
        }
        stage("Prepare") {
            when {
                anyOf {
                    branch 'test-encore-temp'
                    branch 'develop'
                }
            }
            steps { 
		  script {
		   CI_ERROR = "Build Failed at stage: Prepare - Run yarn install"
                    prepare() 
	            	}
	           }
        }
        stage('Scan for vulnerabilities') {
            when {
                anyOf {
                    branch 'test-encore-temp'
                    branch 'develop'
                }
            }
               steps {
		        script {
	                    CI_ERROR = "Build Failed at stage:: Snyk vulnerability scan failed for this project, check the snyk site for details, ${env.SNYK_URL}"
		                  }
                        echo 'Scanning...'
                        snykSecurity(
                            snykInstallation: 'snyk@latest', snykTokenId: 'wcmc-snyk',
		                 severity: 'critical', failOnIssues: false,
		                  additionalArguments: '--all-projects --detection-depth=4', 
			      )
	      	      }
	        post {
                success{
                    slackSend color: "good", message: "Snyk scan successful, visit ${env.SNYK_URL} for detailed report", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
                failure{
                    slackSend color: "danger", message: "Snyk scan failed, visit ${env.SNYK_URL} to get detailed report", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
            }
    	  }
        stage("Deploy to Staging") { 
            when {
                branch 'test-encore-temp'
            }
            steps { 
               	script {
		            CI_ERROR = "Build Failed at stage: Prepare deploy stage"
		            sh "mkdir $DIR/deploydir"
		            dir("$DIR/deploydir") {
		              checkout scm
                sh '''#!/bin/bash -l
                  ls
                  git branch
		              rvm use $(cat .ruby-version) --install
		              bundle install
		              echo "bundle exec cap staging deploy"
                  '''
                    } // git checkout develop
                }
            }
            post {
		always {
	             script {
			 deleteDeployDir()
		     }
		}
                success{
                    slackSend color: "good", message: "Deploy to Staging server successful", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
                failure{
                    slackSend color: "danger", message: "Deploy to Staging server failed", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
            }
        }
    }
    post {
        always {
	     script {
               	BUILD_STATUS = currentBuild.currentResult
		              if (currentBuild.currentResult == 'SUCCESS') { 
		                CI_ERROR = "NA" 
		            }
              	//if (env.BRANCH_NAME == 'test-encore-temp') {
                //deleteDeployDir()
              	//}
		 dockerImageCleanup()
                }
        }
	 success {
            slackSend(
                teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                token: "${env.SLACK_TOKEN}",
                channel: "${env.SLACK_CHANNEL}",
                color: "good",
                message: "Job:  ${env.JOB_NAME}\n Build: ${env.BUILD_NUMBER} -- Completed for [${env.JOB_NAME}]\n Status: *SUCCESS* \n Result: Pipeline has finished build successfully for - - ${currentBuild.fullDisplayName} :white_check_mark:\n Run Duration: [${currentBuild.durationString}]\n View Build: [(<${JOB_DISPLAY_URL} | View >)]\n Logs path and Details: [(<${jenkinsConsoleUrl} | here >)] \n"
            )
        }
        failure {
            slackSend(
                teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                token: "${env.SLACK_TOKEN}",
                channel: "${env.SLACK_CHANNEL}",
                color: "danger",
                message: "Job:  ${env.JOB_NAME}\n Status: *FAILURE* \n Result: Pipeline has failed for - - ${currentBuild.fullDisplayName}❗\n Error description: ${CI_ERROR}\n Run Duration: [${currentBuild.durationString}]\n View Build: [(<${JOB_DISPLAY_URL} | View >)]\n Logs path and Details: [(<${jenkinsConsoleUrl} | here >)] \n"
            )
        }
        cleanup {
	            cleanWs()
	            deleteWorkspace()
		}
    	}

}
def buildProject() {
    sh 'echo "Building Project.............."'
	sh "ls"
	sh "echo ${rails_key} > config/master.key"
    sh "cp .env-example .env"
    sh "cp config/database-jenkinsci.yml config/database.yml"
    sh "cp config/sidekiq-jenkins.yml config/sidekiq.yml"
    sh 'docker-compose -f ${COMPOSE_FILE} --project-name=${JOB_NAME} build --pull'
}

def prepareDatabase() {
    COMMAND = "bundle exec rake db:drop db:create db:migrate db:seed"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def prepare() {
    sh "docker-compose --project-name=${JOB_NAME} run web yarn install"
    // sh "docker-compose --project-name=${JOB_NAME} run web yarn lint"
}

def runRspecTests() {
    COMMAND = "bundle exec rspec spec"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def dockerImageCleanup() {
    sh "docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null"
    sh "docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null"
    sh "docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
    sh "docker rm -v `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
    sh "docker rmi `docker images --filter 'dangling=true' -q --no-trunc` &> /dev/null || true &> /dev/null"
    sh "docker image prune -fa &> /dev/null || true &> /dev/null"
}

def deleteDeployDir() {
    sh "sudo rm -r $DIR/deploydir*"
}

def deleteWorkspace() {
    sh "sudo rm -rf ${workspace}_ws-*"
}
