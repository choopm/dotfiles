function gitaheadbehind {
    showzero=0 #Show both ahead and behind if any of both is greater 0
    showempty=0 #Show them even if the repo is synced
    arrowup="\u25b2"
    arrowdown="\u25bc"
    delimeter=","
    psvar[6]="("
    psvar[7]=$delimeter
    psvar[8]=") "
    psvar[9]="! " #Indicator on unstaged changes

    gtree=$(git rev-parse --is-inside-work-tree 2> /dev/null)
    if [[ $gtree == true ]] ; then
        rtn=$(LANG=en_US-UTF-8 git status -sb | head -1)
        rtnd=$(git status -sb | grep -E " M|M |A | D|D |MM" | wc -l)
        ahead=$(echo $rtn | grep -Po 'ahead \d+' | sed 's/ahead //g')
        behind=$(echo $rtn | grep -Po 'behind \d+' | sed 's/behind //g')
        if [[ "$ahead" == [0-9]* ]]; then
            ahead_s=1
        else
            ahead_s=0
            ahead=0
        fi
        if [[ "$behind" == [0-9]* ]]; then
            behind_s=1
        else
            behind_s=0
            behind=0
        fi

        if [[ ! $rtnd -gt 0 ]]; then
            psvar[9]=""
        fi

        if [[ $ahead_s -eq 1 ]] && [[ $behind_s -eq 1 ]]; then
            psvar[2]=$ahead
            psvar[3]=$(echo -e "$arrowup")
            psvar[4]=$behind
            psvar[5]=$(echo -e "$arrowdown")
            psvar[7]=$delimeter
        elif [[ $ahead_s -eq 1 ]] && [[ $behind_s -eq 0 ]]; then
            psvar[2]=$ahead
            psvar[3]=$(echo -e "$arrowup")
            if [[ $showzero -eq 1 ]]; then
                psvar[4]=$behind
                psvar[5]=$(echo -e "$arrowdown")
                psvar[7]=$delimeter
            else
                psvar[4]=""
                psvar[5]=""
                psvar[7]=""
            fi
        elif [[ $ahead_s -eq 0 ]] && [[ $behind_s -eq 1 ]]; then
            if [[ $showzero -eq 1 ]]; then
                psvar[2]=$ahead
                psvar[3]=$(echo -e "$arrowup")
                psvar[7]=$delimeter
            else
                psvar[2]=""
                psvar[3]=""
                psvar[7]=""
            fi
            psvar[4]=$behind
            psvar[5]=$(echo -e "$arrowdown")
        elif ( [[ $ahead_s -eq 0 ]] && [[ $behind_s -eq 0 ]] ) && [[ $showempty -eq 1 ]] ; then
            psvar[2]=$ahead
            psvar[3]=$(echo -e "$arrowup")
            psvar[4]=$behind
            psvar[5]=$(echo -e "$arrowdown")
            psvar[7]=$delimeter
        else
            psvar[2]=""
            psvar[3]=""
            psvar[4]=""
            psvar[5]=""
            psvar[6]=""
            psvar[7]=""
            psvar[8]=""
        fi
    fi
}
