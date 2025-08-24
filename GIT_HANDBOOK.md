# Git Reference Guide

## Table of Contents

1. [Configuration](#1-configuration)
   - 1.1 [Set Default Branch Name](#11-set-default-branch-name)
2. [File Management](#2-file-management)
   - 2.1 [Ignore Files You Don't Want Committed](#21-ignore-files-you-dont-want-committed)
   - 2.2 [Remove Files from Git Tracking](#22-remove-files-from-git-tracking)
3. [Restoring and Resetting Changes](#3-restoring-and-resetting-changes)
   - 3.1 [Git Restore vs Git Reset - Key Differences](#31-git-restore-vs-git-reset---key-differences)
   - 3.2 [When to Use Each](#32-when-to-use-each)
   - 3.3 [Reset Target Options](#33-reset-target-options)
4. [Stashing Changes](#4-stashing-changes)
   - 4.1 [Basic Git Stash](#41-basic-git-stash)
   - 4.2 [Viewing Stashed Changes](#42-viewing-stashed-changes)
   - 4.3 [Applying Stashed Changes](#43-applying-stashed-changes)
5. [Amending Commits](#5-amending-commits)
   - 5.1 [Basic Amend Usage](#51-basic-amend-usage)
   - 5.2 [Amending Commit Messages](#52-amending-commit-messages)
   - 5.3 [Adding Files to Last Commit](#53-adding-files-to-last-commit)
   - 5.4 [When to Use and When to Avoid](#54-when-to-use-and-when-to-avoid)
6. [Remote Repositories](#6-remote-repositories)
   - 6.1 [Adding Remote Origins](#61-adding-remote-origins)
   - 6.2 [Remote to Local Folder](#62-remote-to-local-folder)
   - 6.3 [Working with Remotes](#63-working-with-remotes)
7. [Branch Management](#7-branch-management)
   - 7.1 [Rename a Branch](#71-rename-a-branch)
   - 7.2 [Switch to a Branch (Alternative to checkout)](#72-switch-to-a-branch-alternative-to-checkout)
8. [Merging](#8-merging)
   - 8.1 [Merge Branches](#81-merge-branches)
9. [Rebasing](#9-rebasing)
   - 9.1 [Git Rebase](#91-git-rebase)
10. [Squashing Commits](#10-squashing-commits)
   - 10.1 [Interactive Rebase for Squashing](#101-interactive-rebase-for-squashing)
   - 10.2 [Complete Squashing Workflow](#102-complete-squashing-workflow)
   - 10.3 [Squashing Options Explained](#103-squashing-options-explained)
   - 10.4 [When to Squash and When to Avoid](#104-when-to-squash-and-when-to-avoid)
11. [Comparing Changes](#11-comparing-changes)
   - 11.1 [Git Diff Between Branches](#111-git-diff-between-branches)
12. [Viewing History and Changes](#12-viewing-history-and-changes)
   - 12.1 [Basic Commit History](#121-basic-commit-history)
   - 12.2 [Git Log Formatting Options](#122-git-log-formatting-options)
   - 12.3 [Advanced Git Log Combinations](#123-advanced-git-log-combinations)
   - 12.4 [Useful Log Filters](#124-useful-log-filters)
13. [Data Recovery with Reflog](#13-data-recovery-with-reflog)
   - 13.1 [Understanding Git Reflog](#131-understanding-git-reflog)
   - 13.2 [Finding Lost Commits](#132-finding-lost-commits)
   - 13.3 [Examining Objects with cat-file](#133-examining-objects-with-cat-file)
   - 13.4 [Complete Recovery Workflow](#134-complete-recovery-workflow)
14. [Additional Resources](#14-additional-resources)

## 1. Configuration

### 1.1 Set Default Branch Name
```bash
git config --global init.defaultBranch main
```

## 2. File Management

### 2.1 Ignore Files You Don't Want Committed
```bash
echo the_created_changed_thing >> .gitignore
```

### 2.2 Remove Files from Git Tracking
```bash
git rm --cached file-to-delete
```
Removes a file from Git's tracking system without deleting it from your working directory. This is useful when:
- You want to stop tracking a file that was previously committed
- You accidentally committed a file that should have been ignored
- You want to apply .gitignore rules to files that are already being tracked

**Important:** The file will be deleted from the repository on the next commit, but it will remain in your local working directory. Other collaborators will see the file as deleted when they pull the changes.

#### Common Use Cases:
```bash
git rm --cached config.env           # Stop tracking environment files
git rm --cached -r node_modules/     # Stop tracking entire directories
git rm --cached *.log               # Stop tracking all log files
```

After using `git rm --cached`, remember to add the file pattern to `.gitignore` to prevent it from being tracked again:
```bash
git rm --cached config.env
echo "config.env" >> .gitignore
git add .gitignore
git commit -m "Stop tracking config.env and add to gitignore"
```

## 3. Restoring and Resetting Changes

### 3.1 Git Restore vs Git Reset - Key Differences

**Git Restore** - Works on files in working directory and staging area:
```bash
git restore file.txt                    # Restore file from last commit
git restore --staged file.txt           # Unstage file (remove from staging area)
git restore --source=HEAD~1 file.txt    # Restore file from specific commit
```

**Git Reset** - Moves the HEAD pointer and affects commit history:

#### Soft Reset (--soft)
```bash
git reset --soft HEAD~1
git reset --soft COMMIT_HASH
```
- Moves the HEAD pointer back to the specified commit
- **Keeps all changes staged** (ready to commit)
- Does NOT modify your working directory
- Perfect for combining multiple commits into one
- Safe option - no work is lost

#### Hard Reset (--hard)  
```bash
git reset --hard HEAD~1
git reset --hard COMMIT_HASH
```
- Moves the HEAD pointer back to the specified commit
- **Permanently deletes all changes** in working directory and staging area
- Resets everything to match the target commit exactly
- **DANGEROUS** - Cannot be undone, all uncommitted work is lost
- Use only when you want to completely abandon recent changes

#### Mixed Reset (default)
```bash
git reset HEAD~1            # Same as git reset --mixed HEAD~1
git reset COMMIT_HASH
```
- Moves the HEAD pointer back to the specified commit
- **Unstages changes** but keeps them in working directory
- You'll see your changes as "modified" files that need to be staged again
- Middle ground between soft and hard reset

### 3.2 When to Use Each

**Use Git Restore when you want to:**
- Undo changes to specific files without affecting commit history
- Unstage files from the staging area  
- Restore files from a specific commit
- Work with individual files, not entire commits

**Use Git Reset when you want to:**

**--soft reset scenarios:**
- Combine multiple small commits into one larger commit
- Fix a commit message by uncommitting and recommitting
- Reorganize recent commits before pushing
- Undo commits but keep all your work staged

**--mixed reset scenarios (default):**
- Undo commits and review changes before re-committing
- Split one large commit into multiple smaller commits
- Unstage everything and start fresh with staging

**--hard reset scenarios:**
- Completely abandon recent experimental work
- Return to a clean state matching a previous commit
- Discard all local changes and match remote branch
- **Warning: Only use when you're certain you want to lose all changes!**

### 3.3 Reset Target Options

#### Using HEAD~ notation
- `HEAD~1` - Go back 1 commit
- `HEAD~2` - Go back 2 commits  
- `HEAD~3` - Go back 3 commits

#### Using Commit Hash
You can get the commit hash from `git log` and use it directly:
```bash
git reset --soft abc1234
git reset --hard abc1234
```

## 4. Stashing Changes

Git stash temporarily saves your uncommitted work (both staged and unstaged changes) so you can switch branches or pull updates without committing incomplete work.

### 4.1 Basic Git Stash

```bash
git stash
```
Saves all your current changes and reverts your working directory to match the HEAD commit. Your changes are stored in a "stash" for later retrieval.

**What gets stashed:**
- All tracked files with modifications
- Files in the staging area

**What doesn't get stashed:**
- Untracked files (new files not yet added to git)
- Files listed in .gitignore

### 4.2 Viewing Stashed Changes

```bash
git stash list
```
Shows all your stashed changes with stash references and descriptions.

**Example output:**
```bash
stash@{0}: WIP on main: 1a2b3c4 Add user login feature
stash@{1}: WIP on feature-branch: 5d6e7f8 Update navigation
```

Each stash entry shows:
- `stash@{0}` - Stash reference (0 = most recent)
- `WIP on main` - "Work In Progress" on the main branch
- `1a2b3c4 Add user login feature` - The commit you were working from

### 4.3 Applying Stashed Changes

```bash
git stash pop
```
Applies the most recent stash (`stash@{0}`) to your current working directory and removes it from the stash list.

**Alternative:**
```bash
git stash apply
```
Applies the stash but keeps it in the stash list (useful if you want to apply the same changes to multiple branches).

**Apply specific stash:**
```bash
git stash pop stash@{1}    # Apply and remove specific stash
git stash apply stash@{1}  # Apply specific stash but keep it
```

## 5. Amending Commits

### 5.1 Basic Amend Usage

**Git commit --amend** allows you to modify the most recent commit without creating a new commit. This is useful for fixing mistakes in your last commit.

```bash
git commit --amend
```

This command opens your default text editor to modify the commit message and includes any currently staged changes into the last commit.

### 5.2 Amending Commit Messages

#### Change Only the Commit Message
```bash
git commit --amend -m "New improved commit message"
```
Changes the commit message of the last commit without opening an editor.

#### Interactive Message Editing
```bash
git commit --amend
```
Opens your default editor to modify the commit message. The existing message will be pre-loaded for editing.

### 5.3 Adding Files to Last Commit

#### Add Forgotten Files
```bash
git add forgotten-file.txt
git commit --amend --no-edit
```
The `--no-edit` flag keeps the existing commit message unchanged while adding the staged files to the last commit.

#### Add Files and Update Message
```bash
git add forgotten-file.txt
git commit --amend -m "Updated commit with forgotten file"
```

#### Common Workflow Example
```bash
# You made a commit but forgot to add a file
git commit -m "Add user authentication feature"

# Realize you forgot to add the CSS file
git add styles/auth.css

# Add it to the previous commit without changing the message
git commit --amend --no-edit
```

### 5.4 When to Use and When to Avoid

#### ✅ Safe to Use When:
- The commit hasn't been pushed to a remote repository yet
- You're working on a feature branch that only you are using
- Fixing typos in commit messages
- Adding forgotten files to the last commit
- Combining staged changes with the previous commit

#### ⚠️ Use with Caution When:
- Working on shared branches where others might have based work on your commits
- The commit has been pushed to a remote repository (requires force push)

#### ❌ Avoid When:
- Multiple people are collaborating on the same branch
- The commit is part of the main/master branch history
- You're unsure if others have already pulled your changes

#### Force Push After Amend (Use Carefully)
```bash
git commit --amend -m "Fixed commit message"
git push --force-with-lease origin feature-branch
```

**Important:** `--force-with-lease` is safer than `--force` as it checks that you have the latest changes before overwriting the remote branch.

#### Alternative: Create a New Commit Instead
If you're unsure about amending, it's often safer to create a new commit:
```bash
git add forgotten-file.txt
git commit -m "Add forgotten authentication styles"
```

## 6. Remote Repositories

### 6.1 Adding Remote Origins

#### Connect to Remote Server (GitHub, GitLab, etc.)
```bash
git remote add origin https://github.com/username/repository.git
git remote add origin git@github.com:username/repository.git
```
Connects your local repository to a remote server for collaboration and backup.

#### Connect to Local Folder
```bash
git remote add origin /path/to/another/local/repo
git remote add origin ../another-project/.git
```
**Important:** You can also connect to another local folder/repository on your machine. This is useful for:
- Testing workflows locally
- Creating backups on the same machine  
- Sharing code between local projects
- Learning git without needing internet access

### 6.2 Remote to Local Folder

#### Example: Setting Up Local Remote
```bash
# Create a bare repository to act as "remote"
mkdir /tmp/my-remote-repo.git
cd /tmp/my-remote-repo.git
git init --bare

# In your main project, add this local folder as remote
cd /path/to/your/project
git remote add origin /tmp/my-remote-repo.git
git push -u origin main
```

#### Cloning from Local Repository
```bash
git clone /path/to/source/repo /path/to/destination/repo
git clone ../existing-project new-project-copy
```

### 6.3 Working with Remotes

#### View Remote Connections
```bash
git remote -v                    # Show all remotes with URLs
git remote show origin           # Show detailed info about origin
```

#### Push and Pull
```bash
git push origin main             # Push to remote
git pull origin main             # Pull from remote
git fetch origin                 # Fetch changes without merging
```

#### Remove or Rename Remotes
```bash
git remote remove origin        # Remove remote connection
git remote rename origin backup  # Rename remote
```

## 7. Branch Management

### 7.1 Rename a Branch
```bash
git branch -m oldname newname
```

### 7.2 Switch to a Branch (Alternative to checkout)
```bash
git switch branch-name
```

## 8. Merging

### 8.1 Merge Branches
This is normally done using a visual interface, but the command is available locally:
```bash
git merge name-of-branch
```
This merges the specified branch into your current branch.

**Visual representation of merge:**
```
main ---A---B---C (brancha merged)
   \           \
    D---E (branchb) \
                      M (merge commit)
```

## 9. Rebasing

### 9.1 Git Rebase
```bash
git rebase branch-name
```
Updates where your base points to by replaying your commits on top of another branch. This creates a linear history instead of merge commits.

**Visual representation of rebase:**
```
main ---A---B---C
                 \
                  D'---E' (rebased branchb)
```

## 10. Squashing Commits

Squashing commits combines multiple commits into a single, cleaner commit. This is particularly useful in feature branch workflows where you want to present your work as one logical change rather than showing all the incremental development steps.

### 10.1 Interactive Rebase for Squashing

**Interactive rebase** is the primary tool for squashing commits. It allows you to edit, combine, and reorder your commit history before merging into the main branch.

```bash
git rebase -i HEAD~NUMBER_OF_COMMITS
```
Opens an interactive editor where you can choose which commits to squash together.

#### Basic Interactive Rebase Syntax
```bash
# Squash the last 3 commits together  
git rebase -i HEAD~3

# Squash commits back to a specific commit hash
git rebase -i abc1234

# Squash all commits in your feature branch (if branched from main)
git rebase -i main
```

### 10.2 Complete Squashing Workflow

#### Step-by-Step Feature Branch Squashing

```bash
# You're on a feature branch with multiple commits
# First, check how many commits you want to squash
git log --oneline

# Let's say you see 4 commits you want to combine:
# def5678 Fix typo in validation message  
# abc1234 Add input validation tests
# ghi9012 Implement user input validation  
# jkl3456 Add validation utility functions

# Start interactive rebase for the last 4 commits
git rebase -i HEAD~4
```

#### Understanding the Interactive Rebase Interface
When you run `git rebase -i HEAD~4`, Git opens your editor with:

```bash
pick jkl3456 Add validation utility functions
pick ghi9012 Implement user input validation
pick abc1234 Add input validation tests  
pick def5678 Fix typo in validation message

# Rebase instructions appear below:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
```

#### Typical Squashing Configuration
```bash
# Keep the first commit and squash the others into it
pick jkl3456 Add validation utility functions
squash ghi9012 Implement user input validation  
squash abc1234 Add input validation tests
squash def5678 Fix typo in validation message
```

After saving and closing the editor, Git will prompt you to write a new commit message combining all the squashed commits.

### 10.3 Squashing Options Explained

#### Pick vs Squash vs Fixup
```bash
pick    # Keep this commit as-is
squash  # Combine with previous commit, keep both commit messages  
fixup   # Combine with previous commit, discard this commit's message
```

#### Advanced Squashing Scenarios

**Squash only some commits:**
```bash
pick jkl3456 Add validation utility functions
pick ghi9012 Implement user input validation
squash abc1234 Add input validation tests     # Combine with ghi9012
squash def5678 Fix typo in validation message # Combine with ghi9012
```

**Use fixup for obvious fixes:**
```bash
pick jkl3456 Add validation utility functions  
pick ghi9012 Implement user input validation
pick abc1234 Add input validation tests
fixup def5678 Fix typo in validation message   # Just fix ghi9012, no message
```

**Reorder and squash:**
```bash
pick jkl3456 Add validation utility functions
pick abc1234 Add input validation tests  
squash ghi9012 Implement user input validation # This will combine with abc1234
fixup def5678 Fix typo in validation message   # This fixes the combined commit
```

### 10.4 When to Squash and When to Avoid

#### ✅ Safe to Squash When:
- Working on a feature branch that hasn't been shared with others
- You have multiple "work in progress" or "fix typo" commits
- Preparing a clean history before merging to main branch
- Each individual commit doesn't add meaningful value to the project history
- You want to present your feature as one logical unit of work

#### ⚠️ Use with Caution When:
- The feature branch has been pushed and others might have based work on it
- Each commit represents a distinct, valuable piece of work
- You're working with teammates who expect to see detailed development history
- Some commits might need to be cherry-picked individually later

#### ❌ Avoid Squashing When:
- Working directly on shared branches (main, develop)
- The commits have already been merged into main branch
- Each commit fixes a different bug that might need individual tracking
- Team policy requires preserving detailed commit history
- Commits span multiple logical features that should remain separate

#### Alternative: Squash Merge
Instead of interactive rebase, you can use squash merge when merging your PR:
```bash
# When merging a pull request, use squash merge
git checkout main
git merge --squash feature-branch
git commit -m "Add complete user input validation system"
```

#### ❌ Common Mistakes to Avoid

**Never squash published commits:**
```bash
# BAD: Don't do this if the branch is shared
git rebase -i HEAD~5  # If these commits are already pushed and others pulled them
```

**Don't squash unrelated features:**
```bash
# BAD: These should be separate commits
pick abc1234 Add user authentication
squash def5678 Fix database connection bug  # Unrelated to authentication!
```

**Always backup before major squashing:**
```bash
# Create a backup branch before squashing
git branch feature-backup
git rebase -i HEAD~10
```

#### Recovery from Squashing Mistakes
If you mess up during interactive rebase:
```bash
# Abort the rebase and return to original state
git rebase --abort

# Or use reflog to recover (see section 12)
git reflog
git reset --hard HEAD@{5}  # Reset to before the rebase
```

## 11. Comparing Changes

### 11.1 Git Diff Between Branches
```bash
git diff branch1..branch2
```
Shows the differences between two branches. This compares what changed from branch1 to branch2.

### Examples of Branch Comparison
```bash
git diff main..feature-branch
git diff feature-branch..main
git diff HEAD..other-branch
```

### Practical Usage
- `git diff main..feature-branch` - See what changes your feature branch has compared to main
- `git diff feature-branch..main` - See what changes main has that your feature branch doesn't
- `git diff HEAD..origin/main` - Compare your current branch with the remote main branch

## 12. Viewing History and Changes

### 12.1 Basic Commit History
```bash
git log
```
Shows detailed commit history with full commit messages, author, date, and commit hashes.

### 12.2 Git Log Formatting Options

#### Short Format (Oneline)
```bash
git log --oneline
```
Shows a condensed version with abbreviated commit hash and commit message on one line.

#### Visual Tree Structure
```bash
git log --graph
```
Displays the logs in tree view, showing branch dependencies and merge history.

#### Show Branch and Tag References
```bash
git log --decorate
```
Adds branch names and tag names to the commit display, showing which commits correspond to branches or tags.

#### Show Parent Commits
```bash
git log --parents
```
Displays the parent commit hashes for each commit, useful for understanding merge relationships.

### 12.3 Advanced Git Log Combinations

#### Complete Visual History
```bash
git log --oneline --graph --decorate
```
Combines short format with visual tree and branch/tag references for a comprehensive view.

#### Detailed Tree with Parents
```bash
git log --graph --parents --decorate
```
Shows the full tree structure with parent relationships and branch/tag information.

#### All Branches History
```bash
git log --oneline --graph --decorate --all
```
Displays history for all branches, not just the current one.

### 12.4 Useful Log Filters

#### Limit Number of Commits
```bash
git log --oneline -10
```
Shows only the last 10 commits.

#### Show Commits from Specific Author
```bash
git log --author="Author Name"
```
Filters commits by a specific author.

#### Show Commits in Date Range
```bash
git log --since="2 weeks ago" --until="yesterday"
```
Shows commits within a specific time range.

## 13. Data Recovery with Reflog

Git reflog (reference log) is a powerful recovery tool that tracks all changes to branch tips and HEAD in your local repository. Unlike git log, which shows committed history, reflog shows your navigation history - every checkout, commit, merge, rebase, and reset you've performed.

### 13.1 Understanding Git Reflog

**Git reflog** maintains a local history of where your HEAD and branch references have been, making it possible to recover "lost" commits and branches.

```bash
git reflog
```
Shows your recent actions with abbreviated commit hashes and action descriptions.

#### Detailed Reflog Information
```bash
git reflog --all                    # Show reflog for all references
git reflog show HEAD                # Show reflog for HEAD specifically
git reflog show branch-name         # Show reflog for specific branch
```

#### Understanding Reflog Output
```bash
# Example reflog output:
# abc1234 (HEAD@{0}) HEAD@{0}: commit: Add user authentication
# def5678 (HEAD@{1}) HEAD@{1}: checkout: moving from main to feature-branch  
# ghi9012 (HEAD@{2}) HEAD@{2}: reset: moving to HEAD~1
```

**Reflog entries explained:**
- `abc1234` - Commit hash  
- `HEAD@{0}` - Most recent action (0 = now, 1 = one step back, etc.)
- `commit:` - Type of action performed
- `Add user authentication` - Description of the action

### 13.2 Finding Lost Commits

#### Recover After Accidental Reset
```bash
# You accidentally did: git reset --hard HEAD~3
# First, check what you lost
git reflog

# Find the commit you want to recover (before the reset)
# Let's say it shows: abc1234 HEAD@{1}: commit: Important feature

# Recover by resetting to that commit
git reset --hard abc1234
# or use the reflog reference directly
git reset --hard HEAD@{1}
```

#### Recover Deleted Branch
```bash
# You accidentally deleted a branch: git branch -D feature-branch
# First, find the last commit of that branch in reflog
git reflog

# Look for entries like: "checkout: moving from feature-branch to main"
# The commit before that checkout is your branch's last commit
# Let's say it shows: def5678 HEAD@{3}: commit: Feature complete

# Recreate the branch at that commit
git branch feature-branch-recovered def5678
git checkout feature-branch-recovered
```

### 13.3 Examining Objects with cat-file

**Git cat-file** is a low-level command that displays the raw content of Git objects (commits, trees, blobs). This is essential for detailed investigation when recovering data.

```bash
git cat-file -p COMMIT_HASH
```
Shows the complete content of a commit object including metadata and parent relationships.

#### Understanding Commit Objects
```bash
# Example: Examine a specific commit
git cat-file -p abc1234

# Output shows:
# tree def5678abc...           # Points to the tree (directory structure)
# parent ghi9012def...         # Parent commit(s)  
# author John Doe <john@example.com> 1642780800 +0000
# committer John Doe <john@example.com> 1642780800 +0000
#
# Add user authentication feature
```

#### Examining Tree Objects
```bash
# Use the tree hash from the commit to see directory structure
git cat-file -p def5678abc

# Output shows files and subdirectories:
# 100644 blob jkl3456... README.md
# 100644 blob mno7890... package.json  
# 040000 tree pqr1234... src/
```

#### Examining File Content (Blobs)
```bash
# Use the blob hash to see actual file content
git cat-file -p jkl3456

# Shows the actual content of README.md at that commit
```

#### Useful cat-file Options
```bash
git cat-file -t HASH              # Show object type (commit, tree, blob, tag)
git cat-file -s HASH              # Show object size
git cat-file --batch-check        # Check multiple objects efficiently
```

### 13.4 Complete Recovery Workflow

#### Step-by-Step Recovery Process
Based on the provided recovery steps, here's the complete workflow:

```bash
# Step 1: Use git reflog to identify the target commit
git reflog
# Look for the commit message related to the change you want to retrieve
# Example output: abc1234 HEAD@{5}: commit: Important feature implementation

# Step 2: Examine the commit object completely  
git cat-file -p abc1234
# This shows the tree hash and commit metadata
# Example output shows: tree def5678...

# Step 3: Examine the tree to see directory changes
git cat-file -p def5678  
# This shows all files and subdirectories at that commit
# Look for the specific file hash you need
# Example: 100644 blob ghi9012... important-file.js

# Step 4: Retrieve the actual file content
git cat-file -p ghi9012
# This shows the complete file content as it existed in that commit
```

#### Practical Recovery Example
```bash
# Scenario: You lost changes after a bad merge and need to recover specific files

# Find the commit before the bad merge
git reflog | grep "merge\|commit"
# Shows: def5678 HEAD@{3}: commit: Add payment processing

# Examine that commit's structure  
git cat-file -p def5678
# Output: tree abc1234...

# Check what files were in that tree
git cat-file -p abc1234
# Shows: 100644 blob xyz7890... src/payment.js  

# Recover the specific file content
git cat-file -p xyz7890 > recovered-payment.js
```

#### ✅ Safe Recovery Practices

- **Always examine before recovering**: Use `git cat-file -p` to verify content before restoration
- **Work on a backup branch**: Create a new branch for recovery attempts
- **Document your steps**: Keep track of commit hashes and recovery commands
- **Verify integrity**: Compare recovered files with expected content

#### ⚠️ Important Limitations

- **Reflog is local only**: It doesn't sync with remotes, only tracks your local actions
- **Limited retention**: Reflog entries expire (default 90 days for reachable commits)
- **Repository-specific**: Each clone has its own reflog history

#### ❌ When Recovery Isn't Possible

- **After git gc --prune**: Unreachable objects may be permanently deleted
- **On fresh clones**: Reflog doesn't transfer from remotes  
- **Very old changes**: Beyond reflog retention period
- **Different repository**: Reflog is tied to your specific local repository


## 14. Additional Resources

### Video Tutorial
[Git Tutorial Video](https://youtu.be/rH3zE7VlIMs?t=7290)

