source ../env.conf

docker network create $DOCKER_NETWORK

echo "Docker network $DOCKER_NETWORK created!"

docker network ls

