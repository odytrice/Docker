FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y curl jq sudo wget ca-certificates

# Install Dotnet
RUN wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb \
 && dpkg -i /tmp/packages-microsoft-prod.deb \
 && rm /tmp/packages-microsoft-prod.deb \
 && apt-get update \
 && apt-get install -y dotnet-sdk-8.0 dotnet-sdk-10.0

# Install Docker
RUN curl -fsSL https://get.docker.com | sh

# Install Kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

# Install Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
RUN mv ./kustomize /usr/local/bin

# Create user and group
ARG user=runner
ARG group=runner
ARG uid=1100
ARG gid=1100
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} # <--- the '-m' create a user home directory

# Grant the runner passwordless sudo so `playwright install --with-deps`
# (which switches to root to apt-get browser OS libraries) works in CI steps
# that run as the non-root runner user.
RUN echo "${user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${user} && chmod 0440 /etc/sudoers.d/${user}

# Install NodeJS
USER runner

ENV NODE_VERSION=24.13.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/home/${user}/.nvm

# Add NVM and PATH setup to .profile
RUN echo 'export NVM_DIR="/home/${user}/.nvm"' >> /home/${user}/.profile && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >> /home/${user}/.profile && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> /home/${user}/.profile && \
    echo 'export PATH="$NVM_DIR/versions/node/v${NODE_VERSION}/bin:$PATH"' >> /home/${user}/.profile

RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}

# Install other package managers
RUN . "/home/${user}/.profile" && npm install -g yarn pnpm

USER root

WORKDIR /home/runner

# Download Runner
RUN curl -o actions-runner-linux-x64-2.332.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.332.0/actions-runner-linux-x64-2.332.0.tar.gz
RUN echo "f2094522a6b9afeab07ffb586d1eb3f190b6457074282796c497ce7dce9e0f2a  actions-runner-linux-x64-2.332.0.tar.gz" | shasum -a 256 -c
RUN tar xzf ./actions-runner-linux-x64-2.332.0.tar.gz

# Configure and Startup Runner
COPY startup.sh .
CMD [ "/bin/bash", "./startup.sh" ]
