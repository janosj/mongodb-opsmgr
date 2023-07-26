# Convenience script to inspect the contents of a container.

source ../../env.conf

# Assumes container hasn't been previously run:
docker run -it --rm --name ops-manager $OM_TAG:latest bash

# If the container is already running:
# docker exec -it ops-manager bash

# If the previously started container needs to be restarted:
# docker start $OM_TAG

# To see what's out there:
# docker container ls     # running containers
# docker container ls -a  # all containers
# docker image ls

# To remove
# docker rm $OM_TAG

# To clean house:
# docker system prune

