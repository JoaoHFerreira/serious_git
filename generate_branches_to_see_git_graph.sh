#!/bin/bash

# Safety: exit on any error
set -e


# Create initial commit on main
echo "Initial file" > file0.txt
git add file0.txt
git commit -m "Initial commit on main"

# Function to create a branch, add commits, and merge to main
create_branch() {
    branch_name=$1
    num_commits=$2

    git checkout -b $branch_name main
    for i in $(seq 1 $num_commits); do
        echo "$branch_name commit $i" > "${branch_name}_file$i.txt"
        git add "${branch_name}_file$i.txt"
        git commit -m "$branch_name commit $i"
    done

    git checkout main
    git merge --no-ff $branch_name -m "Merge $branch_name into main"
}

# Create branches with commits and merge
create_branch "branch1" 3
create_branch "branch2" 4
create_branch "branch3" 2

# Final status
echo "Repository setup done. Run:"
echo "  git log --all --graph --oneline --decorate"
echo "to see the full graph."
