# Pushes the container image to quay.io.

# Requires login:
# docker login quay.io

source ../../env.conf

docker push $OM_TAG:$OM_BUILD_VERSION
docker push $OM_TAG:latest

