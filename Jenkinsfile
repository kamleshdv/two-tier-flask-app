pipeline {
    agent any
    
    triggers {
        githubPush()   // 👈 ye line add karo
    }

    environment {
        DOCKER_IMAGE = "kamleshdv/flask-app"          // local image naam
        DOCKER_TAG = "${BUILD_NUMBER}"      // har build ka alag tag
        DOCKER_HUB_CREDENTIALS = credentials('jenkinskk')  // Jenkins credential ID
    }

    stages {

        // ── Stage 1: GitHub se Code Lao ──────────────────────────────────────
        stage('Clone Repository') {
            steps {
                echo '📥 GitHub se code aa raha hai...'
                git branch: 'main',
                    url: 'https://github.com/kamleshdv/two-tier-flask-app.git'  // apna repo URL daalo
            }
        }

        // ── Stage 2: Docker Image Build karo ─────────────────────────────────
        stage('Build Docker Image') {
            steps {
                echo '🔨 Docker image build ho rahi hai...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
            }
        }

          // ── Stage 3: Docker Hub pe Push karo ─────────────────────────────────
        stage('Push to Docker Hub') {
            steps {
                echo '📤 Docker Hub pe push ho raha hai...'
                sh "echo ${DOCKER_HUB_CREDENTIALS_PSW} | docker login -u ${DOCKER_HUB_CREDENTIALS_USR} --password-stdin"
                sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                sh "docker push ${DOCKER_IMAGE}:latest"
            }
        }

        // ── Stage 3: Purane Containers Band karo ─────────────────────────────
        stage('Stop Old Containers') {
            steps {
                echo '🛑 Purane containers band ho rahe hain...'
                sh "docker compose down || true"
            }
        }

        // ── Stage 4: Naye Containers Docker Compose se Chalao ────────────────
        stage('Deploy with Docker Compose') {
            steps {
                echo '🚀 Naye containers deploy ho rahe hain...'
                sh "docker compose up -d --build"
            }
        }

        // ── Stage 5: Verify karo ki Containers Chal rahe hain ────────────────
        stage('Verify Deployment') {
            steps {
                echo '✅ Deployment verify ho rahi hai...'
                sh "docker compose ps"
                sh "docker ps"
            }
        }
    }

    // ── Post Actions ──────────────────────────────────────────────────────────
    post {
        success {
            echo '🎉 Pipeline successful! App chal rahi hai.'
        }
        failure {
            echo '❌ Pipeline fail hui! Logs dekho.'
            sh "docker compose logs || true"
        }
        always {
            cleanWs()
        }
    }
}
