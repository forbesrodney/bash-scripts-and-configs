# |-------------| |-------------|
# |      |      | |      |      |
# |      -------| |-------------|
# |      |      | |      |      |
# |-------------| |-------------|

# How do we negate
#%if #{&&:#{DISPLAY},#{==:forbesr-svbuilder,#{host_short}}}

# This layout should only be used on forbesr-svbuilder
%if #{==:forbesr-dev,#{host_short}}
  # Configure some default panes for development
  split-window -h
  split-window -v

  # Configure a window for Linux Kernel Labs
  source Linux_Kernel_Labs.inc

  # Return to window 0, pane 0
  select-window -t 0
  select-pane -t 0
%endif

