node('java-docker-slave') {
    stage ('CheckOut GitHub') {
        
     	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
    stage ('Build') {
         sh "mvn package" 
    }
	stage ('Upload Artifact') {
	   nexusPublisher nexusInstanceId: 'localNexus', nexusRepositoryId: 'releases', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: 'target/jpetstore.war']], mavenCoordinate: [artifactId: 'jpetstore', groupId: 'org.jenkins-ci.prueba', packaging: 'war', version: '$BUILD_NUMBER']]]
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
			stage ('Deploy') {
				 sh "docker cp ./target/jpetstore.war tomcatcomposedos:/opt/apache-tomcat-8.5.37/webapps/"
				 sh "docker restart tomcatcomposedos"
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
		}
    }
}




