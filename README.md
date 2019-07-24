# xnat2bidsAAC
Docker container for converting xnat session data to bids format

# Build Docker Image
Navigate to an empty folder on your system

`cd xnat2bidsAAC`

`git clone https://github.com/MRIresearch/xnat2bidsAAC.git`
 
`docker build -t orbisys/dcm2bids-session:1.0 .`

# Install in xnat
Command labels have been added in the `Dockerfile` which should enable it to be xnat-ready once pulled into xnat. The command labels have also been provided 
separately in `orbisys-dcm2bids-command.json`.

These commands can also be copied into the command script for container in XNAT if there are issues with the automatic upload.

# Configuration map
before running the container you will need to map the bids format with the dicoms. An example of a config file is included as `dcm2bids_config.json`


This is mapped into xnat as follows:


`curl -u [USER]:[PASSWD] -d @[PATH_TO_DIR]/dcm2bids_config.json -X PUT '[XNAT_URL]/data/projects/[PROJECT_ID]/config/dcm2bids/bidsconfig?inbody=true'`


example:

`curl -u admin:mypasswd -d @/home/admin/Desktop/MY_NEURO_PROJECT/dcm2bids_config.json -X PUT '159.143.11.222/data/projects/MY_NEURO_PROJECT/config/dcm2bids/bidsconfig?inbody=true'`


