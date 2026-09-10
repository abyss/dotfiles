# shellcheck shell=bash
# shellcheck disable=SC2034  # full palette is intentional; not all colors are used here

# Colors for output.
# $'...' stores a real ESC byte rather than a literal '\033' sequence, so these
# render correctly as printf *arguments* and not just inside a format string.
RESET=$'\033[0m'
RED=$'\033[00;31m'
GREEN=$'\033[00;32m'
YELLOW=$'\033[00;33m'
BLUE=$'\033[00;34m'
PURPLE=$'\033[00;35m'
CYAN=$'\033[00;36m'
LIGHTGRAY=$'\033[00;37m'
LRED=$'\033[01;31m'
LGREEN=$'\033[01;32m'
LYELLOW=$'\033[01;33m'
LBLUE=$'\033[01;34m'
LPURPLE=$'\033[01;35m'
LCYAN=$'\033[01;36m'
WHITE=$'\033[01;37m'

# Output Helpers
# The message is passed as an argument, so '%' and '\' in it are printed as-is.
header() {
    printf '%s### %s%s%s\n' "$CYAN" "$LCYAN" "$1" "$RESET"
}

success() {
    printf '%s### %s%s%s\n' "$CYAN" "$GREEN" "$1" "$RESET"
}

information() {
    printf '%s!!! %s%s%s\n' "$CYAN" "$YELLOW" "$1" "$RESET"
}

warning() {
    printf '%s!!! %s%s %s!!!%s\n' "$RED" "$YELLOW" "$1" "$RED" "$RESET"
}

error() {
    printf '%s!!! %s %s!!!%s\n' "$RED" "$1" "$RED" "$RESET"
}

fail() {
    1>&2 printf '%s!!! %s %s!!!%s\n' "$RED" "$1" "$RED" "$RESET"
    exit 1;
}
