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
4. [Amending Commits](#4-amending-commits)
   - 4.1 [Basic Amend Usage](#41-basic-amend-usage)
   - 4.2 [Amending Commit Messages](#42-amending-commit-messages)
   - 4.3 [Adding Files to Last Commit](#43-adding-files-to-last-commit)
   - 4.4 [When to Use and When to Avoid](#44-when-to-use-and-when-to-avoid)
5. [Remote Repositories](#5-remote-repositories)
   - 5.1 [Adding Remote Origins](#51-adding-remote-origins)
   - 5.2 [Remote to Local Folder](#52-remote-to-local-folder)
   - 5.3 [Working with Remotes](#53-working-with-remotes)
6. [Branch Management](#6-branch-management)
   - 6.1 [Rename a Branch](#61-rename-a-branch)
   - 6.2 [Switch to a Branch (Alternative to checkout)](#62-switch-to-a-branch-alternative-to-checkout)
7. [Merging](#7-merging)
   - 7.1 [Merge Branches](#71-merge-branches)
8. [Rebasing](#8-rebasing)
   - 8.1 [Git Rebase](#81-git-rebase)
9. [Comparing Changes](#9-comparing-changes)
   - 9.1 [Git Diff Between Branches](#91-git-diff-between-branches)
10. [Viewing History and Changes](#10-viewing-history-and-changes)
   - 10.1 [Basic Commit History](#101-basic-commit-history)
   - 10.2 [Git Log Formatting Options](#102-git-log-formatting-options)
   - 10.3 [Advanced Git Log Combinations](#103-advanced-git-log-combinations)
   - 10.4 [Useful Log Filters](#104-useful-log-filters)
11. [Data Recovery with Reflog](#11-data-recovery-with-reflog)
   - 11.1 [Understanding Git Reflog](#111-understanding-git-reflog)
   - 11.2 [Finding Lost Commits](#112-finding-lost-commits)
   - 11.3 [Examining Objects with cat-file](#113-examining-objects-with-cat-file)
   - 11.4 [Complete Recovery Workflow](#114-complete-recovery-workflow)
12. [Additional Resources](#12-additional-resources)

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

## 4. Amending Commits

### 4.1 Basic Amend Usage

**Git commit --amend** allows you to modify the most recent commit without creating a new commit. This is useful for fixing mistakes in your last commit.

```bash
git commit --amend
```

This command opens your default text editor to modify the commit message and includes any currently staged changes into the last commit.

### 4.2 Amending Commit Messages

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

### 4.3 Adding Files to Last Commit

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

### 4.4 When to Use and When to Avoid

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

## 5. Remote Repositories

### 5.1 Adding Remote Origins

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

### 5.2 Remote to Local Folder

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

### 5.3 Working with Remotes

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

## 6. Branch Management

### 6.1 Rename a Branch
```bash
git branch -m oldname newname
```

### 6.2 Switch to a Branch (Alternative to checkout)
```bash
git switch branch-name
```

## 7. Merging

### 7.1 Merge Branches
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

## 8. Rebasing

### 8.1 Git Rebase
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

## 9. Comparing Changes

### 9.1 Git Diff Between Branches
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

## 10. Viewing History and Changes

### 10.1 Basic Commit History
```bash
git log
```
Shows detailed commit history with full commit messages, author, date, and commit hashes.

### 10.2 Git Log Formatting Options

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

### 10.3 Advanced Git Log Combinations

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

### 10.4 Useful Log Filters

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

## 11. Data Recovery with Reflog

Git reflog (reference log) is a powerful recovery tool that tracks all changes to branch tips and HEAD in your local repository. Unlike git log, which shows committed history, reflog shows your navigation history - every checkout, commit, merge, rebase, and reset you've performed.

### 11.1 Understanding Git Reflog

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

### 11.2 Finding Lost Commits

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

### 11.3 Examining Objects with cat-file

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

### 11.4 Complete Recovery Workflow

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


## 12. Additional Resources

### Video Tutorial
[Git Tutorial Video](https://youtu.be/rH3zE7VlIMs?t=7290)

