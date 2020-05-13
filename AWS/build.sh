#!/usr/bin/env bash

PROFILE=$1
REGION=$2

USAGE="Usage:\n  ./build.sh <profile> <region>\n"

if [[ ! "${PROFILE}" || ! "${REGION}" ]]; then
  echo -e $USAGE
  exit 1
fi

sed -i '' -e "s/{PROFILE}/${PROFILE}/g; s/{REGION}/${REGION}/g" Initializer/main.tf

cd Initializer && terraform init && \
BUCKET=$(terraform apply -no-color -auto-approve | tee /dev/tty | grep ^bucketname\ =\ | awk '{print $3}') && \
cd .. &&
sed -i '' -e "s/{PROFILE}/${PROFILE}/g; s/{REGION}/${REGION}/g; s/{BUCKET}/${BUCKET}/g" main.tf && \
terraform init && terraform apply
