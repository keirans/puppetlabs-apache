node {
        stage("Puppet testing in Docker Container") {
        
                        sh "export"

        
            stage("Cleanup the workspace and checkout the code"){ 
                step([$class: 'WsCleanup'])
                checkout scm
            }
            
            
            docker.image('ruby:2.3.0').inside('-v /etc/passwd:/etc/passwd -v /var/lib/jenkins:/var/lib/jenkins/') {

              stage("Prepare the testing environment") {
                sh "echo The hostname is `hostname`"
                sh "bundle install"
              }
              
            stage("Run Puppet linting checks") {
                sh "rake lint"
              }
              
            stage("Run Puppet Syntax checks") {
                sh "rake validate"
              }
              
            stage("Run Puppet rSpec Tests") {
                sh "rake spec"
              }
            }
            
        } 
} 
