#!/bin/sh -e

# The version of PostgreSQL
PG_VERSION=8.4

export DEBIAN_FRONTEND=noninteractive

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  exit
fi

PG_REPO_APT_SOURCE=/etc/apt/sources.list.d/pgdg.list
if [ ! -f "$PG_REPO_APT_SOURCE" ]
then
  # Add PG apt repo:
  echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > "$PG_REPO_APT_SOURCE"

  # Add PGDG repo key:
  curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
fi

# Update package list
apt-get update

# Inspall PostgreSQL
apt-get -y install "postgresql-$PG_VERSION" "postgresql-contrib-$PG_VERSION"

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

# Tag the provision time:
date > "$PROVISIONED_ON"

# Result message
echo "Successfully install PostgreSQL $PG_VERSION"
echo ""
echo "Dir: $PG_DIR"
echo "Conf: $PG_CONF"
echo "HBA conf: $PG_HBA"
