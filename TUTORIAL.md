# Git Reference Guide

## Table of Contents

1. [Configuration](#1-configuration)
   - 1.1 [Set Default Branch Name](#11-set-default-branch-name)
2. [File Management](#2-file-management)
   - 2.1 [Ignore Files You Don't Want Committed](#21-ignore-files-you-dont-want-committed)
3. [Restoring and Resetting Changes](#3-restoring-and-resetting-changes)
   - 3.1 [Git Restore vs Git Reset - Key Differences](#31-git-restore-vs-git-reset---key-differences)
   - 3.2 [When to Use Each](#32-when-to-use-each)
   - 3.3 [Reset Target Options](#33-reset-target-options)
4. [Remote Repositories](#4-remote-repositories)
   - 4.1 [Adding Remote Origins](#41-adding-remote-origins)
   - 4.2 [Remote to Local Folder](#42-remote-to-local-folder)
   - 4.3 [Working with Remotes](#43-working-with-remotes)
5. [Branch Management](#5-branch-management)
   - 5.1 [Rename a Branch](#51-rename-a-branch)
   - 5.2 [Switch to a Branch (Alternative to checkout)](#52-switch-to-a-branch-alternative-to-checkout)
6. [Merging](#6-merging)
   - 6.1 [Merge Branches](#61-merge-branches)
7. [Rebasing](#7-rebasing)
   - 7.1 [Git Rebase](#71-git-rebase)
8. [Comparing Changes](#8-comparing-changes)
   - 8.1 [Git Diff Between Branches](#81-git-diff-between-branches)
9. [Viewing History and Changes](#9-viewing-history-and-changes)
   - 9.1 [Basic Commit History](#91-basic-commit-history)
   - 9.2 [Git Log Formatting Options](#92-git-log-formatting-options)
   - 9.3 [Advanced Git Log Combinations](#93-advanced-git-log-combinations)
   - 9.4 [Useful Log Filters](#94-useful-log-filters)
10. [Additional Resources](#10-additional-resources)

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

## 4. Remote Repositories

### 4.1 Adding Remote Origins

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

### 4.2 Remote to Local Folder

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

### 4.3 Working with Remotes

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

## 5. Branch Management

### 5.1 Rename a Branch
```bash
git branch -m oldname newname
```

### 5.2 Switch to a Branch (Alternative to checkout)
```bash
git switch branch-name
```

## 6. Merging

### 6.1 Merge Branches
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

## 7. Rebasing

### 7.1 Git Rebase
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

## 8. Comparing Changes

### 8.1 Git Diff Between Branches
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

## 9. Viewing History and Changes

### 9.1 Basic Commit History
```bash
git log
```
Shows detailed commit history with full commit messages, author, date, and commit hashes.

### 9.2 Git Log Formatting Options

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

### 9.3 Advanced Git Log Combinations

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

### 9.4 Useful Log Filters

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


## 10. Additional Resources

### Video Tutorial
[Git Tutorial Video](https://youtu.be/rH3zE7VlIMs?t=2445)

