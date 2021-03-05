// Powered by Infostretch 



node ('maven') {
	
	//env.JMETER_HOME='D:/Users/jamora/Programas/apache-jmeter-4.0/apache-jmeter-4.0'

	stage ('Checkout GITLAB') {
 	 checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GITLAB', url: 'https://github.com/juananmora/jpetstore.git']]]) 
	}
	stage ('Build Artifact') {
	
	  	  sh "mvn package " 
	  
	}
	stage ('Scan Sonar') {
		
		//sh "docker build -t juananmora/tomcattest:'$BUILD_NUMBER' ."	
		
		//bat "docker exec tomcatdes rm -rf /usr/local/tomcat/webapps/jpetstore.war" 
		}
	
	stage ('Deploy DEV') {
	        //sh "docker cp -a target\\jpetstore.war tomcatdes:/usr/local/tomcat/webapps/" 
			
    }
	stage ('Push image to Registry') {

		//	bat "docker commit tomcatdes imagetomcatdes:${BUILD_NUMBER}"
		//    bat "docker login -u juananmora -p gloyjonas"
		//    bat "docker tag imagetomcatdes:${BUILD_NUMBER}  juananmora/tomcatdes:${BUILD_NUMBER}"
		//    bat "docker push juananmora/tomcatdes:${BUILD_NUMBER}"
			
	}
    stage ('Reiniciando contenedor TomcatDes') {
	    //    bat "docker restart tomcatdes" 
	}

	stage 'Deploy Version QA'
		input 'Do you approve deployment in QA?'
		node {
			//bat "docker exec tomcatqat rm -rf /usr/local/tomcat/webapps/jpetstore.war" 
		}
	
	stage ('Deploy QAT') {
	     //   bat "docker cp -a target\\jpetstore.war tomcatqat:/usr/local/tomcat/webapps/" 
    }
    stage ('Reiniciando contenedor tomcatqat') {
	    //    bat "docker restart tomcatqat" 
    }
	
	stage 'Deploy Version PRO'
		input 'Do you approve deployment in PRO?'
		node {
		    
			//bat "docker exec tomcatprd rm -rf /usr/local/tomcat/webapps/jpetstore.war" 
		}
	
	stage ('Deploy PRO') {
	        //bat "docker cp -a target\\jpetstore.war tomcatprd:/usr/local/tomcat/webapps/" 
    }
    stage ('Reiniciando contenedor tomcatprd') {
	       // bat "docker restart tomcatprd" 
    }
	
}



