FROM jenkins/ssh-agent:latest

USER root

RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release software-properties-common ca-certificates && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install -y terraform

RUN apt-get install -y ansible

USER jenkins
