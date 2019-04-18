# |-------------| |-------------|
# |      |      | |      |      |
# |      -------| |-------------|
# |      |      | |      |      |
# |-------------| |-------------|

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-dev,#{host_short}}}

# This layout should only be used on forbesr-dev
%if #{==:forbesr-dev,#{host_short}}
  # Configure some default panes for development
  split-window -h
  split-window -v

  # Return to window 0, pane 0
  select-window -t 0
  select-pane -t 0

  # Configure a window for Linux Kernel Labs
  source ~/.tmux/layouts/Linux_Kernel_Labs.inc
%endif

