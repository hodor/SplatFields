# Use NVIDIA's CUDA image as the base
FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu18.04
LABEL authors="Rogerio Gasi"

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

# Install necessary utilities and dependencies for building Python
RUN apt-get update && \
    apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    curl \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for pyenv
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Install pyenv and Python 3.7.13
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    $PYENV_ROOT/bin/pyenv install 3.7.13 && \
    $PYENV_ROOT/bin/pyenv global 3.7.13

ENV SPLAT_ROOT="/root/splatfields"

RUN git clone -b docker https://github.com/hodor/SplatFields.git $SPLAT_ROOT
WORKDIR $SPLAT_ROOT

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Set the default command to run when starting the container
CMD ["bash"]