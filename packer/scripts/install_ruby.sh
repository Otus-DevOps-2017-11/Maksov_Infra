#!/bin/bash
set -e

# Install ruby
apt update
apt install -y ruby-full ruby-bundler build-essential
apt install python-apt
