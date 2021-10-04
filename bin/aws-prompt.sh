__aws_profile() {
    # preserve exit status
    local exit=$?

    local profile="${AWS_PROFILE:=default}"
    if [ "$profile" == "default" ]; then
        # Doesn't show AWS_PROFILE if unset/default
        return $exit
    else
        printf "$1" "${AWS_PROFILE}"
    fi

    return $exit
}
