# |-------------| |-------------| |-------------|
# |             | |             | |             |
# |  svbuilder  | |   docker    | |   minicom   |
# |             | |             | |             |
# |-------------| |-------------| |-------------|

# Three large screens

#set -g status off

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-svbuilder,#{host_short}}}

# This layout should only be used on forbesr-svbuilder
%if #{==:forbesr-svbuilder,#{host_short}}
  # Configure a window outside the docker container
  rename-window svbuilder

  # Configure a window inside the docker container
  new-window
  rename-window docker
  send-keys 'cd ~/Development/buildbot-scripts' Enter
  send-keys 'OS_VERSION=64 make debug_svbuilder' Enter

  # Configure a window to run minicom
  new-window
  rename-window minicom
  send-keys 'minicom' Enter

  # Return to window 0, pane 0
  select-window -t 0
  select-pane -t 0
%endif
