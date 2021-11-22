# Deploying a Home Automation Stack
TODO

## Can I Skip It?
You don't have to install the home automation stack. It's completely optional. If you choose to deploy it, you don't have to invest in a bunch of "smart" devices. You can start small with some passive home monitoring and go from there.

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

## Finding Configuration Help
TODO

## Next Steps
TODO
