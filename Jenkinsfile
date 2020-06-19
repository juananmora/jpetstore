node('java-docker-slave') {
    stage ('CheckOut GitHub') {
        
     	 checkout([$class: 'GitSCM', branches: [[name: '*/testjenkins']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
    stage ('Build') {
         sh "mvn package" 
    }
	stage ('Upload Artifact') {
	   nexusPublisher nexusInstanceId: 'localNexus', nexusRepositoryId: 'releases', packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: '', extension: '', filePath: 'target/jpetstore.war']], mavenCoordinate: [artifactId: 'jpetstore', groupId: 'org.jenkins-ci.testjenkins', packaging: 'war', version: '$BUILD_NUMBER'-'$JOB_NAME']]]
	}
	//stage('SonarQube analysis') {
	//	withSonarQubeEnv('sonar') {
	//	  sh 'mvn sonar:sonar'
	//	} 
	//}

    
}

node('java-docker-slave') {
    docker.withTool("docker") { 
		withDockerServer([credentialsId: "", uri: "unix:///var/run/docker.sock"]) { 
			stage ('Deploy') {
				 sh "wget http://localhost:8081/nexus/service/local/repositories/releases/content/org/jenkins-ci/testjenkins/jpetstore/16/jpetstore-16.war"
				 sh "docker cp jpetstore-16.war tomcatcompose:/opt/apache-tomcat-8.5.37/webapps/"
				 sh "docker restart tomcatcompose"
			}
			stage ('Updates BBDD'){
				 sh "docker cp update.sql mysqlcompose:/"
				 sh "docker exec -i mysqlcompose mysql -uroot -pbmcAdm1n jpetstore < update.sql;"

			 }
        stage ('CheckOut GitHub Test') {

                 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'test']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/juananmora/jpetstore-testing.git']]])
            }
            stage ('Download Cilantrum Jar') {
                 sh "wget http://192.168.1.47:8081/nexus/service/local/repositories/releases/content/cilamtrum/jpetstore/1.0/jpetstore-1.0.jar"
            }
            


		
	}
    }
}



