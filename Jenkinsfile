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
    }
    triggers {
        // Accepts a cron-style string to define a regular interval at which Jenkins should check for new source changes 
	// If new changes exist, the Pipeline will be re-triggered
        pollSCM 'H/5 * * * *'
    }
    environment {
        SLACK_TEAM_DOMAIN = "wcmc"
        SLACK_TOKEN = credentials('slack-token-test-jenkinsci')
        SLACK_CHANNEL = "#test-jenkinsci"
        COMPOSE_FILE = "docker-compose.yml"
	GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
	SNYK_URL = "https://app.snyk.io/org/olaiyafunmmi/projects"
	jenkinsConsoleUrl = "$env.JOB_URL" + "$env.BUILD_NUMBER" + "/consoleText"
        DIR = "$JENKINS_HOME/workspace"
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
            steps { 
	        script {
	            CI_ERROR = "Failed at: docker-compose build stage"
                    buildProject()
	        }
	    }
        }
        stage("Test DB") {
            steps { 
		script {
		    CI_ERROR = "Failed Stage: Test, create and migrate Database"
                    prepareDatabase() 
		}
	    }
        }
	stage("Integration test") {
            steps { 
		script {
		    CI_ERROR = "Failed Stage: Run Rake Integration test"
                    runIntegrationTest() 
		}
	    }
        }
	    stage('Scan for vulnerabilities') {
           when{
                expression {
                    return env.BRANCH_NAME ==~ /(develop|test-*|((build|ci|feat|fix|perf|test)\/.*))/
                }
            }
               steps {
		        script {
	                    CI_ERROR = "Build Failed at stage: Snyk vulnerability scan failed for this project, check the snyk site for details, ${env.SNYK_URL}"
		                  }
                        echo 'Scanning...'
                        snykSecurity(
                            snykInstallation: 'snyk@latest', snykTokenId: 'snyktoken',
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
                branch 'test-ors-temp'
            }
            steps { 
               	script {
		    CI_ERROR = "Failed at: Prepare deploy stage"
		    sh "mkdir $DIR/deploy-ors"
		    dir("$DIR/deploy-ors") {
		   	checkout scm
         		sh '''#!/bin/bash -l
				eval $(ssh-agent)
			     	ssh-add /tmp/id_deploy
		      		git checkout test-ors-temp
		      		rvm use $(cat .ruby-version) --install
		      		bundle install
		      		echo "bundle exec cap staging deploy --dry-run"
                    	'''
                    }
                }
            }
            post {
		  always {
	             script {
			   deleteDeployDir()
		        }
		    }
                success{
                    slackSend color: "good", message: "Deploy to staging server successful", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                }
                failure{
                    slackSend color: "danger", message: "Deploy to staging server failed", teamDomain: "${env.SLACK_TEAM_DOMAIN}", token: "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
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
    sh "cp config/database-jenkinsci.yml config/database.yml"
    sh "cp config/sidekiq-jenkinsci.yml config/sidekiq.yml"
    sh 'docker-compose -f ${COMPOSE_FILE} --project-name=${JOB_NAME} build --pull'
}

def prepareDatabase() {
    COMMAND = "rake db:drop db:create db:migrate"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def runIntegrationTest() { //bundle exec
    COMMAND = "bundle exec rake test:integration"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def runRspecTests() {
    COMMAND = "bundle exec rspec spec"
    sh "docker-compose --project-name=${JOB_NAME} run web ${COMMAND}"
}

def dockerImageCleanup() {
    sh "docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null"
    sh "docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null"
    sh "docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
    sh "docker-compose --project-name=${JOB_NAME} down --volumes"
    sh '''#!/bin/bash
	docker ps -a --no-trunc  | grep "ors" | awk '{print $1}' | xargs -r --no-run-if-empty docker stop -f
	docker ps -a --no-trunc  | grep "ors" | awk '{print $1}' | xargs -r --no-run-if-empty docker rm -f
	docker images --no-trunc | grep "ors" | awk '{print $3}' | xargs -r --no-run-if-empty docker rmi -f
    '''
}

def deleteDeployDir() {
    sh "sudo rm -r $DIR/deploy-ors*"
}

def deleteWorkspace() {
    sh "sudo rm -rf ${workspace}_ws-*"
}
