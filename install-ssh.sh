export PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get variables
[ -n "$PROJECT_DIR" ]
. "${PROJECT_DIR}/vars.sh"

function installCronTab {
    case ${CAPTURE_FREQ} in
        "1MIN")      
        echo "1 minute interval selected"
        (crontab -l ; echo "*/1 * * * * bash $PROJECT_DIR/run.sh") | crontab -
        ;;
        "1HR")      
        echo "1 hour interval selected"
        ;;
        "1DAY")      
        echo "1 day interval selected"
        ;;
        *)
        echo "NO INTERVAL SELECTED"
        ;;
    esac
    crontab -l
}


## Check for requirements when on the pi
if [[ $(uname) == *"Linux"* ]]; then
    printf "******************************\n"
    printf "* Checking for requirements"
    printf "\n******************************\n"
    # install cron that calls the run script 
    dpkg -s fswebcam &> /dev/null
    if [ $? -eq 0 ]; then
        echo "fswebcam already installed"
    else
        echo "Installing fswebcam ..."
        sudo apt-get install fswebcam
    fi
fi

printf "\n******************************\n"
printf "* Installing CRON job"
printf "\n******************************\n"

if [[ $(crontab -l | grep -q 'run'; echo $?) == 1 ]]; then
    echo "No existing CRON job found, creating one"
    installCronTab;
else
    printf "* CRON job already exists"
    crontab -l
fi
