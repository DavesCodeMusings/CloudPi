# Running a Self-Hosted Git Server
Portainer has the ability to integrate with a git repository for storing the Docker Compose configurations used in its _stack deploy_ feature. This can be a handy way to maintain the YAML that defines the containers you're running, particularly when the number of apps starts to grow. Besides Portainer's stacks, you can use git to centrally store your own coding projects.

## Can I Skip It?
You don't have to run a git server locally. You can integrate Portainer with a public git server, like GitHub. You can also store your YAML files as plain text and use Portainer's built-in web editor for deployment. Not running your own git server doesn't really have any downsides. It just one of those things you do, because you can.


TODO

## Next Steps
At this point in the project, Docker is running, Portainer is there to ease the administration of Docker, and you might have a git repository to store your Docker Compose YAML. Congratulations! It's time to start running some more applications in Docker. Start with [running NextCloud](run-nextcloud.md).
