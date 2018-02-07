# docker-s3-sync-multiple
A lightweight container which synchronizes multiple files/directories using a dynamically generated docker-compose file and the firespring/s3-sync docker image

docker run -ti \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN \
  -e SYNC_BUCKET_LIST="s3://foo;s3://foo-alt-region" \
  -e AWS_DEFAULT_REGION="us-west-1" \
  -e AWS_SYNC_OPTIONS="--source-region=us-west-2" \
  firespring/s3-sync-multiple
  -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN
