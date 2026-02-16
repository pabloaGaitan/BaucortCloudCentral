#!/bin/bash

cd ~/BaucortCloudCentral/baucortComprasBackend && git pull
cd ~/BaucortCloudCentral/baucortFrontend && git pull
cd ~/BaucortCloudCentral

docker-compose up -d --build 