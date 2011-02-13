#!/bin/sh

# TO DO : check to see that we are the postgres user here
# TO DO: (optional) password hooks

if [ $# -ne 2 ]; then
        echo "Usage: $0 <user name> <database name>";
        exit;
fi;

USERNAME=$1
DATABASE=$2

createuser --no-superuser --no-createdb --no-createrole $USERNAME;
createdb --owner=$USERNAME $DATABASE;
createlang plpgsql $DATABASE;

psql -f lwpostgis-8.3.sql $DATABASE;
psql -f spatial_ref_sys-8.3.sql $DATABASE;
psql -f spatial_ref_900913-8.3.sql $DATABASE;

# TO DO: find the 8.3 _int.sql and include it here

echo "ALTER TABLE geometry_columns OWNER TO $USERNAME;" | psql $DATABASE;
echo "ALTER TABLE spatial_ref_sys OWNER TO $USERNAME;" | psql $DATABASE;