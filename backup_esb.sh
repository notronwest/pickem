#!/bin/bash
# EBS Snapshot volume script
# Written by Star Dot Hosting
# www.stardothosting.com

# Constants
EC2_BIN="/opt/ec2-api-tools-1.6.5.1"
#my_cert="/opt/aws/cert.txt"
#my_key="/opt/aws/key.txt"
AWS_ACCESS_KEY = "AKIAICEKAHVZTOR6UNEQ"
AWS_SECRET_KEY = "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"
instance_id=`wget -q -O- http://169.254.169.254/latest/meta-data/instance-id`

# Dates
datecheck_7d=`date +%Y-%m-%d --date '7 days ago'`
datecheck_s_7d=`date --date="$datecheck_7d" +%s`

# Get all volume info and copy to temp file
$EC2_BIN/ec2-describe-volumes -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY --filter "attachment.instance-id=$instance_id" > /tmp/volume_info.txt 2>&1

# Get all snapshot info 
$EC2_BIN/ec2-describe-snapshots -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY | grep "$instance_id" > /tmp/snap_info.txt 2>&1

# Loop to remove any snapshots older than 7 days
for obj0 in $(cat /tmp/snap_info.txt)
do

        snapshot_name=`cat /tmp/snap_info.txt | grep "$obj0" | awk '{print $2}'`
        datecheck_old=`cat /tmp/snap_info.txt | grep "$snapshot_name" | awk '{print $5}' | awk -F "T" '{printf "%sn", $1}'`
        datecheck_s_old=`date --date=$datecheck_old" +%s`

#       echo "snapshot name: $snapshot_name"
#       echo "datecheck 7d : $datecheck_7d"
#       echo "datecheck 7d s : $datecheck_s_7d"
#       echo "datecheck old s: $datecheck_s_old"

        if (( $datecheck_s_old <= $datecheck_s_7d ));
        then
                echo "deleting snapshot $snapshot_name ..."
                $EC2_BIN/ec2-delete-snapshot -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY $snapshot_name 
        else
                echo "not deleting snapshot $snapshot_name ..."
                
        fi

done

# Create snapshot
for volume in $(cat /tmp/volume_info.txt | grep "VOLUME" | awk '{print $2}')
do
        description="`hostname`_backup-`date +%Y-%m-%d`"
        echo "Creating Snapshot for the volume: $volume with description: $description"
        $EC2_BIN/ec2-create-snapshot -O $AWS_ACCESS_KEY -W $AWS_SECRET_KEY -d $description $volume
done