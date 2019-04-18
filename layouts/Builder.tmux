# |-------------| |-------------| |-------------|
# |             | |             | |             |
# |  svbuilder  | |   docker    | |   minicom   |
# |             | |             | |             |
# |-------------| |-------------| |-------------|

# Three large screens

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-svbuilder,#{host_short}}}

# This layout should only be used on forbesr-svbuilder
%if #{==:forbesr-svbuilder,#{host_short}}
  # Configure a window outside the docker container
  rename-window svbuilder

  # Return to window 0, pane 0
  select-window -t 0
  select-pane -t 0

  # Configure a window inside the docker container
  source ~/.tmux/layouts/Docker.inc

  # Configure a window to run minicom
  source ~/.tmux/layouts/Minicom.inc
%endif
