# Git Reference Guide

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

