#!/bin/bash

# dvdrip - A killer way to backup a DVD
# Based on: http://www.alundgren.se/2013/11/18/iso-to-mkv-in-linux/

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

echo "${boldgreen}Now, to getting some information about the media...${txtreset}"
mplayer -dvd-device $DVD_PATH dvd://1 -vo null -ao null

echo "${boldgreen}Also getting the length of the titles...${txtreset}"
mplayer -dvd-device $DVD_PATH dvd://1 -identify -frames 0 -vo null -ao null

echo "${boldgreen}Finding the track you want to rip and running it through mplayer and generating raw .vob file...${txtreset}"
mplayer -dvd-device $DVD_PATH dvd://$TRACK -dumpstream -dumpfile $DUMP_PATH/movie.vob

echo "${boldgreen}Copying the IFO file for the track...${txtreset}"
cp $DVD_PATH/VIDEO_TS/VTS_0${TRACK}_0.IFO $DUMP_PATH/

echo "${boldgreen}Getting the chapter list...${txtreset}"
dvdxchap -t $TRACK $DVD_PATH > $DUMP_PATH/chapters.txt

echo "${boldgreen}Getting all the subtitles...${txtreset}"
tccat -i $DUMP_PATH/movie.vob | tcextract -x ps1 -t vob -a 0x20 > $DUMP_PATH/subs-0
tccat -i $DUMP_PATH/movie.vob | tcextract -x ps1 -t vob -a 0x21 > $DUMP_PATH/subs-1
tccat -i $DUMP_PATH/movie.vob | tcextract -x ps1 -t vob -a 0x22 > $DUMP_PATH/subs-2
tccat -i $DUMP_PATH/movie.vob | tcextract -x ps1 -t vob -a 0x23 > $DUMP_PATH/subs-3
tccat -i $DUMP_PATH/movie.vob | tcextract -x ps1 -t vob -a 0x24 > $DUMP_PATH/subs-4
subtitle2vobsub -o $DUMP_PATH/vobsubs -i $DUMP_PATH/VTS_0${TRACK}_0.IFO -a 0 < $DUMP_PATH/subs-0
subtitle2vobsub -o $DUMP_PATH/vobsubs -i $DUMP_PATH/VTS_0${TRACK}_0.IFO -a 1 < $DUMP_PATH/subs-1
subtitle2vobsub -o $DUMP_PATH/vobsubs -i $DUMP_PATH/VTS_0${TRACK}_0.IFO -a 2 < $DUMP_PATH/subs-2
subtitle2vobsub -o $DUMP_PATH/vobsubs -i $DUMP_PATH/VTS_0${TRACK}_0.IFO -a 3 < $DUMP_PATH/subs-3
subtitle2vobsub -o $DUMP_PATH/vobsubs -i $DUMP_PATH/VTS_0${TRACK}_0.IFO -a 4 < $DUMP_PATH/subs-4

echo "${boldgreen}Now, ripping the audio using the AID we got from mplayer earlier...${txtreset}"
mplayer $DUMP_PATH/movie.vob -aid 128 -dumpaudio -dumpfile $DUMP_PATH/audio128.ac3

echo "${boldgreen}Determining cropping parameters...${txtreset}"
mplayer $DUMP_PATH/movie.vob -vf cropdetect -sb 50000000 -vo null -ao null

echo "${boldgreen}Recording detected cropping parameters...${txtreset}"
./bitrate.py -o 0.5 -t 1400 1:42:04 $DUMP_PATH/audio128.ac3 $DUMP_PATH/vobsubs.idx $DUMP_PATH/vobsubs.sub

echo "${boldgreen}Now encoding in two passes...${txtreset}"
echo "${boldgreen}Encoding pass 1...${txtreset}"
mencoder $DUMP_PATH/movie.vob -vf pullup,softskip,crop=704:480:10:48,harddup -oac copy -ovc x264 -x264encopts bitrate=1690:subq=5:bframes=3:weight_b:threads=auto:pass=1 -ofps 25 -o /dev/null

echo "${boldgreen}Encoding pass 2...${txtreset}"
mencoder $DUMP_PATH/movie.vob -vf pullup,softskip,crop=704:480:10:48,harddup -oac copy -ovc x264 -x264encopts bitrate=1690:subq=5:8x8dct:frameref=2:bframes=3:weight_b:threads=auto:pass=2 -o $DUMP_PATH/movie.264

echo "${boldgreen}Finally merging everything together as one mkv file...${txtreset}"
mkvmerge --title $MOVIE_TITLE -o "$OUTPUT_PATH/$MOVIE_TITLE.mkv" --chapters $DUMP_PATH/chapters.txt --default-duration 0:25fps -A $DUMP_PATH/movie.264 $DUMP_PATH/audio128.ac3 $DUMP_PATH/vobsubs.idx

echo "${boldgreen}Done! :) Movie ready in $OUTPUT_PATH/$MOVIE_TITLE.mkv${txtreset}"