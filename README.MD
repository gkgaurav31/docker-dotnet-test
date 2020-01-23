Steps to repro:

docker build -t test .  
docker run -d -p 8080:8080 --name myapp test

container will not start.

check logs:
docker logs myapp