pipeline {
    agent any
    options {
        // number of build logs to keep - https://www.jenkins.io/doc/book/pipeline/syntax/
        buildDiscarder(logRotator(numToKeepStr: '5'))
        //Pipeline speed, much faster, Greatly reduces disk I/O - requires clean shutdown to save running pipelines
        durabilityHint('PERFORMANCE_OPTIMIZED')
        // Disallow concurrent executions of the Pipeline. Can be useful for preventing simultaneous accesses to shared resources
        disableConcurrentBuilds()
    }
    triggers {
        // Accepts a cron-style string to define a regular interval at which Jenkins should check for new source changes. 
	    // If new changes exist, the Pipeline will be re-triggered
        pollSCM 'H/5 * * * *'
    }
    environment {
        SLACK_TEAM_DOMAIN="wcmc"
        SLACK_TOKEN=credentials('slack-token-gef')
        SLACK_CHANNEL="#jenkins-cicd-gefspatial"
        COMPOSE_FILE = "docker-compose.yml"
	    GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
	    SNYK_URL="https://app.snyk.io/org/informatics.wcmc/projects"
    }
    stages {
        stage ('Start') {
            steps {
                slackSend(
                    teamDomain: "${env.SLACK_TEAM_DOMAIN}",
                    token: "${env.SLACK_TOKEN}",
                    channel: "${env.SLACK_CHANNEL}",
                    color: "#FFFF00",
                    message: "STARTED: '${env.BRANCH_NAME} [${env.GIT_COMMIT_MSG}]' Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
                )
	        }
        }
        stage("Build") {
            when {
                branch 'testb'
            }
            steps { 
	            script {
	                CI_ERROR = "Failed: Build stage"
                        buildProject()
	            }
	        }
        }
        stage("Test DB") {
            when {
                branch 'testb'
            }
            steps { 
		        script {
		            CI_ERROR = "Failed: Test DB stage"
                        prepareDatabase() 
		        }
	        }
        }
        stage("Run Frontend test") {
            when {
                branch 'testb'
            }
            steps { 
		        script {
		            CI_ERROR = "Failed: Test FE stage"
                        testFrontend() 
		        }
	        }
        }
        stage('Scan for vulnerabilities') {
            when {
                branch 'testb'
            }
	        stages {
	            stage("scan rails app") {
                    steps {
		                script {
	                        CI_ERROR = "Failed: Snyk scan failed for rails-BE, check the snyk site for details, ${env.SNYK_URL}"
		                }
                            echo 'Scanning...'
                            snykSecurity(
                            snykInstallation: 'snyk@latest', snykTokenId: 'wcmc-snyk',
		                    severity: 'critical', failOnIssues: false,
		                    additionalArguments: '--detection-depth=4 --file=rails-api/Gemfile.lock --all-sub-projects --target-dir=rails-api', 
			                )
                        } 
	            }	
                stage("scan other projects") {
                    steps {
		                script {
	                        CI_ERROR = "Failed: Snyk scan failed for project, check the snyk site for details, ${env.SNYK_URL}"
		                }
                            echo 'Scanning...'
                            snykSecurity(
                            snykInstallation: 'snyk@latest', snykTokenId: 'wcmc-snyk',
		                    severity: 'critical', failOnIssues: false,
		                    additionalArguments: '--all-projects --detection-depth=4 --exclude=rails-api,', 
			                )
                        }
	                }
	            }
    	}
    }
    post {
        always {
	        script {
                BUILD_STATUS = currentBuild.currentResult
		        if (currentBuild.currentResult == 'SUCCESS') { CI_ERROR = "NA" }
		        dockerImageCleanup()
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
        cleanup {
                cleanWs()
		        deleteworkspace()
		}
    }
}

def buildProject() {
    sh 'echo "Building Project.............."'
    sh 'docker-compose -f ${COMPOSE_FILE} --project-name=${JOB_NAME} build --pull'
}

def prepareDatabase() {
    COMMAND="bin/rails db:drop db:create db:migrate db:seed"
    sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
}

def testFrontend() {
    sh "docker-compose --project-name=${JOB_NAME} run nuxt yarn install"
    // sh "docker-compose --project-name=${JOB_NAME} run nuxt yarn lint"
}

def runRspecTests() {
    COMMAND="bundle exec rspec spec"
    sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
}

def dockerImageCleanup() {
    sh "docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null"
    sh "docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null"
    sh "docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
    sh "docker rm -v `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
    sh "docker rmi `docker images --filter 'dangling=true' -q --no-trunc` &> /dev/null || true &> /dev/null"
}

def deleteWorkspace() {
    sh "sudo rm -rf ${workspace}_ws-*"
}
