#!/bin/bash
set -e

# Install ruby
apt update
apt install -y ruby-full ruby-bundler build-essential
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install
cp /tmp/puma.service /etc/systemd/system/
systemctl enable puma.service
