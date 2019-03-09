# bash-scripts-and-config
Useful bash scripts and configuration files

#### Directory Structure
The directory structure could use a little explaining, ...<br>
scripts/ - useful scripts for working in a UNIX like environment, should all be self contained, only dependent on installed applications<br>
dots/ - dot files (minus the dot) for controlling the behavior of the shell and other applications<br>
configs/ - other config files for controlling the behavior of applications, these may just be snippets

The files in this project support Windows 10, OS/X, Ubuntu and Debian as best they can as these are the OSs that I currently have access to. You might find that FreeBSD, RHEL and a few others are also fairly well supported as I used to have access to them.

#### Using These Files
There are two scripts in the root of this repo (configure.sh and install-deps.sh) that can be used to create symbolic links to the other files as appropriate. Basically, it'll create links in ~/bin for all the scripts and links in ~/ for all the dot files.
<pre>
  git clone git@github.com:forbesrodney/bash-scripts-and-configs.git
  cd bash-scripts-and-configs
  ./install-deps.sh
  ./configure.sh [--test] [profile]
</pre>
Curently the only profiles defined are home and work, and only the main .gitconfig is different between them
