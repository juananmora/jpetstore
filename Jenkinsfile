// Powered by Infostretch 



node ('maven') {
	
	//env.JMETER_HOME='D:/Users/jamora/Programas/apache-jmeter-4.0/apache-jmeter-4.0'

	stage ('Checkout GITLAB') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITLAB', url: 'D:/jpetstore-master/jpetstore-master/.git']]]) 
	}
	stage ('Build Artifact') {
	    sh "mvn package " 
	   
	}
	
	stage ('Enviando Notificación al equipo') {
		slackSend channel: '#builds',
					  color: 'good',
					  message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
	}
}




