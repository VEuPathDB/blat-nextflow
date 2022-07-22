FROM ubuntu:22.10

Label maintainer="rdemko2332@gmail.com"

WORKDIR /usr/bin/

RUN apt-get -qq update --fix-missing && \
    apt-get install -y \
    wget \
    libpng-dev \
    libssl-dev \
    gcc \
    unzip \
    make \
    uuid-dev \
    pip \
    git \ 
    libmysqlclient-dev \
    libcurl4 \
    rsync
    
RUN rsync -aP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/blat ./

WORKDIR /work

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/blat/