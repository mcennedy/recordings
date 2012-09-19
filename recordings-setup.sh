#!/bin/bash

if [ -z $1 ] ; then echo 'pass a conf file as argument. exit.'; exit 0; fi

echo "contents of config file: $1"

title=''
base_dir=''
stream_dir=''
cover_dir=''
log_dir=''
stream_format=''
stream_url=''
cover_url=''
cover_path=''
station_url=''
metadata_script=''
length_in_minutes=''

while read i ; do
 
  j=$(echo $i|cut -d'=' -f1)
#echo $j

 if [ "$j" = "title" ] ; then
  base_dir=$(echo $i|cut -d'=' -f2|sed 's/ /-/g'| tr '[:upper:]' '[:lower:]')
  title=$(echo $i|cut -d'=' -f2|sed 's/-/ /g'| tr '[:lower:]' '[:upper:]')
  echo "creating directory... $base_dir"
  mkdir $base_dir
  
 fi



 if [ "$j" = "stream_url" ] ; then
  stream_url=$(echo $i|cut -d'=' -f2)
  echo "testing stream... $url"
  streamripper $stream_url --quiet -d $base_dir -a "test" -A -l 3


  if [ -e "$base_dir/test.aac" ] ; then
   echo "got aac file."
   stream_format='aac'
   stream_dir='aac'
  fi

  if [ -e "$base_dir/test.mp3" ] ; then
   echo "got mp3 file."
   stream_format='mp3'
   stream_dir='mp3'
  fi

  rm "$base_dir/test.aac" "$base_dir/test.cue" "$base_dir/test.mp3"

  mkdir "$base_dir/$stream_dir"

 fi

 if [ "$j" = "cover_url" ] ; then
  cover_url=$(echo $i|cut -d'=' -f2)
  format=$(echo $cover_url|cut -d'.' -f4)
  echo "cover format: $format"
  cover_dir=$format
  mkdir "$base_dir/$cover_dir"
  cover_path="$base_dir/$cover_dir/null.$format"
  echo "downloading cover to... $cover_path"
  curl -o $cover_path $cover_url
 fi

 if [ "$j" = "station_url" ] ; then
  station_url=$(echo $i|cut -d'=' -f2)
  echo "station url: $station_url"
 fi

 if [ "$j" = "metadata_script" ] ; then
  metadata_script=$(echo $i|cut -d'=' -f2)
  echo "metadata script: $metadata_script"
 fi


 if [ "$j" = "length_in_minutes" ] ; then
  length_in_minutes=$(echo $i|cut -d'=' -f2)
  echo "length_in_minutes: $length_in_minutes"
 fi


done < $1

log_dir="log"
mkdir "$base_dir/$log_dir"


echo 'summary:'
echo ''
echo "base_dir        : $base_dir"
echo "stream_dir      : $base_dir/$stream_dir"
echo "cover_dir       : $base_dir/$cover_dir"
echo "log_dir         : $base_dir/$log_dir"
echo "stream_format   : $stream_format"
echo "stream_url      : $stream_url"
echo "cover_url       : $cover_url"
echo "cover_path      : $cover_path"
echo "station_url     : $station_url"

echo ''



echo "title=$title" > "$base_dir.conf"
echo "base_dir=$base_dir" >> "$base_dir.conf"
echo "stream_dir=$base_dir/$stream_dir" >> "$base_dir.conf"
echo "cover_dir=$base_dir/$cover_dir" >> "$base_dir.conf"
echo "log_dir=$base_dir/$log_dir" >> "$base_dir.conf"
echo "stream_format=$stream_format" >> "$base_dir.conf"
echo "stream_url=$stream_url" >> "$base_dir.conf"
echo "cover_url=$cover_url" >> "$base_dir.conf"
echo "cover_path=$cover_path" >> "$base_dir.conf"
echo "station_url=$station_url" >> "$base_dir.conf"
echo "length_in_minutes=$length_in_minutes" >> "$base_dir.conf"
echo "metadata_script=$metadata_script" >> "$base_dir.conf"

echo 'finish.'