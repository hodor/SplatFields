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
    cmake \
    pkg-config \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    liblzma-dev && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for pyenv
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Install cargo for diffusers
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install pyenv and Python 3.7.13
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    $PYENV_ROOT/bin/pyenv install 3.7.13 && \
    $PYENV_ROOT/bin/pyenv global 3.7.13

ENV SPLAT_ROOT="/root/splatfields"
ENV MMCV_ROOT="/root/mmcv"
ENV MMGEN_ROOT="/root/mmgen"
ENV DATA_ROOT="/root/blender_dataset"
ENV ROOT="/root"

RUN pip install --upgrade pip setuptools wheel
RUN pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu116

# Prepare MMCV for manual compilation
RUN git clone -b v1.6.0 https://github.com/hodor/mmcv.git $MMCV_ROOT
WORKDIR $MMCV_ROOT
RUN pip install -r requirements/optional.txt
# RUN MMCV_WITH_OPS=1 FORCE_CUDA=1 pip install -e . -v
# RUN python .dev_scripts/check_installation.py

# Prepare MMGEN for manual compilation
WORKDIR $ROOT
RUN git clone https://github.com/hodor/mmgeneration.git $MMGEN_ROOT
WORKDIR $MMGEN_ROOT
RUN pip install -e . -v

# Prepare Splat Fields
WORKDIR $ROOT
RUN git clone -b docker https://github.com/hodor/SplatFields.git $SPLAT_ROOT
WORKDIR $SPLAT_ROOT

RUN pip install -r requirements.txt
# This will ensure that we're going to build using our own torch and cuda
# Unfortunately I was running into some issues here so I'll have to ask the users to run this themselves inside the
# docker image after they are running the image.
#RUN pip install --no-build-isolation git+https://github.com/ingra14m/depth-diff-gaussian-rasterization@f2d8fa9921ea9a6cb9ac1c33a34ebd1b11510657#egg=diff_gaussian_rasterization
#RUN pip install --no-build-isolation git+https://gitlab.inria.fr/bkerbl/simple-knn.git@44f764299fa305faf6ec5ebd99939e0508331503#egg=simple_knn
#RUN pip install --no-build-isolation git+https://github.com/open-mmlab/mmgeneration@f6551e1d6ca24121d1f0a954c3b3ac15de6d302e#egg=mmgen
# Then get the blender dataset that the paper requests
RUN pip install nerfbaselines
RUN nerfbaselines download-dataset -o $DATA_ROOT external://blender

# Set the default command to run when starting the container
CMD ["bash"]