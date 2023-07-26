source ../../env.conf

# Assumes container hasn't been previously run:
docker run -it --entrypoint="" --rm --name agent $AGENT_TAG:latest bash

# If the container is already running:
# docker exec -it $AGENT_TAG bash

# If the previously started container needs to be restarted:
# docker start $AGENT_TAG

# To see what's out there:
# docker container ls     # running containers
# docker container ls -a  # all containers
# docker image ls

# To remove
# docker rm $AGENT_TAG

# To clean house:
# docker system prune

