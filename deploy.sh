#!/bin/bash

cd ~
mkdir app
cd app/baucortComprasBackend && git pull
cd app/baucortFrontend && git pull

docker-compose up -d --build 