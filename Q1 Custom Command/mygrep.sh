#!/bin/bash

print_usage() {
  echo "Usage: $0 [OPTIONS] PATTERN FILE"
  echo "Options:"
  echo "  -n    Show line numbers"
  echo "  -v    Invert match (show non-matching lines)"
  echo "  -vn or -nv Combine -v and -n"
  echo "  --help Show this help message"
}

if [[ "$1" == "--help" ]]; then
  print_usage
  exit 0
fi

ignore_case=true
show_line_numbers=false
invert_match=false

while getopts "nv" opt; do
  case "$opt" in
    n)
      show_line_numbers=true
      ;;
    v)
      invert_match=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [[ $# -ne 2 ]]; then
  echo "Error: Please provide a search pattern and a filename." >&2
  print_usage
  exit 1
fi

pattern="$1"
filename="$2"

if [[ ! -f "$filename" ]]; then
  echo "Error: File '$filename' not found." >&2
  exit 1
fi

line_number=1

while IFS= read -r line; do
  trimmed_line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  if [[ -n "$trimmed_line" ]]; then
    found=false
    if [[ "${trimmed_line,,}" =~ "${pattern,,}" ]]; then
      found=true
    fi

    if [[ "$invert_match" == "true" ]]; then
      if [[ "$found" == "false" ]]; then
        if [[ "$show_line_numbers" == "true" ]]; then
          echo "$line_number: $line"
        else
          echo "$line"
        fi
      fi
    else
      if [[ "$found" == "true" ]]; then
        if [[ "$show_line_numbers" == "true" ]]; then
          echo "$line_number: $line"
        else
          echo "$line"
        fi
      fi
    fi
  fi
  ((line_number++))
done < "$filename"