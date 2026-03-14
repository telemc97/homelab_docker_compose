FROM jenkins/ssh-agent:latest

USER root

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install general build tools and LaTeX requirements
RUN apt-get update && \
    apt-get install -y \
        git \
        make \
        curl \
        ca-certificates \
        # LaTeX Core & Recommended Packages
        texlive-latex-recommended \
        texlive-latex-extra \
        # Fonts (required for many CV templates)
        texlive-fonts-recommended \
        texlive-fonts-extra \
        # Automation tool
        latexmk \
        # Language support
        texlive-lang-english \
        # Required for latexmk
        perl \
        # General utilities (from your example)
        build-essential \
        python3 \
        python3-pip && \
    # Clean up to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jenkins