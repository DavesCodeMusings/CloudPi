# Home Automation
At this point in the project, you've got a Raspberry Pi that can run just about anything that comes as a Docker container. Running home automation will expand upon this by deploying several applications in a stack.

By the end of this step, you will have:
* Home Assistant to provide a user interface.
* Mosquitto to enable MQTT integrations with devices.
* NodeRED to let you build complex custom workflows.
* ESPHome to manage devices running on an ESP microcontroller-based gateway.

## Can I Skip It?
You don't have to install the home automation stack. It's completely optional. If you choose to deploy it, you don't have to deploy all the applications, nor do you need to invest in a bunch of "smart" devices. You can start small with some passive home monitoring and go from there.

## Summary of Commands
1. [`ansible-playbook pre-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/tree/main/home-automation/pre-deploy.yml)
2. [`docker-compose up -d`](https://github.com/DavesCodeMusings/CloudPi/blob/main/home-automation/docker-compose.yml)
3. [`ansible-playbook post-deploy.yml`](https://github.com/DavesCodeMusings/CloudPi/blob/main/home-automation/post-deploy.yml)

## Understanding the Components
The main application in the home automation stack is Home Assistant. This is central hub, providing connectivity to various devices and organizing the data into a dashboard view. Home assistant can be integrated with a surprising number of devices just over wifi. Without a lot of effort, you can probably connect to your television, internet router, video game console, thermostat, mobile phones, etc.

ESPHome is helpful for connecting to other, non-wifi devices like those using Bluetooth Low Energy. This includes things like battery powered sensors. It does not run on the Raspberry Pi. The ESPHome container is simple a management console for communicating with ESPHome running on [ESP32 microcontrollers](https://en.wikipedia.org/wiki/ESP32).

Mosquitto is an application that provides a common communication protocol (called MQTT) that is understood by a large number of home automation devices. Configuration is very simple and having and MQTT gateway will greatly expand the number and type of devices you can integrate with.

Node-RED is for creating complex integrations with your devices and carrying out actions based on workflows that you create. You can do simple things like monitor temperature with device attached to a freezer and send an alert if it gets too warm. Or you can do complex things, enabling the tap of a button on your phone to turn on the television, power up the home theater system, and bring up the menu for your favorite streaming service.

## Deploying the Stack
Even with the large number of applications in this stack, deploying is really no different than the others. There are the usual files, organized under a [`home-automation` directory](https://github.com/DavesCodeMusings/CloudPi/blob/main/home-automation) The same procedure applies.

```
ansible-playbook pre-deploy.yml
docker-compose.yml (in Portainer)
```

## Configuring Components
Most of the Home Assistant configuration can be done using the web-based interface, though sometimes you will see references to `configuration.yaml`. When you deploy the home automation stack using the Ansible playbooks, you'll find `configuration.yaml` in the `/opt/docker/homeassistant` directory. Configuration help can be found in the official documentation at: https://www.home-assistant.io/docs/configuration/

TODO: Mosquitto, NodeRED, ESPHome

## Next Steps
If you made it this far, you are well versed in deploying and configuring containerized applications. You have created a system with plenty of services to help you install the next, shiny application that catches your eye. The only thing stopping you is the resouce constraints of the tiny computing platform called Raspberry Pi. But as we have seen over the course of this project, it's quite a capable machine.

From here, you can explore [Docker Hub](https://hub.docker.com/) to find new and exiting applications to run on your Pi. You can visit [Composerize](https://www.composerize.com/) to help you turn `docker run` commands into docker-compose.yml files and run them as stacks. You can even read up on the syntax of the [Dockerfile](https://docs.docker.com/engine/reference/builder/) and build your own containers.

It's your Pi, run whatever you want.

___

_The best conversation I had was over forty million years ago…. And that was with a coffee machine. &mdash;Marvin the Android_
