node('java-docker-slave') {
    stage ('CheckOut GitHub') {
        
     	 checkout([$class: 'GitSCM', branches: [[name: '*/testjenkins']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
    stage ('Build') {
         sh "mvn package" 
    }
	stage ('Upload Artifact') {
	   nexusPublisher nexusInstanceId: 'localNexus', nexusRepositoryId: 'releases', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: 'target/jpetstore.war']], mavenCoordinate: [artifactId: 'jpetstore', groupId: 'org.jenkins-ci.testjenkins', packaging: 'war', version: '$BUILD_NUMBER']]]
	}
	stage('SonarQube analysis') {
		withSonarQubeEnv('sonar') {
		  sh 'mvn sonar:sonar'
		} // submitted SonarQube taskId is automatically attached to the pipeline context
	}
	stage("Quality Gate"){
	    //timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
		sleep(20)
		def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
		if (qg.status != 'OK') {
		  error "Pipeline aborted due to quality gate failure: ${qg.status}"
		}
    }
    docker.withTool("docker") { 
		withDockerServer([credentialsId: "", uri: "unix:///var/run/docker.sock"]) { 
			stage ('Deploy') {
				 sh "docker cp ./target/jpetstore.war tomcatcompose:/opt/apache-tomcat-8.5.37/webapps/"
				 sh "docker restart tomcatcompose"
			}
			stage ('Updates BBDD'){
				 sh "docker cp update.sql mysqlcompose:/"
				 sh "docker exec -i mysqlcompose mysql -uroot -pbmcAdm1n jpetstore < update.sql;"

			 }

 		stage ('Build Image'){
        				sh "docker build -t juananmora/tomcattest:'$BUILD_NUMBER' ."
        				sh "docker login -u juananmora -p gloyjonas"
        				sh "docker push juananmora/tomcattest:'$BUILD_NUMBER'"
        				sh "docker image rm juananmora/tomcattest:'$BUILD_NUMBER'"
        				//sh """docker rmi "\$(docker images -f 'dangling=true' -q)\""""
   		 }
       	stage ('Deploy Test Environment'){
        				//sh "docker stop tomcatdemo"
        				//sh "docker rm tomcatdemo"
        				sh "docker rm -f tomcatdemo > /dev/null 2>&1 && echo 'removed container' || echo 'nothing to remove'"
        				sh "docker create -it --add-host jpetstore-db.bmc.aws.local:172.23.0.3 --network netcompose --name tomcatdemo -p 8075:8080 juananmora/tomcattest:'$BUILD_NUMBER' catalina.sh run"
        				sh "docker start tomcatdemo"
         }

        stage ('CheckOut GitHub Test') {

                 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/juananmora/jpetstore-testing.git']]])
            }
            stage ('Download Cilantrum Jar') {
                 sh "wget http://192.168.1.47:8081/nexus/service/local/repositories/releases/content/cilamtrum/jpetstore/1.0/jpetstore-1.0.jar"
            }
            stage ('Testing Automation') {
              sh "java -jar jpetstore-1.0.jar %BUILD_NUMBER% 'Jenkins' 'resources/buildDEV.properties'"
            }
            stage('TestNG') {
                step([$class: 'Publisher', reportFilenamePattern: '**/test-output/testng-results.xml',
                                                                                                      thresholdMode: 2,
                                                                                                      failedSkips: 100,
                                                                                                      failedFails: 90,
                                                                                                      unstableFails: 90,
                                showFailedBuilds: true
                            ])

            }



		}
    }
}



