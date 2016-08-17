#!/bin/bash

# If this script is run without any parameters, it will make a copy of
# each notebook in an ./expanded/ directory, except that all headings
# will be expanded.  Also un-hides any hidden input or output areas of
# cells hidden by the runtools extension.

# For some types of proof reading this should be helpful.



export CODEDIR="$(cd "$(dirname "$0")" && pwd -P)"

if [ "$*" = "" ]; then
    cd "$CODEDIR/.."
    flist=( notebooks/*.ipynb )
else
    flist=( "$@" )
fi


process1()
{
    while IFS= read -r ln; do
	case "$ln" in
	    *hide_input*:*true* | *hide_output*:*true*) # run runtools hide/show input/output
		printf "%s\n" "${ln/true/false}"  # hide by renaming to unused value
		;;
	    *hidden*:*true*)  # for heading collapse/uncollapse
		printf "%s\n" "${ln/hidden/hidevalue}"  # hide by renaming to unused value
		;;
	    *heading_collapsed*:*true*)  # for heading collapse/uncollapse
		printf "%s\n" "${ln/heading_collapsed/hidevalue}" # hide by renaming to unused value
		:
		;;
	    *)
		printf "%s\n" "$ln"
		;;
	esac
    done
}


for f in "${flist[@]}"; do
    full="$(readlink -f "$f")"
    fdir="$(dirname "$full")"
    fname="${full##*/}"
    mkdir -p "$fdir/expanded"
    process1 <"$f" >"$fdir/expanded/$fname"
done
