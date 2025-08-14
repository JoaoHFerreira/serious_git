## Define the name of the default branch
git config --global init.defaultBranch main

## If possibly you create something that you dont want to be commited
1. echo the_created_changed_thing >> .gitignore
2. git restore the_created_changed_thing (this will be back file to last changed version)

## Discovery git track file
git log
<catch commit>

git cat-file -p commit_hash

git cat-file -p tree_hash
retrieve blobs

## config