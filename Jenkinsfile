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
        //COMPOSE_PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}".replaceAll("/", "-").replaceAll(" ", "").toLowerCase()
        COMPOSE_FILE = "docker-compose-ci.yml"
	GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
	SNYK_URL="https://app.snyk.io/org/informatics.wcmc/projects"
	DIR="$JENKINS_HOME/workspace"
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
        stage("Rake test") {
              when {
                  branch 'gf-docker-ci'
                }
             steps { 
		script {
		 CI_ERROR = "Failed: Rake test stage"
                 Raketest() }
	     }
        }
        stage("Rspec test") {
              when {
                  branch 'gf-docker-ci'
                }
             steps { 
		script {
		 CI_ERROR = "Failed: Rspec test stage"
	         echo "Rspectests"
                // Rspectests() 
		}
	     }
        }
        stage('Scan for vulnerabilities') {
            steps {
		    script {
	                 CI_ERROR = "Failed: Snyk scan failed, check the snyk site for details, ${env.SNYK_URL}"
		 }
	     // CI_ERROR = "Failed: Snyk scan failed, check the snyk site for details "${env.SNYK_URL}""
              echo 'Scanning...'
              snykSecurity(
                snykInstallation: 'snyk@latest',
                snykTokenId: 'wcmc-snyk',
		severity: 'critical', 
		additionalArguments: '--all-projects --detection-depth=4 --exclude=rails-api,package.json --target-dir=rails-api --debug',
              )
            }
	   post {
                  success{
                      slackSend color : "good", message: "Snyk scan successful, visit ${env.SNYK_URL} for detailed report", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                  }
                  failure{
                      slackSend color : "danger", message: "Snyk scan failed, visit ${env.SNYK_URL} to get detailed report", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                  }
              } //additionalArguments: '--all-projects', targetFile: 'rails-api/Gemfile',
        }
	
	stage("Prepare Deploy") {
             when {
                  branch 'gf-docker-ci'
                }
             steps { 
               script {
		 CI_ERROR = "Failed: Prepare deploy stage"
		  sh "mkdir $DIR/deploygfs"
		 dir("$DIR/deploygfs") {
		  checkout scm
                  sh '''#!/bin/bash -l
                 ls
                 printenv
                git branch
		echo "$GIT_BRANCH"
                 '''
	   // rvm use $(cat .ruby-version) --install
		// bundle install
                    }
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
		 dir("$DIR/deploygfs") {
                 sh '''#!/bin/bash -l
                 ls
                git branch
		rvm use $(cat .ruby-version) --install
		bundle install
                echo "bundle exec cap staging deploy"
                 '''}
	       }
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
			        BUILD_STATUS = currentBuild.currentResult
		                if (currentBuild.currentResult == 'SUCCESS') { CI_ERROR = "NA" }
				imagecleanup()
				// cleanWs()
			}
		  //  cleanWs(cleanWhenNotBuilt: false,
                 //      deleteDirs: true,
                 //      disableDeferredWipeout: true,
                 //      notFailBuild: true)
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
			//cleanWs(cleanWhenNotBuilt: false,
                         // deleteDirs: true,
                        //  disableDeferredWipeout: true,
                        //  notFailBuild: true)
		//	script{
		//		deleteworkspace()
		//	}
		// deleteDir()
	          dir("$DIR/deploygfs") {
		    deleteDir()
		    }
	          dir("$DIR/deploygfs@tmp") {
		    deleteDir()
		    }
		 // dir("${env.WORKSPACE}") {
		 //   deleteDir()
		//    }
		//  dir("${WORKSPACE}@tmp") {
		 //   deleteDir()
		//  }
	           deleteworkspace()
		}
    }
}


def BuildProject() {
    sh 'echo "Building Project.............."'
	sh 'docker-compose -f ${COMPOSE_FILE} --project-name=${JOB_NAME} build --pull'
}

def Preparedatabase() {
    COMMAND="bin/rails db:drop db:create db:migrate db:seed"
    sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
    sh "docker-compose --project-name=${JOB_NAME} run nuxt yarn install"
}

def Raketest() {
    COMMAND="bundle exec rake test"
	sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
	// sh "docker-compose --project-name=${JOB_NAME} run nuxt yarn lint"
}

def Rspectests() {
    COMMAND="bundle exec rspec spec"
	sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
}

def imagecleanup() {
   sh "docker-compose --project-name=${JOB_NAME} stop &> /dev/null || true &> /dev/null"
   sh "docker-compose --project-name=${JOB_NAME} rm --force &> /dev/null || true &> /dev/null"
   sh "docker stop `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
   sh "docker rm -v `docker ps -a -q -f status=exited` &> /dev/null || true &> /dev/null"
   sh "docker rmi `docker images --filter 'dangling=true' -q --no-trunc` &> /dev/null || true &> /dev/null"
}

def deleteworkspace() {
	//sh "sudo rm -r $DIR/deploygfs*"
	//sh "sudo rm -rf ${env.WORKSPACE}"
	sh "sudo rm -rf ${workspace}_ws-*"
}
