#!/bin/bash -e
git clone https://git.ffmpeg.org/ffmpeg.git .src
pushd .src
printf '%s.r%s.g%s' \
  "$(git describe --tags --long | awk -F'-' '{ sub(/^n/, "", $1); print $1 }')" \
  "$(git describe --tags --match 'N' | awk -F'-' '{ print $2 }')" \
  "$(git rev-parse --short HEAD)" > VERSION
rm -rf .git
popd
mv .src/{.*,*} . && rm -rf .src
./gen-android-configs 
