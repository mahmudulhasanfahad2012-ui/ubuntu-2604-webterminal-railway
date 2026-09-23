FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:/usr/local/bin:${PATH}"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     bash \
     ca-certificates \
     curl \
     wget \
     git \
     unzip \
     zip \
     nano \
     vim-tiny \
     tmux \
     htop \
     tree \
     jq \
     procps \
     lsof \
     net-tools \
     build-essential \
     python3 \
     python3-venv \
     python3-pip \
     tini \
     fastfetch \
  && rm -rf /var/lib/apt/lists/*

# Install code-server and Antigravity during image build, not at container startup.
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN curl --compressed -fsSL https://antigravity.google/cli/install.sh | bash

RUN mkdir -p /data/workspace /data/config /data/antigravity \
  && printf '%s\n' 'export PATH="/root/.local/bin:/usr/local/bin:$PATH"' >> /root/.bashrc \
  && printf '%s\n' 'fastfetch || true' >> /root/.bashrc

COPY start-code-server.sh /start-code-server.sh
RUN chmod 0755 /start-code-server.sh

EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/start-code-server.sh"]
