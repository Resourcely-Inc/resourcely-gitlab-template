#!/bin/bash

PLANS=$(ls -1 $TF_PLAN_DIRECTORY/$TF_PLAN_PATTERN)
if [[ -z "${PLANS}" ]]; then
	echo "No plans detected in '$TF_PLAN_DIRECTORY' with pattern '$TF_PLAN_PATTERN'"
	exit 1
fi

echo "The following plans have been detected:"
echo "${PLANS}" | sed 's/ /\n/g'