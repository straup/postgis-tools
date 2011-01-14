#!/bin/sh

if [ $# -ne 2 ]; then
        echo "Usage: $0 <user name> <database name>";
        exit;
fi;

USERNAME=$1
DATABASE=$2

createuser --no-superuser --no-createdb --no-createrole $USERNAME;
createdb --owner=$USERNAME $DATABASE;
createlang plpgsql $DATABASE;

psql -f lwpostgis.sql $DATABASE;
psql -f spatial_ref_sys.sql $DATABASE;
psql -f 900913.def $DATABASE;

echo "ALTER TABLE geometry_columns OWNER TO $USERNAME;" | psql $DATABASE;
echo "ALTER TABLE spatial_ref_sys OWNER TO $USERNAME;" | psql $DATABASE;