# DCM2BIDS v2.0.0
# MAINTAINER: christophe.bedetti@montreal.ca

# Install Ubuntu 16.04 
FROM ubuntu:xenial

RUN apt update && \
    apt upgrade -y && \
    apt update && \
    apt install -y build-essential cmake git pigz
RUN apt update

RUN apt install -y nodejs-legacy

RUN apt install -y npm
RUN apt install -y python
RUN apt install -y python-pip

RUN apt clean
RUN apt autoclean
RUN apt autoremove -y

RUN pip install --upgrade pip

#Install bids-validator
RUN npm install -g bids-validator

#Install dcm2niix from github
RUN cd /usr/local/src && \
    git clone https://github.com/rordenlab/dcm2niix.git && \
    cd dcm2niix && \
    git checkout tags/v1.0.20181125 -b install && \
    mkdir build  && \
    cd build && \
    cmake ..  && \
    make install 

#Install dcm2bids from github
RUN cd /usr/local/src && \
    git clone https://github.com/cbedetti/Dcm2Bids.git

RUN cd /usr/local/src/Dcm2Bids && sed -i 's/datetime.now().isoformat()/(datetime.now() - datetime(1970,1,1)).total_seconds()/g' ./dcm2bids/dcm2bids.py    
RUN cd /usr/local/src/Dcm2Bids && pip install .

RUN pip install \
        dicom \
        nipype \
        requests

RUN mkdir /src /dicom /bids
WORKDIR /src
COPY ./dcm2bids_master.py /src
