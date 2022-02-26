pipeline {
    agent { label 'WORKSTATION' }

    stages {
        stage('ansible playbook run') {
            steps {
                sh 'ansible-playbook 08-parallel-plays.yml'
            }
        }
    }
}
