#!/bin/sh -e
export OPENNMS_RPM_ROOT=/tmp/docker_bamboo
mkdir -p $OPENNMS_RPM_ROOT
pushd $OPENNMS_RPM_ROOT

PLAN_KEY="OPENNMS-ONMS1240"
BUILD_ID="2"
RPM_VERSION="19.0.0-0.20170114.onms1240.features.strict.attribute.types.2"

rm -f *.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-$RPM_VERSION.noarch.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-core-$RPM_VERSION.noarch.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-minion-$RPM_VERSION.noarch.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-minion-container-$RPM_VERSION.noarch.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-minion-features-core-$RPM_VERSION.noarch.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-minion-features-default-$RPM_VERSION.noarch.rpm
wget http://bamboo.internal.opennms.com:8085/artifact/$PLAN_KEY/shared/build-$BUILD_ID/RPMs/opennms-webapp-jetty-$RPM_VERSION.noarch.rpm

pushd /home/jesse/git/opennms-system-test-api/docker
./copy-rpms.sh
./build-docker-images.sh