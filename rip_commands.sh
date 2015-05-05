# This file is for backup purposes only.

# Blu-ray:

HandBrakeCLI -i /Volumes/MOVIE -o "Movie name.mkv" -m -E copy --audio-copy-mask ac3,dts,dtshd --audio-fallback ffac3 -e x264 -q 20 -x level=4.1:ref=4:b-adapt=2:direct=auto:me=umh:subq=8:rc-lookahead=50:psy-rd=1.0,0.15:deblock=-1,-1:vbv-bufsize=30000:vbv-maxrate=40000:slices=4 -a 1,2,3,4 -s 1,2,3,4

# DVD (the old way, not necessarily working), use dvdrip.sh for better results:

cd /Volumes/MOVIE && HandBrakeCLI -i VIDEO_TS -o ~/mydvd.mp4 -e x264 -q 20 -w 720 -l 480 --display-width 854 -B 160 -a 1,2,3,4 -s 1,2,3,4

# Remember to check which is the main movie track and set -t hook by it. For example if the main track is 2, use:

HandBrakeCLI -t 2 -i /Volumes/MOVIE -o "Movie name.mp4" -e x264 -b 1000 -B 192 -a 1,2,3,4 -s 1,2,3,4