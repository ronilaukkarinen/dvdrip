# dvdrip.sh
## A killer way to backup a DVD

Useful bash script for making mkv files with multiple subtitles and audio tracks out of old school DVD disc. Extremely handy for backing up films to [Plex Home Theater](http://www.plex.tv).

Tested with Mac OS X Yosemite (10.10.3).

### Requirements

- Python 2.6
- Mac OS X or Linux
- lsdvd
- mplayer
- mencoder with xvid support (usually included with mplayer-devel)
- ogmtools (for dvdxchap)
- mkvtoolnix (for mkvmerge)
- transcode (for subtitle2vobsub)
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