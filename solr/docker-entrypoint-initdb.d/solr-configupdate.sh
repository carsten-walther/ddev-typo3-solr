#!/usr/bin/env bash
#ddev-generated
set -e

# Ensure "dev" (or alternate SOLR_CORENAME) core config is always up to date even after the
# core has been created. This does not execute the first time,
# when solr-precreate has not yet run.

if [ -d /var/solr/data/configsets ]; then
    cp -r conf/configsets /var/solr/data/configsets
fi

if [ -d /var/solr/data/solr.xml ]; then
    cp conf/solr.xml /var/solr/data/solr.xml
fi

cp -r conf/cores /var/solr/data/
