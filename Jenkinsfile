pipeline {
    agent { label 'WORKSTATION' }

    options {
        ansiColor('xterm')
    }
    parameters{
        choice(name: 'ENV', choices: ['DEV', 'PROD' ],description:'choose ENV')
        string(name: 'COMPONENT', defaultValue: '', description: 'Which App component')
    }
    environment{
        SSH= credentials('CENTOS')
    }
    stages {
        stage('create server'){
            steps{
                sh 'bash ec2-launch.sh ${COMPONENT} ${ENV}'
            }
        }
        stage('ansible playbook run') {
            steps {
                script{
                    env.ANSIBLE_TAG=COMPONENT.toUpperCase()
                }
               // sh 'sleep 60'
                sh 'ansible-playbook -i roboshop.inv roboshop.yml -e ENV=${ENV} -t ${ANSIBLE_TAG} -e ansible_password=${SSH_PSW} -u ${SSH_USR}'
            }
        }
    }
}
