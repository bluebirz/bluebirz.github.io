#!/bin/bash

MAINPATH="assets/img/features/"
SUBPATHS=(
  "bluebirz/"
  "external/"
)
is_passed=1
max_width=1600

echo ">> Checking media files..."
for subpath in "${SUBPATHS[@]}"; do
  echo ">>- Looking into ${MAINPATH}${subpath}..."
  for img in $(
    find "$MAINPATH$subpath" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort -u
  ); do
    dimensions=$(identify -format "%wx%h\n" "$img")
    height=$(echo "$dimensions" | awk -F 'x' '{print $1}')
    width=$(echo "$dimensions" | awk -F 'x' '{print $2}')
    if [[ "$width" -gt "$max_width" ]]; then
      echo "$img : h=$height w=$width (too large; max width: $max_width)"
      is_passed=0
    fi
  done
done

if [ $is_passed -eq 0 ]; then exit 1; fi
echo "passed :)"
