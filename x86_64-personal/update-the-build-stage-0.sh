#!/usr/bin/env bash

docker stop cocalc-test-personal
docker rm cocalc-test-personal

set -ex

export BRANCH="${BRANCH:-master}"
echo "BRANCH=$BRANCH"
commit=`git ls-remote -h https://github.com/arsalen-y/cocalc $BRANCH | awk '{print $1}'`
echo $commit | cut -c-12 > current_commit
time docker build --build-arg U_ID=1002280001 --build-arg G_ID=1002280001 --build-arg commit=$commit --build-arg BRANCH=$BRANCH --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') -f ../Dockerfile-personal -t cocalc-personal $@ ..
docker tag cocalc-personal:latest sagemathinc/cocalc-v2-personal:latest
docker tag cocalc-personal:latest sagemathinc/cocalc-v2-personal:`cat current_commit`
docker tag cocalc-personal:latest build.yields.io/chiron-enterprise/cocalc-v2-personal:dev