#!/bin/bash

cd ~/BaucortCloudCentral
cd app/baucortComprasBackend && git pull
cd app/baucortFrontend && git pull

docker-compose up -d --build 