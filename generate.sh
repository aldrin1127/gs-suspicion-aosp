#!/bin/bash -e
_work_dir="$(pwd)"
_tree="${1}"
case "${_tree}" in
  aosp) tree=aosp ;;
  twrp) tree=twrp ;;
esac
pushd "${_work_dir}/${tree}tree"
  for i in external packages/apps; do
    for script in `find $i/*/generate.sh`; do
      "${script}"
    done
  done
popd
