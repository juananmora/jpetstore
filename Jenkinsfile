// Powered by Infostretch 



node ('maven') {
	
	//env.JMETER_HOME='D:/Users/jamora/Programas/apache-jmeter-4.0/apache-jmeter-4.0'

	stage ('Checkout GitHub') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/development']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITLAB', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
	stage ('Build Artifact Maven') {
	    sh "mvn package " 
	    sleep("5000") 
	}
	stage ('Calidad de Codigo - SonarQube') {
	   echo "Sonar"
	   sleep("5000") 
	}	
	stage ('Subida binario a Nexus') {
	   echo "Nexus"
	   sleep("5000") 
	}
	stage ('Creación Imagen Docker y Registro Imagen en Harbor') {
	   echo "Kaniko"
	   sleep("5000") 
	}
	stage ('Deploy Dev') {
	   echo "Deploy Dev"
           sleep("5000") 
	}
	stage ('Deploy PRE') {
	   echo "Deploy Pre"
	   sleep("5000") 
	}	
	stage ('Test Funcionales') {
	    echo "Test Funcionales"
	    sh "wget http://selenium-hub-project-jon.apps.us-east-2.starter.openshift-online.com/"
	}
	stage ('Test Rendimiento') {
	    echo "Test Rendimiento"
	    sleep("5000") 
	}	
	stage ('Despliegue Blue Green PRO') {
	    input 'Do you approve deployment in PRO?'
		echo "Deploy BG PRO"
	}
	
}




