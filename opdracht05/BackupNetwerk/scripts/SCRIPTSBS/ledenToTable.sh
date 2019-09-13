#!/bin/sh
# abort on nonzero exitstatus
set -o errexit
# abort on unbound variable
set -o nounset
# don't mask errors in piped commands
set -o pipefail
echo "$(date +"%Y-%m-%d %T") STARTING MAINTENANCE SCRIPT "
mysql --user=root --password=root db_leden <<_EOF_
LOAD DATA INFILE '/home/DATABANK/leden.csv' 
	INTO TABLE leden
	FIELDS ENCLOSED BY '"' 
	TERMINATED BY ';' 
	ESCAPED BY '"' 
	LINES TERMINATED BY '\r\n';
_EOF_
echo "$(date +"%Y-%m-%d %T") SUCCESS >> TABLE ALTERED"
echo "$(date +"%Y-%m-%d %T") ENDING MAINTENANCE SCRIPT "