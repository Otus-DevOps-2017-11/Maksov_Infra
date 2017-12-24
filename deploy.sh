#!/bin/sh
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install
cd ~
puma -d
