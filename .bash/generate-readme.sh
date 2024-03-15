#!/bin/bash

template=$1

tempfile=$(mktemp)
find . -maxdepth 1 -type d \( ! -name ".*" \) | while read -r item; do
    item=$(basename "$item")
    if [[ "$item" != "." ]]; then
        echo "### $item" >> "$tempfile"
        find "$item" -maxdepth 1 -type f -name "*.md" | sort -t. -k1,1n | sort -V | while read -r file; do
            file=$(basename "$file" .md)
            folder=$(basename "$item" | sed 's/ /%20/g')
            file_link=$(echo "$file" | sed 's/ /%20/g')
            echo "- [$file](https://github.com/koshacha/leetcode/blob/main/$folder/$file_link.md)" >> "$tempfile"
        done
    fi
done

list=$(<"$tempfile")
output="${template/\%LIST%/$list}"
echo "$output"

rm "$tempfile"
