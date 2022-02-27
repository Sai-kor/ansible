pipeline {
    agent { label 'WORKSTATION' }

    options {
        ansiColor('xterm')
    }
    parameters{
        choice(name: 'ENV', choices: ['DEV', 'PROD' ],description:'choose ENV')
        string(name: 'COMPONENT', defaultValue: '', description: 'Which App component')
    }
    stages {
        stage('create server'){
            steps{
                sh 'bash ec2-launch.sh ${COMPONENT}'
            }
        }
        stage('ansible playbook run') {
            steps {
                script{
                    def ANSIBLE_TAG=toUpperCase(${COMPONENT})
                }
                sh 'ansible-playbook -i roboshop.inv roboshop.yml -e ENV=${ENV} -t ${ANSIBLE_TAG} '
            }
        }
    }
}
