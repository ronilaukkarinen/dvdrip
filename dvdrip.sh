#!/bin/bash

# dvdrip - A killer way to backup a DVD
# Based on: http://aperiodic.net/phil/archives/Geekery/lossless-dvd-to-mkv.html

# Bash base variables:

boldyellow=${txtbold}$(tput setaf 3)
txtreset=$(tput sgr0)
boldgreen=${txtbold}$(tput setaf 2)

# Optional mount - not necessary if you have a DVD drive attached

# mkdir /mnt/dvdiso
# mount -o loop -t iso9660 my.iso /mnt/dvdiso/

echo "${boldyellow}Track number (default: 1, check this with HandBrake GUI app):${txtreset} "
read -e TRACK
TRACK=1

echo "${boldyellow}Movie title:${txtreset}"
read -e MOVIE_TITLE

echo "${boldyellow}DVD volume path (without trailing slash, for example /Volumes/MOVIE):${txtreset}"
read -e DVD_PATH

echo "${boldyellow}Dump path location without trailing slash:${txtreset} (default: /Users/rolle/Projects/dvdrip/dumpfiles)"
read -e DUMP_PATH
DUMP_PATH="/Users/rolle/Projects/dvdrip/dumpfiles"

echo "${boldyellow}Output path location without trailing slash:${txtreset} (default: /Users/rolle/Projects/dvdrip/output)"
read -e OUTPUT_PATH
OUTPUT_PATH="/Users/rolle/Projects/dvdrip/output"

# Variables - comment out previous and uncomment next lines if you prefer the manual way.

#TRACK=2
#DVD_PATH="/Volumes/MOVIE"
#DUMP_PATH="/Users/rolle/Projects/dvdrip/dumpfiles/"
#OUTPUT_PATH="/Users/rolle/Projects/dvdrip/output/"
#MOVIE_TITLE="Movie title here"

echo "${boldgreen}Ripping out main title track...${txtreset}"
tccat -i $DVD_PATH -t dvd -T ${TRACK},-1 > $DUMP_PATH/movie.vob

echo "${boldgreen}Getting the title chapters...${txtreset}"
dvdxchap -t $TRACK $DVD_PATH > $DUMP_PATH/chapters.txt

echo "${boldgreen}Checking the track for stream match...${txtreset}"
mplayer -dvd-device $DVD_PATH -vo null -ao null -frames 0 -v dvd://${TRACK} 2>&1 | egrep '[as]id' > $DUMP_PATH/${TRACK}.streams

echo "${boldgreen}Pulling out individual components, video first...${txtreset}"
tcextract -i $DUMP_PATH/movie.vob -t vob -x mpeg2 > $DUMP_PATH/${TRACK}.video.m2v

echo "${boldgreen}Getting audio tracks...${txtreset}"
tcextract -i $DUMP_PATH/movie.vob -t vob -x ac3 -a 0,1,2,3,4,5,6,7,8,9 > $DUMP_PATH/audio.ac3

echo "${boldgreen}Getting subtitles...${txtreset}"
tcextract -i $DUMP_PATH/movie.vob -t vob -x ps1 -a 0x20,0x21,0x22,0x23,0x24 > $DUMP_PATH/subs.raw
subtitle2vobsub -p $DUMP_PATH/subs.raw -i $DVD_PATH/VIDEO_TS/VTS_0${TRACK}_0.IFO -o $DUMP_PATH/subs

echo "${boldgreen}Finally merging everything together as one mkv file...${txtreset}"

mkvmerge -o "$MOVIE_TITLE.mkv" --title "$MOVIE_TITLE" --chapters $DUMP_PATH/chapters.txt $DUMP_PATH/${TRACK}.video.m2v $DUMP_PATH/audio.ac3 $DUMP_PATH/subs

echo "${boldgreen}Done! :) Movie ready in $OUTPUT_PATH/$MOVIE_TITLE.mkv${txtreset}"