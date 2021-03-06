#!/bin/bash

reportfailed()
{
    echo "$*" 1>&2
    exit 255
}

# The following code is adapted from:
# https://github.com/axsh/nii-image-and-enshuu-scripts/blob/master/nii-management-scripts/terminate-all-instances.sh

check_instances()
{
    mussel instance index | \
	(
	    date=xxx # only instances database rows with empty "deleted_at" should be displayed
	    while read ln; do
		case "$ln" in
		    *:id:*)
			[ "$date" = "" ] && echo "$out"
			read dash label theid <<<"$ln"
			out="     $theid "
			;;
		    *:deleted_at:*)
			read label date rest <<<"$ln"
			;;
		esac
	    done
	    [ "$date" = "" ] && echo "$out"
	)

}

ilist="$(check_instances 2>/dev/null)"
for inst in $ilist; do
    echo "Terminating instance: $inst"
    mussel instance destroy $inst 2>/dev/null
done
