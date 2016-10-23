#!/bin/bash

ARCHIVES_SPACE_VERSION=1.5.1
ARCHIVES_SPACE_ROOT=/home
ARCHIVES_SPACE_DIR=$ARCHIVES_SPACE_ROOT/archivesspace
ARCHIVES_SPACE_TMP=$ARCHIVES_SPACE_ROOT/archivesspace.updating
ARCHIVES_SPACE_BACKUP=$ARCHIVES_SPACE_ROOT/backups

/etc/init.d/archivesspace stop
rm -f $ARCHIVES_SPACE_DIR/data/indexer_state/*
rm -f $ARCHIVES_SPACE_DIR/data/solr_index/index/*
mv $ARCHIVES_SPACE_DIR $ARCHIVES_SPACE_DIR.updating
cd $ARCHIVES_SPACE_ROOT
wget https://github.com/archivesspace/archivesspace/releases/download/v$ARCHIVES_SPACE_VERSION/archivesspace-v$ARCHIVES_SPACE_VERSION.zip
unzip archivesspace-v"$ARCHIVES_SPACE_VERSION".zip
rm -f archivesspace-v"$ARCHIVES_SPACE_VERSION".zip
mv $ARCHIVES_SPACE_DIR/config/config.rb $ARCHIVES_SPACE_DIR/config/config.rb.new
cp -af $ARCHIVES_SPACE_TMP/data/* $ARCHIVES_SPACE_DIR/data/
cp -af $ARCHIVES_SPACE_TMP/config/* $ARCHIVES_SPACE_DIR/config/
cp -af $ARCHIVES_SPACE_TMP/lib/mysql-connector* $ARCHIVES_SPACE_DIR/lib/
cp -af $ARCHIVES_SPACE_TMP/plugins/local/* $ARCHIVES_SPACE_DIR/plugins/local/
cd $ARCHIVES_SPACE_DIR
/bin/bash scripts/setup-database.sh
/etc/init.d/archivesspace start
