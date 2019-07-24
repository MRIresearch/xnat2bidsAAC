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

LABEL org.nrg.commands="[{  \"name\": \"orbisys-dcm2bids-session\",  \"description\": \"Runs BIDS conversion using dcm2bids-session, dcm2bids and dcm2niix and uploads to resources at session level.\",  \"version\": \"1.0\",  \"schema-version\": \"1.0\",  \"image\": \"orbisys/dcm2bids-session:1.0\",  \"type\": \"docker\",  \"command-line\": \"python dcm2bids_master.py #SESSION_ID# #OVERWRITE# #SESSION_LABEL# --host \$XNAT_HOST --user \$XNAT_USER --pass \$XNAT_PASS --upload-by-ref False --dicomdir /dicom --niftidir /nifti\",  \"override-entrypoint\": true,  \"mounts\": [    {      \"name\": \"nifti\",      \"writable\": true,      \"path\": \"/nifti\"    }  ],  \"environment-variables\": {},  \"ports\": {},  \"inputs\": [    {      \"name\": \"session_id\",      \"description\": \"XNAT ID of the session\",      \"type\": \"string\",      \"matcher\": null,      \"default-value\": null,      \"required\": true,      \"replacement-key\": \"#SESSION_ID#\",      \"sensitive\": null,      \"command-line-flag\": \"--session\",      \"command-line-separator\": null,      \"true-value\": null,      \"false-value\": null    },    {      \"name\": \"overwrite\",      \"description\": \"Overwrite any existing NIFTI and BIDS scan resources?\",      \"type\": \"boolean\",      \"matcher\": null,      \"default-value\": \"true\",      \"required\": false,      \"replacement-key\": \"#OVERWRITE#\",      \"sensitive\": null,      \"command-line-flag\": \"--overwrite\",      \"command-line-separator\": null,      \"true-value\": \"True\",      \"false-value\": \"False\"    },    {      \"name\": \"session_label\",      \"description\": \"session label to use instead of default\",      \"type\": \"string\",      \"matcher\": null,      \"default-value\": null,      \"required\": false,      \"replacement-key\": \"#SESSION_LABEL#\",      \"sensitive\": null,      \"command-line-flag\": \"--session_label\",      \"command-line-separator\": null,      \"true-value\": null,      \"false-value\": null    }  ],  \"outputs\": [],  \"xnat\": [    {      \"name\": \"orbisys-dcm2bids-session\",      \"label\": null,      \"description\": \"Run dcm2bids-orbisys on a Session\",      \"contexts\": [        \"xnat:imageSessionData\"      ],      \"external-inputs\": [        {          \"name\": \"session\",          \"description\": \"Input session\",          \"type\": \"Session\",          \"matcher\": null,          \"default-value\": null,          \"required\": true,          \"replacement-key\": null,          \"sensitive\": null,          \"provides-value-for-command-input\": null,          \"provides-files-for-command-mount\": null,          \"via-setup-command\": null,          \"user-settable\": null,          \"load-children\": true        }      ],      \"derived-inputs\": [        {          \"name\": \"session-id\",          \"description\": \"The session's id\",          \"type\": \"string\",          \"matcher\": null,          \"default-value\": null,          \"required\": true,          \"replacement-key\": null,          \"sensitive\": null,          \"provides-value-for-command-input\": \"session_id\",          \"provides-files-for-command-mount\": null,          \"user-settable\": null,          \"load-children\": true,          \"derived-from-wrapper-input\": \"session\",          \"derived-from-xnat-object-property\": \"id\",          \"via-setup-command\": null        }      ],      \"output-handlers\": []    }  ]}]"
