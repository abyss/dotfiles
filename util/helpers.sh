# Colors for output
RESET='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

# Output Helpers
header() {
    printf "${CYAN}### ${LCYAN}${1}${RESET}\n"
}

success() {
    printf "${CYAN}### ${GREEN}${1}${RESET}\n"
}

information() {
    printf "${CYAN}!!! ${YELLOW}${1}${RESET}\n"
}

warning() {
    printf "${RED}!!! ${YELLOW}${1} ${RED}!!!${RESET}\n"
}

error() {
    printf "${RED}!!! ${1} ${RED}!!!${RESET}\n"
}

fail() {
    1>&2 printf "${RED}!!! ${1} ${RED}!!!${RESET}\n"
    exit 1;
}
