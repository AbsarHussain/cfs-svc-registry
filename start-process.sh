#!/bin/bash
sudo service apache2 stop
java -jar /tmp/cfs-service-registry-0.0.1-SNAPSHOT.jar > /dev/null 2> /dev/null < /dev/null &