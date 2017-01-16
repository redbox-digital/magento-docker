#! /usr/bin/env bash
set -e

function find_in_parent {
  local filename="$1"
  local start="$2"

  if [ -z "$start" ]
  then
    start="$(pwd)"
  fi

  local candidate="$start/$filename"

  if [ -e "$candidate" ]
  then
    echo -n "$candidate"
  elif [ "$start" == "/" ]
  then
    >&2 echo -n "File $filename not found in any directory"
  else
    find_in_parent "$filename" "$(dirname $start)"
  fi
}

function update_self {
  local self_url="https://raw.githubusercontent.com/redbox-digital/magento-docker/master/rd"
  local location="$BASH_SOURCE"

  curl -sS "$self_url" | tee "$location" &> /dev/null
}

function main {
  local rd="$(find_in_parent bin/rd 2> /dev/null)"

  case $1 in
    "update")
      update_self
      ;;
    *)
      if [ -x "$rd" ]
      then
        exec "$rd" "$@"
      else
        >&2 echo "Unable to find a Redbox Docker project in any parent directory."
      fi
      ;;
  esac
}

main "$@"
