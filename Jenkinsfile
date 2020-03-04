// Powered by Infostretch 



node ('maven') {
	
	//env.JMETER_HOME='D:/Users/jamora/Programas/apache-jmeter-4.0/apache-jmeter-4.0'

	stage ('Checkout GitHub') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/development']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITLAB', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
	stage ('Build Artifact Maven') {
	    sh "mvn package " 
	}
	stage ('Calidad de Codigo - SonarQube') {
	   echo "Pasamos Calidad de Código con Sonar"
	   sleep("5") 
	}	
	stage ('Subida binario a Nexus') {
	   echo "Subimos el binario generado a Nexus"
	   sleep("5") 
	}
	stage ('Creación Imagen Docker y Registro Imagen en Harbor') {
	   echo "Creamos imagen inmutable con Kaniko"
	   sleep("5") 
	}
	stage ('Deploy Dev') {
	   echo "Deploy en el entorno de Dev"
           sleep("5") 
	}
	stage ('Deploy PRE') {
	   echo "Deploy en el entorno de Pre"
	   sleep("5") 
	}	
	stage ('Test Funcionales') {
	    echo "Ejecución de Test Funcionales con Cilantrum"
	    sh "wget http://selenium-hub-project-jon.apps.us-east-2.starter.openshift-online.com/"
	}
	stage ('Test Rendimiento') {
	    echo "Ejecución de Test Rendimiento con Jmeter"
	    sleep("5") 
	}	
	stage ('Despliegue Blue Green PRO') {
	    input 'Do you approve deployment in PRO?'
		echo "Deploy BG PRO"
	}
	
}




