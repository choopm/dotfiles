zsh-realpath() { for f in "$@"; do echo ${f}(:A); done }

disambiguate-keeplast() {
# this is a modification of Mikachu's disambiguate-keeplast, adding support for
# an argument to use instead of PWD, and a second argument which is used as a
# prefix for globbing, but is not part of the disambiguated path.
#
# usage:
# disambiguate-keeplast /usr/share/zsh/function ; echo $REPLY
# -> /u/sh/zs/function
# disambiguate-keeplast zsh/function /usr/share/ ; echo $REPLY
# -> zs/function
#
# short holds the result we want to print
# full holds the full path up to the current segment
# part holds the current segment, will get as few characters as
# possible from cur, which is the full current segment
local short full part cur
local first
local -a split # the array we loop over
local HOME=$(zsh-realpath $HOME)
1=$(zsh-realpath ${1:-$PWD})
local prefix=$2
if [[ $1 == / ]]; then
REPLY=/
return 0
fi
# We do the (D) expansion right here and
# handle it later if it had any effect
split=(${(s:/:)${(Q)${(D)1:-$1}}})
# Handling. Perhaps NOT use (D) above and check after shortening?
if [[ -z $prefix && $split[1] = \~* ]]; then
# named directory we skip shortening the first element
# and manually prepend the first element to the return value
first=$split[1]
# full should already contain the first
# component since we don't start there
full=$~split[1]
shift split
fi
# we don't want to end up with something like ~/
if [[ -z $prefix ]] && (( $#split > 0 )); then
part=/
fi
for cur ($split[1,-2]) {
while {
part+=$cur[1]
cur=$cur[2,-1]
local -a glob
glob=( $prefix$full/$part*(-/N) )
# continue adding if more than one directory matches or
# the current string is . or ..
# but stop if there are no more characters to add
(( $#glob > 1 )) || [[ $part == (.|..) ]] && (( $#cur > 0 ))
} { # this is a do-while loop
}
full+=$part$cur
short+=$part
part=/
}
REPLY=$first$short$part$split[-1]
psvar[1]=$REPLY
}
