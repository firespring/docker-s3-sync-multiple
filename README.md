# docker-s3-sync
A lightweight container which synchronizes a directory with an s3 bucket at a specified interval.

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
