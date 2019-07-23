# xnat2bidsAAC
Docker container for converting xnat session data to bids format

# Build Docker Image
Navigate to an empty folder on your system

`git clone https://github.com/MRIresearch/xnat2bidsAAC.git`
 
`docker build -t orbisys/dcm2bids-session:1.0`

# install in xnat
Copy and paste the commands from orbisys-dcm2bids-command.json into the command script for container in XNAT.
