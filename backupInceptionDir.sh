#! /bin/bash

# This script backs up the inception dir to a specified directory

# Process the arguments
helpText="Usage: $0 -b --basedir=backupDir -i --inceptiondir=inception directory"
if [[ $# -ne 2 ]]; then
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
    *)
      # unknown option
      ;;
  esac
done

echo "base directory      = ${BASEDIR}"
echo "inception directory = ${INCEPTIONDIR}"

# Get the date in ddmmyyyy format
date=`date +%d%m%y`

# make the backup directory
thisBackupDir=${BASEDIR}/"inception-backup-"${date}
thisBackupTarFile=${BASEDIR}/"inception-backup-"${date}.tar.gz
echo $thisBackupDir
mkdir -p $thisBackupDir

# Now copy some artifacts from the Inception direcory to the backup directory
/usr/bin/cp ${INCEPTIONDIR}"/inception.conf" ${thisBackupDir}
/usr/bin/cp ${INCEPTIONDIR}"/inception.log" ${thisBackupDir}
/usr/bin/cp ${INCEPTIONDIR}"/inception.jar" ${thisBackupDir}
/usr/bin/cp ${INCEPTIONDIR}"/settings.properties" ${thisBackupDir}
/usr/bin/cp -r ${INCEPTIONDIR}"/log" ${thisBackupDir}
/usr/bin/cp -r ${INCEPTIONDIR}"/repository" ${thisBackupDir}

/usr/bin/tar -czf ${thisBackupTarFile} ${thisBackupDir}
/usr/bin/rm -rf ${thisBackupDir}
