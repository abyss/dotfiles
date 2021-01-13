__terraform_workspace() {
    # preserve exit status
    local exit=$?

    if [ -d .terraform ]; then
        local workspace="$(command terraform workspace show 2>/dev/null)"
        if [ -z "${workspace}" ]; then
            return $exit
        else
            printf "$1" "${workspace}"
        fi
    fi

    return $exit
}
