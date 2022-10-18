FROM jenkins/jenkins:lts

# Become the root user
USER root

# Go to the Jenkins home directory
WORKDIR /var/jenkins_home

RUN apt-get update -y

# Install docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    chmod +x get-docker.sh && \
    sh get-docker.sh

# Install docker compose
RUN curl -SL https://github.com/docker/compose/releases/download/v2.11.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Add Jenkins user to Docker group. This will allow the normal user Jenkins to execute docker commands
RUN usermod -aG docker jenkins

# Revoke back the root privilege
USER jenkins