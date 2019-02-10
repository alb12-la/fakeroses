#!/bin/bash

export PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ -n "$PROJECT_DIR" ]
. "${PROJECT_DIR}/vars.sh"


CURRENT_DATE_TIME="`date "+%H_%M_%S"`";

## Create naming 
FILENAME="${CURRENT_DATE_TIME}.jpg"

function logger(){
    echo -e $1  >> ${LOG_FILE}
}

function createMedia {
    logger "\n++ ${CURRENT_DATE_TIME} ++"
    logger "Creating ${FILENAME}"
    fswebcam -r 1280x720 --no-banner "${LOCAL_OUTPUT_DIR}/${FILENAME}" 
}

function uploadMedia {
    logger "Attempting to upload ${FILENAME} to ${REMOTE_USERNAME}@${REMOTE_ADDRESS}:${REMOTE_OUTPUT_DIR}/${FILENAME}"
    # Attempt to upload file
    scp -i "${IDENTITY_LOCATION}" "${LOCAL_OUTPUT_DIR}/${FILENAME}" ${REMOTE_USERNAME}@${REMOTE_ADDRESS}:"${REMOTE_OUTPUT_DIR}/${FILENAME}"
    
    # Get status
    UPLOAD_STATUS=$?

    # If successful remove file
    if [ ${UPLOAD_STATUS} = 0 ]; then    
        logger "Successfully uploaded ${FILENAME}"
        rm  ${LOCAL_OUTPUT_DIR}/${FILENAME}

    else 
        # Else keep trying
        logger "Failed to upload ${UPLOAD_STATUS}"
        #TODO :REACT TO FAILURE
        # attempt 3 times, if all unsuccessful send mail alert
    fi
}


# Check directory exists
if [ ! -d ${LOCAL_OUTPUT_DIR} ]; then
    logger "* Creating output dir => ${LOCAL_OUTPUT_DIR}" 
    mkdir -p ${LOCAL_OUTPUT_DIR}
fi

function main {
    # Create file if it doesn't already exist
    # Check log of all files created
    if [ ! -f ${LOCAL_OUTPUT_DIR}/${FILENAME} ]; then
        createMedia
        uploadMedia
    else
        uploadMedia
    fi
}

main