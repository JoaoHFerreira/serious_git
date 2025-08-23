# Git Reference Guide

## Table of Contents

1. [Configuration](#configuration)
   - [Set Default Branch Name](#set-default-branch-name)
2. [File Management](#file-management)
   - [Ignore Files You Don't Want Committed](#ignore-files-you-dont-want-committed)
3. [Branch Management](#branch-management)
   - [Rename a Branch](#rename-a-branch)
   - [Switch to a Branch (Alternative to checkout)](#switch-to-a-branch-alternative-to-checkout)
4. [Merging](#merging)
   - [Merge Branches](#merge-branches)
5. [Rebasing](#rebasing)
   - [Git Rebase](#git-rebase)
6. [Resetting Changes](#resetting-changes)
   - [Git Reset Options](#git-reset-options)
   - [Reset Target Options](#reset-target-options)
   - [When to Use Each](#when-to-use-each)
7. [Comparing Changes](#comparing-changes)
   - [Git Diff Between Branches](#git-diff-between-branches)
8. [Viewing History and Changes](#viewing-history-and-changes)
   - [Basic Commit History](#basic-commit-history)
   - [Git Log Formatting Options](#git-log-formatting-options)
   - [Advanced Git Log Combinations](#advanced-git-log-combinations)
   - [Useful Log Filters](#useful-log-filters)
9. [Additional Resources](#additional-resources)

## Configuration

### Set Default Branch Name
```bash
git config --global init.defaultBranch main
```

## File Management

### Ignore Files You Don't Want Committed
1. Add the file to `.gitignore`:
   ```bash
   echo the_created_changed_thing >> .gitignore
   ```
2. Restore the file to its last committed version:
   ```bash
   git restore the_created_changed_thing
   ```

## Branch Management

### Rename a Branch
```bash
git branch -m oldname newname
```

### Switch to a Branch (Alternative to checkout)
```bash
git switch branch-name
```

## Merging

### Merge Branches
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

## Rebasing

### Git Rebase
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

## Resetting Changes

### Git Reset Options

#### Soft Reset
```bash
git reset --soft HEAD~1
git reset --soft COMMIT_HASH
```
Moves the HEAD pointer back but keeps your changes staged (ready to commit). Use this when you want to undo commits but keep your work ready for a new commit.

#### Hard Reset
```bash
git reset --hard HEAD~1
git reset --hard COMMIT_HASH
```
Moves the HEAD pointer back and **permanently deletes** all changes in your working directory and staging area. Use with caution as this cannot be undone.

### Reset Target Options

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

### When to Use Each

**Use `--soft` when:**
- You want to combine multiple commits into one
- You made a mistake in the last commit message
- You want to reorganize your commits

**Use `--hard` when:**
- You want to completely abandon recent changes
- You want to return to a previous state and discard all work
- **Warning:** This permanently deletes your changes!

## Comparing Changes

### Git Diff Between Branches
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

## Viewing History and Changes

### Basic Commit History
```bash
git log
```
Shows detailed commit history with full commit messages, author, date, and commit hashes.

### Git Log Formatting Options

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

### Advanced Git Log Combinations

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

### Useful Log Filters

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


## Additional Resources

### Video Tutorial
[Git Tutorial Video](https://youtu.be/rH3zE7VlIMs?t=2445)

