node('java-docker-slave') {
    stage ('CheckOut GitHub') {
        
     	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
    stage ('Build') {
         sh "mvn package" 
    }
	stage ('Upload Artifact') {
	   nexusPublisher nexusInstanceId: 'nexus3', nexusRepositoryId: 'maven-releases', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: 'target/jpetstore.war']], mavenCoordinate: [artifactId: 'jpetstore', groupId: 'org.jenkins-ci.prueba', packaging: 'war', version: '$BUILD_NUMBER']]]
	}
	stage('SonarQube analysis') {
		withSonarQubeEnv('sonar') {
		  sh 'mvn sonar:sonar'
		} // submitted SonarQube taskId is automatically attached to the pipeline context
	}
	stage("Quality Gate"){
	    //timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
    	sleep(10)
		def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
		if (qg.status != 'OK') {
		  error "Pipeline aborted due to quality gate failure: ${qg.status}"
		}
    }
    docker.withTool("docker") { 
		withDockerServer([credentialsId: "", uri: "unix:///var/run/docker.sock"]) { 
			stage ('Deploy DEV') {
				 sh "docker cp ./target/jpetstore.war tomcatcompose:/usr/local/tomcat/webapps/"
				 sh "docker restart tomcatcompose"
			}
			stage ('Updates BBDD'){
				 sh "docker cp update.sql mysqlcompose:/"
				 sh "docker exec -i mysqlcompose mysql -uroot -pbmcAdm1n jpetstore < update.sql;"

			 }
			
		}
        stage ('CheckOut GitHub Pruebas') {

            checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'test']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/juananmora/jpetstore-test.git']]]) 
        }
        stage ('Download Cilantrum Jar') {
            sh "wget http://192.168.1.68:8082/repository/maven-releases/testing/cilantrum/1.0/cilantrum-1.0.jar" 
        }
        stage ('Testing Automation DEV') {
        sh "java -jar cilantrum-1.0.jar %BUILD_NUMBER% 'Jenkins' './test/resources/buildDEV.properties'" 
       
        }
        stage('TestNG DEV') {
            step([$class: 'Publisher', reportFilenamePattern: '**/test-output/testng-results.xml',
                                                                                                thresholdMode: 2,
                                                                                                failedSkips: 100,
                                                                                                failedFails: 90,
                                                                                                unstableFails: 90,
                            showFailedBuilds: true
                        ])
            echo "RESULT: ${currentBuild.currentResult}"
        }

        stage('Approve to QA?'){

            
            input "Deploy to QA?"
            
        }
        
        withDockerServer([credentialsId: "", uri: "unix:///var/run/docker.sock"]) { 
			stage ('Deploy QA') {
				 sh "docker cp ./target/jpetstore.war tomcatcomposedos:/usr/local/tomcat/webapps/"
				 sh "docker restart tomcatcomposedos"
			}
			stage ('Updates BBDD'){
				 sh "docker cp update.sql mysqlcompose:/"
				 sh "docker exec -i mysqlcompose mysql -uroot -pbmcAdm1n jpetstore < update.sql;"

			 }
			
		}
        
        stage ('Testing Automation QA') {
        sh "java -jar cilantrum-1.0.jar %BUILD_NUMBER% 'Jenkins' './test/resources/buildQA.properties'" 
       
        }
        stage('TestNG QA') {
            step([$class: 'Publisher', reportFilenamePattern: '**/test-output/testng-results.xml',
                                                                                                thresholdMode: 2,
                                                                                                failedSkips: 100,
                                                                                                failedFails: 90,
                                                                                                unstableFails: 90,
                            showFailedBuilds: true
                        ])
            echo "RESULT: ${currentBuild.currentResult}"
        }
        stage ('Enviando Notificación al equipo') {
            slackSend channel: '#builds',
                        color: 'good',
                        message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
	    }
    }
 }


