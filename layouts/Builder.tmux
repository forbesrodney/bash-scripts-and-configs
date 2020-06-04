# |-------------| |-------------| |-------------|
# |      |      | |             | |             |
# |  svbuilder  | |   docker    | |   docker    |
# |      |      | |    (3.1)    | |  (master)   |
# |-------------| |-------------| |-------------|

# Three windows, 1 split horizontal, 2 full screen

# How do we negate
#%if #{&&:#{DISPLAY},#{==:DASDevBldr,#{host_short}}}

# This layout should only be used on DASDevBldr
%if #{==:DASDevBldr,#{host_short}}
  # Configure a window outside the docker container
  rename-window svbuilder

  # Configure some default panes for running the builds
  split-window -h

  # Return to window 0, pane 0
  select-window -t 0
  select-pane -t 0

  # Configure a window inside the docker container
  source ~/.tmux/layouts/Docker.inc
%endif

