#!/bin/bash

git pull
cd ~/BaucortCloudCentral/baucortComprasBackend && git pull
cd ~/BaucortCloudCentral/baucortFrontend && git pull

docker-compose up -d --build 