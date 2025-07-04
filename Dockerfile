FROM ghcr.io/actions/actions-runner:2.325.0

USER root

ARG TARGETARCH
ARG TARGETOS=linux

# install extra repos
RUN set -e; \
  apt-get update; \
  apt-get install -y curl apt-transport-https lsb-release gnupg; \
  curl -sLk https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg; \
  echo "deb [arch=${TARGETARCH}] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list; \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc; \
  chmod a+r /etc/apt/keyrings/docker.asc; \
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# COPY microsoft.asc /tmp/microsoft.asc

# # install packages
# RUN set -e; \
#   gpg --dearmor < /tmp/microsoft.asc > /etc/apt/trusted.gpg.d/microsoft.gpg; \
#   echo "deb [arch=${TARGETARCH}] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list;


RUN set -e; \
    apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y \
    ca-certificates \
    software-properties-common \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    buildah \
    podman \
    azure-cli \
    nodejs \
    npm \
    wget \
    python3 \
    python3-pip \
    python3-venv \
    python3-dnspython \
    python3-boto3 \
    python3-google-auth \
    python3-hcloud \
    python3-passlib \
    unzip \
    zip \
    iputils-ping \
    sudo \
    git \
    vim \
    jq \
    ssh \
    pkg-config \
    dnsutils \
    iproute2 \
    rsync \
    pwgen \
    jq \
    gettext-base \
    groff; \
  add-apt-repository --yes --update ppa:ansible/ansible; \
  apt install -y \
    ansible-core \
    ansible-lint; \
  rm -rf /var/lib/apt/lists/*

# ##versions: https://github.com/helm/helm/releases
ARG HELM_VERSION=3.18.2
RUN set -e; \
  cd /tmp; \
  curl -Ssk -o helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
  tar xzf helm.tar.gz; \
  mv ${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/; \
  chmod +x /usr/local/bin/helm; \
  rm -rf ${TARGETOS}-${TARGETARCH} helm.tar.gz

# ##versions: https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=1.33.1
RUN set -e; \
    cd /tmp; \
    curl -sLOk "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl"; \
    mv kubectl /usr/local/bin/; \
    chmod +x /usr/local/bin/kubectl

# ##versions: https://github.com/hashicorp/terraform/releases
ARG TERRAFORM_VERSION=1.11.0
RUN set -e; \
  cd /tmp; \
  curl -Ssk -o terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TARGETOS}_${TARGETARCH}.zip; \
  unzip terraform.zip; \
  mv terraform /usr/local/bin/; \
  chmod +x /usr/local/bin/terraform; \
  rm terraform.zip

# ##versions: https://github.com/bitnami-labs/sealed-secrets/releases
ARG KUBESEAL_VERSION=0.30.0
RUN set -e; \
  cd /tmp; \
  curl -LSsOk https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
  tar -xzf kubeseal-${KUBESEAL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz kubeseal; \
  install -m 755 kubeseal /usr/local/bin/kubeseal; \
  rm -rf kubeseal-${KUBESEAL_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz kubeseal

COPY registries.conf /etc/containers/registries.conf

# RUN mkdir -p /pyenv && chown coder:coder /pyenv

USER runner

# COPY requirements.txt /pyenv/
# RUN python3 -m venv /pyenv && \
#     . /pyenv/bin/activate && \
#     pip3 install -r /pyenv/requirements.txt -i https://mirrors.sustech.edu.cn/pypi/web/simple

# COPY --chown=coder:coder ansible-requirements.yaml /tmp/
# RUN set -e; \
#   ansible-galaxy install -r /tmp/ansible-requirements.yaml; \
#   rm /tmp/ansible-requirements.yaml

# ENV PATH=${PATH}:/home/runner/.local/bin:/home/runner/bin

