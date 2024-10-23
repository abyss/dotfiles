#!/bin/bash

__show_virtual_env() {
  # preserve exit status
  local exit=$?

  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    # shellcheck disable=SC2059
    printf "$1" "$(basename $VIRTUAL_ENV)"
  fi

  return $exit
}
export -f __show_virtual_env
