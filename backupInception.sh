#! /bin/bash

# This scriot backs up the inception MariaDb and the inception dir to a specified# directory

# Process the arguments
helpText="Usage: $0 -b --basedir=backupDir -p --password=sqlpassword -i --inceptiondir=inception directory"
if [[ $# -ne 3 ]]; then
    echo ${helpText} >&2
    exit 2
fi

for i in "$@"; do
  case $i in
#   The basedir in which to create the new backup directory
    -b=*|--basedir=*)
      BASEDIR="${i#*=}"
      shift # past argument=value
      ;;
#   The inception dir from which to copy files
    -i=*|--inceptiondir=*)
      INCEPTIONDIR="${i#*=}"
      shift # past argument=value
      ;;
#   The password to use in the mysqldump command
    -p=*|--password=*)
      PASSWORD="${i#*=}"
      shift # past argument=value
      ;;
    *)
      # unknown option
      ;;
  esac
done

echo "base directory      = ${BASEDIR}"
echo "mysqldump password  = ${PASSWORD}"
echo "inception directory = ${INCEPTIONDIR}"

# Get the date in ddmmyyyy format
date=`date +%d%m%y`

# make the backup directory
thisBackupDir=${BASEDIR}/"inception-backup-"${date}
echo $thisBackupDir
mkdir -p $thisBackupDir

# create the dump file name
thisSQLfile=${thisBackupDir}/"inception-backup-"${date}".sql"

# Execute the mysqldump command and zip the results
/usr/bin/mysqldump -u inception -p${PASSWORD} --all-databases > ${thisSQLfile}
/usr/bin/gzip ${thisSQLfile}

# Now copy some artifacts from the Inception direcory to the backup directory
/usr/bin/cp ${INCEPTIONDIR}"/inception.conf" ${thisBackupDir}
/usr/bin/cp ${INCEPTIONDIR}"/inception.log" ${thisBackupDir}
/usr/bin/cp ${INCEPTIONDIR}"/inception.jar" ${thisBackupDir}
/usr/bin/cp ${INCEPTIONDIR}"/settings.properties" ${thisBackupDir}
/usr/bin/cp -r ${INCEPTIONDIR}"/log" ${thisBackupDir}
/usr/bin/cp -r ${INCEPTIONDIR}"/repository" ${thisBackupDir}
