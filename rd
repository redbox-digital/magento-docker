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
    >&2 echo "File $filename not found in any directory"
  else
    find_in_parent "$filename" "$(dirname $start)"
  fi
}

function main {
  local rd="$(find_in_parent bin/rd)"

  if [ -n "$rd" ]
  then
    exec "$rd" "$@"
  else
    >&@ echo "Unable to find a Redbox Docker project in any parent directory."
  fi
}

main "$@"
