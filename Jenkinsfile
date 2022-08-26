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
        //COMPOSE_PROJECT_NAME = "${env.JOB_NAME}-${env.BUILD_ID}".replaceAll("/", "-").replaceAll(" ", "").toLowerCase()
        COMPOSE_FILE = "docker-compose.yml"
	GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
	SNYK_URL="https://app.snyk.io/org/olaiyafunmmi/projects"
	DIR="$JENKINS_HOME/workspace"
    }
    stages {
        //stage ('Start') {
        //       steps {
        //        slackSend(
        //                    teamDomain: "${env.SLACK_TEAM_DOMAIN}",
        //                    token: "${env.SLACK_TOKEN}",
        //                    channel: "${env.SLACK_CHANNEL}",
        //                    color: "#FFFF00",
         //                   message: "STARTED: ['${env.BRANCH_NAME} ${env.GIT_COMMIT_MSG}'] Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})"
        //            )
	//           }
       // }
	
        stage("Build") {
               when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
                }
	      }
            steps { 
	       script {
	         CI_ERROR = "Failed: Build stage"
                 BuildProject() }
	    }
        }
	stage("Test branch") {
		when{
                expression {
                    return env.BRANCH_NAME ==~ /(develop|(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)\/.*))/
                }
            }
           //   when {
        //anyOf { branch 'master'; branch 'develop'; branch 'feat/*' }
        //    }
             steps { 
		 script {
                 echo "does this catch feature branch"
		 }
	     }
        }
	stage("Test branch 2") {
              when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
		//	 expression { BRANCH_NAME ==~ /(production|staging)/ }
                //  return env.BRANCH_NAME ==~ /fix\/.*/ || /feat\/.*/;
		//  return env.BRANCH_NAME ==~ /feat\/.*/;
                }
	      }
             steps { 
		 script {
                 echo "does this catch feature branch second?"
		 }
	     }
        }
        stage("Test DB") {
              when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
                }
	      }
             steps { 
		 script {
		 CI_ERROR = "Failed: Test DB stage"
                 Preparedatabase() }
	     }
        }
        stage("Run Frontend test") {
              when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
                }
	      }
             steps { 
		script {
		 CI_ERROR = "Failed: Frontend test stage"
                 testFrontend() }
	     }
        }
        stage("Rspec test") {
              when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
                }
	      }
             steps { 
		script {
		 CI_ERROR = "Failed: Rspec test stage"
	         echo "runRspecTests"
                // runRspecTests() 
		}
	     }
        }
        stage('Scan for vulnerabilities') {
	    stages {
	      stage("scan rails app") {
                steps {
		    script {
	                 CI_ERROR = "Failed: Snyk scan failed for rails-BE, check the snyk site for details, ${env.SNYK_URL}"
		 }
              echo 'Scanning...'
              snykSecurity(
                snykInstallation: 'snyk@latest', snykTokenId: 'snyktoken',
		severity: 'critical', failOnIssues: false,
		additionalArguments: '--detection-depth=4 --file=rails-api/Gemfile.lock --all-sub-projects --target-dir=rails-api --debug',
              )
            } // additionalArguments: '--exclude=rails-api --target-dir=rails-api --all-projects --detection-depth=4 --policy-path=nuxt-frontend/package.json --exclude=package.json, --target-dir=rails-api --configuration-matching=^(?!Gemfile).* --prune-repeated-subdependencies --debug',
	  } // targetFile: 'rails-api/Gemfile.lock', --targetFile=rails-api/Gemfile.lock
		
             stage("scan project") {
                steps {
		    script {
	                 CI_ERROR = "Failed: Snyk scan failed for project, check the snyk site for details, ${env.SNYK_URL}"
		 }
              echo 'Scanning...'
              snykSecurity(
                snykInstallation: 'snyk@latest', snykTokenId: 'snyktoken',
		severity: 'critical', failOnIssues: false,
		additionalArguments: '--all-projects --detection-depth=4 --exclude=rails-api, --debug',
              )
            }
	   }
	   }
         // post {
              //    success{
               //       slackSend color : "good", message: "Snyk scan successful, visit ${env.SNYK_URL} for detailed report", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
              //    }
               //   failure{
               //       slackSend color : "danger", message: "Snyk scan failed, visit ${env.SNYK_URL} to get detailed report", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
                //  }
              //} //additionalArguments: '--all-projects', --exclude=rails-api targetFile: 'rails-api/Gemfile',
	}
	stage("Prepare Deploy") {
         when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
                }
	      }
             steps { 
               script {
		 CI_ERROR = "Failed: Prepare deploy stage"
		  sh "mkdir $DIR/deploygfs"
		 dir("$DIR/deploygfs") {
		  checkout scm
                  sh '''#!/bin/bash -l
		  git checkout develop
		git branch
                 ls
                 printenv
                git branch
		echo "$GIT_BRANCH"
		rvm use $(cat .ruby-version) --install
		bundle install
		echo "bundle exec cap staging deploy"
                 '''
	   // rvm use $(cat .ruby-version) --install
		// bundle install
                    }
                 }
              }
        }
        stage("Deploy") {
          when {
		 expression {
		     BRANCH_NAME ==~ /(fix\/.*|feat\/.*)/
                }
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
           //  post {
             //     success{
             //         slackSend color : "good", message: "Deploy to staging environment successful", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
              //    }
             //     failure{
              //        slackSend color : "danger", message: "Failed to deploy to staging environment, check the logs and confirm error", teamDomain : "${env.SLACK_TEAM_DOMAIN}", token : "${env.SLACK_TOKEN}", channel: "${env.SLACK_CHANNEL}"
             //     }
             // }
        }
    }
        post {
                always {
			script{
			        BUILD_STATUS = currentBuild.currentResult
		                if (currentBuild.currentResult == 'SUCCESS') { CI_ERROR = "NA" }
				dockerImageCleanup()
				// cleanWs()
			}
		  //  cleanWs(cleanWhenNotBuilt: false,
                 //      deleteDirs: true,
                 //      disableDeferredWipeout: true,
                 //      notFailBuild: true)
		}
	      //  success {
              //      slackSend(
              //              teamDomain: "${env.SLACK_TEAM_DOMAIN}",
              //              token: "${env.SLACK_TOKEN}",
              //              channel: "${env.SLACK_CHANNEL}",
              //              color: "good",
               //             message: "Job:  ${env.JOB_NAME}\n Status: *SUCCESS* \n"
               //     )
              //  }

              //  failure {
              //      slackSend(
              //              teamDomain: "${env.SLACK_TEAM_DOMAIN}",
               //             token: "${env.SLACK_TOKEN}",
               //             channel: "${env.SLACK_CHANNEL}",
               //             color: "danger",
                //            message: "Job:  ${env.JOB_NAME}\n Status: *FAILURE*\n Error description: ${CI_ERROR} \n"
                //    )
               // }
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
//	sh "cd $WORKSPACE/ci"
	sh 'docker-compose --project-name=${JOB_NAME} build --pull'
	// -f ${COMPOSE_FILE}
}

def Preparedatabase() {
    COMMAND="bin/rails db:drop db:create db:migrate db:seed"
    sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
    sh "docker-compose --project-name=${JOB_NAME} run nuxt yarn install"
}

def testFrontend() {
    COMMAND="bundle exec rake test"
	sh "docker-compose --project-name=${JOB_NAME} run rails ${COMMAND}"
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
   sh "docker-compose --project-name=${JOB_NAME} down --volumes"
   sh "docker rmi --force `docker images --quiet --filter 'project-name=${JOB_NAME}' -q --no-trunc` &> /dev/null || true &> /dev/null"
   sh "docker image prune -fa &> /dev/null || true &> /dev/null"
  // sh "docker rmi --force ${docker images -a -q} --filter 'reference=${JOB_NAME}'"
  // sh "docker rmi --force `docker images --quiet --filter=reference=${JOB_NAME}` &> /dev/null || true &> /dev/null"
}

def deleteworkspace() {
	//sh "sudo rm -r $DIR/deploygfs*"
	//sh "sudo rm -rf ${env.WORKSPACE}"
	sh "sudo rm -rf ${workspace}_ws-*"
}
