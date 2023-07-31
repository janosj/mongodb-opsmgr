# Pushes the container image to quay.io.

# Requires login:
# docker login quay.io

source ../../env.conf

docker push $AGENT_TAG:$OM_BUILD_VERSION
docker push $AGENT_TAG:latest

