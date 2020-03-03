// Powered by Infostretch 



node ('maven') {
	
	//env.JMETER_HOME='D:/Users/jamora/Programas/apache-jmeter-4.0/apache-jmeter-4.0'

	stage ('Checkout GitHub') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/development']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITLAB', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
	stage ('Build Artifact Maven') {
	    sh "mvn package " 
	    //sleep("400000") 
	}
	stage ('Calidad de Codigo - SonarQube') {
	   echo "Sonar"
	}	
	stage ('Subida binario a Nexus') {
	   echo "Nexus"
	}
	stage ('Creación Imagen Docker y Registro Imagen en Harbor') {
	   echo "Kaniko"
	}
	stage ('Deploy Dev') {
	   echo "Deploy Dev
	}
	stage ('Deploy PRE') {
	   echo "Deploy Pre"
	}	
	stage ('Test Funcionales') {
	    echo "Test Funcionales"
	}
	stage ('Test Rendimiento') {
	    echo "Test Rendimiento"
	}	
	stage ('Despliegue Blue Green PRO') {
	    input 'Do you approve deployment in PRO?'
		echo "Deploy BG PRO"
	}
	
}




