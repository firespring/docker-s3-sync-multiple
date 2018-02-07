#!/bin/sh

echo "Running sync command [ $(echo "$*" | envsubst) ]"

if ! $(docker info >/dev/null 2>&1)
then
  echo "Unable to connect to docker. You may have forgot to link in the docker socket as a volume (-v /var/run/docker.sock:/var/run/docker.sock)"
  exit 1
fi

generate()
{
  local sync_vars="AWS_DEFAULT_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_OPTIONS AWS_SYNC_OPTIONS SYNC_PERIOD"

  if [ -z "${SYNC_BUCKET_LIST}" ]
  then
    echo "Must specify a list of buckets to sync in the form [ SOURCE_LOCATION:DESTINATION_LOCATION ... ]"
    exit 1
  fi

  clear
  write 'version: "2.1"'
  write 'services:'

  for buckets in ${SYNC_BUCKET_LIST}
  do
    src_location=$(echo ${buckets} | cut -d ';' -f 1)
    dst_location=$(echo ${buckets} | cut -d ';' -f 2)
    if [ -z "${src_location}" ] || [ -z "${dst_location}" ]
    then
      echo "Must specify a list of buckets to sync in the form [ SOURCE_LOCATION:DESTINATION_LOCATION ... ]"
      echo "  SOURCE_LOCATION was '${src_location}'"
      echo "  DEST_LOCATION was '${dst_location}'"
      exit 1
    fi

    service_name=$(echo ${src_bucket} | sed -re 's/[^a-zA-Z0-9_.-]//g')
    write "  ${service_name}"
    write "    image: firespring/s3-sync"
    write "    environment:"
    write "      SOURCE_LOCATION: ${src_location}"
    write "      DEST_LOCATION: ${dst_location}"

    for sync_var in ${sync_vars}
    do
      #echo "SYNC VAR IS ${sync_var}"
      #echo "SYNC VAR VALUE IS sync_var=$sync_var eval echo \\\$sync_var"
      #value=$(sync_var=$sync_var /bin/sh -c "eval echo \$$sync_var")
      #value=$(sync_var=$sync_var eval echo \$$sync_var)
      sync_value=$(eval echo \$$sync_var)
      if [ ! -z "$sync_value" ]
      then
        write "      ${sync_var}: '${sync_value}'"
      fi
    done

    write ""
  done
}

clear()
{
  echo -n '' > docker-compose.yml
}

write()
{
  echo "$*" >> docker-compose.yml
}

if [ ! -f docker-compose.yml ]
then
  generate
fi

exit

sh -c "$*"
