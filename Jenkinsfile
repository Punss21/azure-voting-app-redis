pipeline {
   agent any

   stages {
      stage('Verify Branch') {
         steps {
            echo "$GIT_BRANCH"
         }
      }
      stage('Docker Build') {
         steps {
            sh(script: 'docker images -a')
            sh(script: """
               cd azure-vote/
               docker images -a
               docker build -t jenkins-pipeline .
               docker images -a
               cd ..
            """)
         }
      }
      stage('Start test app') {
         steps {
            sh(script: """
               docker-compose up -d
               chmod -R 777 scripts/test_container.sh
               ./scripts/test_container.sh
            """)
         }
         post {
            success {
               echo "App started successfully :)"
            }
            failure {
               echo "App failed to start :("
            }
         }
      }
      stage('Run Tests') {
         steps {
            sh(script: """
               
               pytest ./tests/test_sample.py
            """)
         }
      }
      stage('Stop test app') {
         steps {
            sh(script: """
               docker-compose down
            """)
         }
      }
      stage('Push Container'){
         steps {
            echo "Workspace is : $WORKSPACE"
            dir("$WORKSPACE/azure-vote") {
               script {
                  docker.withRegistry('https://index.docker.io/v1/', 'DockerHub') {
                     def image = docker.build('punss21/jenkins-course:latest')
                     image.push()
                  }
               }
            }
         }

      }
      // stage('Run trivy') {
      //    steps{
      //       sh(script: """
      //          trivy punss21/jenkins-course 
      //       """)
      //    }
      // }
      stage('Run Anchore') {
         steps {
            sh(script: """
               echo "punss21/jenkins-course" > anchore_images
               anchore name: 'anchore_images'
            """)
            anchore bailOnFail: false, bailOnPluginFail: false, name: 'anchore_images'
         }
      }
   }
}
