# Stop all running containers
docker stop $(docker ps -a -q)

# Removes all Docker artifacts from the system,
# Frees up space on your host system
# and cleans the slate for the next run.
docker system prune

# Docker images are left intact,
# so nothing has to be rebuilt.
# Containers can be relaunched using the scripts in /run.


