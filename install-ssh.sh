# install cron that calls the run script 


# Get current path
export PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get variables
[ -n "$PROJECT_DIR" ]
. "${PROJECT_DIR}/vars.sh"

printf "******************************\n"
printf "* Installing CRON job"
printf "\n******************************\n"

# Check to see if CRON job is already installed
if [[ $(crontab -l | egrep -v "^(#|$)" | grep -q 'run'; echo $?) == 1 ]]; then
    echo "No existing CRON job found, creating one"
    (crontab -l ; echo "*/1 * * * * bash $PROJECT_DIR/run.sh") | crontab -
    crontab -l
else
    printf "* CRON job already exists"
    printf "\n \n "
    crontab -l
fi

