function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char \u276f\u276f
      case '*'
        set -g __fish_prompt_char »
    end
  end


  # Setup colors
  set -l normal (set_color normal)
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l bpurple (set_color -o purple)
  set -l bred (set_color -o red)
  set -l bcyan (set_color -o cyan)
  set -l bwhite (set_color -o white)

  # Configure __fish_git_prompt
  set -g __fish_git_prompt_use_informative_chars true
  set -g __fish_git_prompt_showcolorhints true

  # Color prompt char red for non-zero exit status
  set -l pcolor $bpurple
  if [ $last_status -ne 0 ]
    set pcolor $bred
  end

  # pieces of the prompt
  set -l p_user $USER
  set -l p_host $__fish_prompt_hostname
  set -l p_pwd (prompt_pwd)
  set -l p_git (__fish_git_prompt | sed -e 's/^[[:space:]]*//')  # remove leading space https://stackoverflow.com/a/3232433/1412255 

  set -l full_length (string length "$p_user at $p_host in $p_pwd $p_git")
  set -l med_length (string length "$p_pwd $p_git")

  if test $COLUMNS -gt $full_length 
  # Top
    echo -n $cyan$p_user$normal at $yellow$p_host$normal in $bred$p_pwd$normal $p_git
    echo
  else if test $COLUMNS -gt $med_length
    echo -n $bred$p_pwd$normal $p_git
    echo
  end
  # Bottom
  echo -n $pcolor$__fish_prompt_char $normal
end
