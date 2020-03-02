// Powered by Infostretch 



node ('maven') {
	
	//env.JMETER_HOME='D:/Users/jamora/Programas/apache-jmeter-4.0/apache-jmeter-4.0'

	stage ('Checkout GitHub') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/development']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITLAB', url: 'https://github.com/juananmora/jpetstore.git']]]) 
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




