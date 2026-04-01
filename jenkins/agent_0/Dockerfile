FROM jenkins/ssh-agent:latest

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg lsb-release ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add HashiCorp GPG key and repository
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo $VERSION_CODENAME) main" \
    > /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
RUN apt-get update && \
    apt-get install -y terraform && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Ansible
RUN apt-get update && \
    apt-get install -y ansible && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER jenkins
