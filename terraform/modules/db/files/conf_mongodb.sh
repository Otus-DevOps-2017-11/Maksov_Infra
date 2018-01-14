#!/bin/bash
sudo mv /tmp/mongod.conf /etc/mongod.conf
sudo systemctl restart mongod
