if test -f ~/.fishrc
    source ~/.fishrc
end

if status is-interactive; and test $COLUMNS -ge 110; and test $LINES -ge 35
    fastfetch
end

if status is-interactive
# Commands to run in interactive sessions can go here
end
