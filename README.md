# dvdrip.sh
## A killer way to backup a DVD

**This is an experiment and probably doesn't work because of the old and inaccurrate commands. Blu-ray command in `rip_commands.sh` is tested working on Linux.** Most probably best to go with [MakeMKV](http://www.makemkv.com/) or [Handbrake](https://handbrake.fr/) GUI to get progressbar (ripping discs can take a long time).

dvdrip.sh is originally a bash script for making mkv files with multiple subtitles and audio tracks out of old school DVD disc. Extremely handy for backing up films to [Plex Home Theater](http://www.plex.tv). Also good for learning what is happening during the process.

This bash script will output a lossless quality DVD rip with a size proximately from 1 gigabytes to 4 depending on the length and quality of the original DVD.

[MakeMKV](http://www.makemkv.com/) or [Handbrake](https://handbrake.fr/) does the same and better, but on non-GUI systems and for old-school hackers a bash script can be a better choice.

Last [dvdrip.sh](https://raw.githubusercontent.com/ronilaukkarinen/dvdrip/2f67dcb6587dab67eb51e0b38f5f10a5a7f0049c/dvdrip.sh) tested working with OS X Yosemite, but with audio/sub not in sync.

### Requirements

- Python 2.6
- Mac OS X or Linux
- lsdvd
- mplayer
- mencoder with xvid support (usually included with mplayer-devel)
- ogmtools (for dvdxchap)
- mkvtoolnix (for mkvmerge)
- transcode
- subtitleripper (for subtitle2vobsub)
- tccat (smallshrink for Mac OS X)

#### Mac OS X

You can install most of these with [MacPorts](http://www.macports.org) and the rest with [Homebrew](http://brew.sh).

To get mencoder to work properly, use `sudo port install mplayer-devel && sudo port upgrade --enforce-variants mplayer-devel +mencoder_extras`

For `tccat` you will need [smallshrink](https://code.google.com/p/smallshrink/) and to symlink tccat with `ln -s /Applications/SmallShrink.app/Contents/Resources/tccat /usr/local/bin/tccat` and make it executable by `sudo chmod +x /usr/local/bin/tccat`.

#### Linux

Most of the package repositories have these packages by default.

#### Windows

Sorry, but no.

### Usage

1. Clone this repository
2. Run `sh dvdrip.sh` or make global by `sudo cp /path/to/dvdrip.sh /usr/local/bin/dvdrip` and run `dvdrip`