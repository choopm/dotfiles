#!/bin/sh
# Deletes merged/orphaned branches after fetching with prune from origins.
# Origin: <https://www.reddit.com/r/git/comments/hgronz/comment/fw6277y/>

# Delete the remote branches, and ensure that we are inside a git repo.
git fetch --all --prune || exit 1

# Create origin/HEAD if it does not already exist.
# We can use origin/HEAD instead of origin/master in case the
# origin repo doesn't use "master" as the default branch.
git remote set-head origin --auto >/dev/null || exit 1

git for-each-ref refs/heads --format="%(refname:short)" | while read -r branch; do
    # Is this branch set to track an upstream branch?
    if git config --get "branch.$branch.remote" > /dev/null; then
        # Does the upstream branch still exist?
        if upstream=$(git rev-parse --abbrev-ref "$branch@{upstream}" 2>/dev/null); then
            # Yes. Try to fast forward the local branch.
            if ! git fetch --update-head-ok . "$upstream:$branch" 2>/dev/null; then
                echo ---
                echo Fast-forward of $branch failed. If desired please run:
                echo   git rebase -i $upstream $branch
                echo or
                echo   git branch -f $branch $upstream
                echo ---
            fi
        else
            # No. Delete the local branch if it has been merged
            if git merge-base --is-ancestor "$branch" origin/HEAD; then
                if [ "$branch" = "$(git branch --show-current)" ]; then
                    echo "The current branch will be deleted because it has already been merged."
                    echo "You are now in detached head mode."
                    git switch --detach origin/HEAD
                fi
                git branch -d "$branch"
            fi
        fi
    else
        # Not tracking an upstream. Delete it if does not contain any delta
        if git merge-base --is-ancestor "$branch" origin/HEAD; then
            if [ "$branch" = "$(git branch --show-current)" ]; then
                    echo "The current branch will be deleted because it has already been merged."
                    echo "You are now in detached head mode."
                    git switch --detach origin/HEAD
            fi
            git branch -d "$branch"
        fi
    fi
done
