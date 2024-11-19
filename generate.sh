#!/bin/bash -e
_work_dir="$(pwd)"
_tree="${1}"
case "${_tree}" in
  aosp) tree=aosp ;;
  twrp) tree=twrp ;;
esac
pushd "${_work_dir}/${tree}tree"
  for i in external packages/apps; do
    pushd "${i}"
      for dir in *; do
        pushd "${dir}"
	  ./generate.sh
	popd
      done
    popd
  done
popd
