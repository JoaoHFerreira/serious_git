# Git Handbook Maintenance Guide

This document provides specific instructions for Claude to update and maintain the GIT_HANDBOOK.md file systematically. Follow these procedures exactly when modifying the handbook to ensure consistency and prevent errors.

## Table of Contents
1. [Adding New Sections](#1-adding-new-sections)
2. [Renumbering Strategy](#2-renumbering-strategy)
3. [Content Structure Guidelines](#3-content-structure-guidelines)
4. [Content Requirements for Claude](#4-content-requirements-for-claude)
5. [Validation Requirements for Claude](#5-validation-requirements-for-claude)

## 1. Adding New Sections

### Mandatory Step-by-Step Process
When adding ANY new section to the handbook, you MUST follow these steps in exact order:

1. **Use Read tool first**: Always read GIT_HANDBOOK.md completely before making changes
2. **Create TodoWrite**: Break down the task into specific todos for tracking
3. **Analyze placement**: Identify exact insertion point by examining table of contents structure
4. **Update table of contents**: Use Edit tool to add new section and renumber ALL subsequent sections
5. **Update section headers**: Use MultiEdit tool to update ALL affected section numbers throughout document
6. **Add content**: Write the new section with proper formatting and examples
7. **Verify numbering**: Ensure no gaps, duplicates, or mismatches in section numbering

### Section Placement Logic for Claude
Use this decision tree to determine placement:

```
IF topic is configuration-related → Insert after section 1
ELSE IF topic is basic file management → Insert after section 2  
ELSE IF topic involves commits/history → Insert after sections 3-4
ELSE IF topic is remote/branching → Insert after sections 5-6
ELSE IF topic is advanced workflow → Insert in sections 7-10
ELSE → Insert before Additional Resources (last section)
```

ALWAYS check current section numbers before deciding insertion point.

## 2. Renumbering Strategy

### CRITICAL: Use MultiEdit Tool for Renumbering
When inserting a section that shifts numbering, use MultiEdit with ALL replacements in a single operation:

**Template for MultiEdit edits array:**
```json
[
  {"old_string": "## 4.", "new_string": "## 5."},
  {"old_string": "### 4.1", "new_string": "### 5.1"},
  {"old_string": "### 4.2", "new_string": "### 5.2"},
  {"old_string": "## 5.", "new_string": "## 6."},
  {"old_string": "### 5.1", "new_string": "### 6.1"}
  // Continue for ALL affected sections
]
```

### Renumbering Order Requirements
1. **ALWAYS start with table of contents first** (separate Edit operation)
2. **Then use MultiEdit** for all section headers in the document body
3. **Work from HIGHEST numbers down** to avoid conflicts
4. **Include ALL subsection numbers** (X.1, X.2, X.3, etc.)

## 3. Content Structure Guidelines

### Required Section Template
When writing new sections, use this EXACT structure:

```markdown
## X. Section Title

Brief introduction explaining what this section covers and why it's useful.

### X.1 Basic Usage

**Command description** - Explain what the command does.

```bash
command-example
```

Explanation of what happens when you run this command.

### X.2 [Specific Use Cases]

#### Subsection Title
```bash
# Comment explaining the scenario
command-with-options
```
Explanation of this specific use case.

### X.3 When to Use and When to Avoid

#### ✅ Safe to Use When:
- Bullet point conditions
- When it's safe to use

#### ⚠️ Use with Caution When:
- Warning conditions
- Situations requiring care

#### ❌ Avoid When:
- Dangerous situations
- When not to use this command
```

### Code Block Requirements for Claude

**MANDATORY formatting rules:**
- ALL code blocks MUST use ```bash
- ALWAYS include contextual comments with #
- Show complete workflows, not isolated commands
- Use realistic file/branch names (not "file.txt" or "branch-name")

**Template for command examples:**
```bash
# Describe the situation or problem
command-showing-the-problem

# Explain the solution step
command-that-solves-it

# Show the result or next step
final-command-or-verification
```

**Example - GOOD (use this pattern):**
```bash
# You committed but forgot to add a file
git commit -m "Add user authentication feature"

# Realize you forgot the CSS file
git add styles/auth.css

# Add it to the previous commit without changing message
git commit --amend --no-edit
```

**Example - BAD (never do this):**
```bash
git commit --amend
```

## 4. Content Requirements for Claude

### MANDATORY Content Elements
Every section you write MUST include:

1. **Real-world scenarios**: Start with actual problems users face
2. **Safety warnings**: Use ⚠️ and ❌ symbols for dangerous commands
3. **Progressive examples**: Basic → Intermediate → Advanced
4. **Exit strategies**: How to undo or recover from mistakes

### Writing Pattern Requirements
Use this EXACT pattern for dangerous commands:

```markdown
#### Command Name
```bash
git dangerous-command
```
Explanation of what it does.

**Important:** This command is dangerous because [specific reason]. Always [safer alternative] instead.
```

### Terminology Requirements
- Use "commit" not "change" or "update"
- Use "repository" not "repo" in explanations
- Use "working directory" not "workspace"
- Use "staging area" not "index" in beginner contexts
- Always use full flag names first: `--force` not `-f`

## 5. Validation Requirements for Claude

### MANDATORY Pre-Completion Checklist
Before marking any handbook update as complete, you MUST:

1. **Use Read tool** to verify the final state of GIT_HANDBOOK.md
2. **Check table of contents** - All section numbers must be sequential without gaps
3. **Verify all internal links** - Every `#section-name` must match actual headers
4. **Count sections** - Ensure total matches table of contents entries
5. **Validate subsection numbering** - All X.Y numbers must match parent section X

### Error Prevention Protocol
**Before making changes:**
- Read current file state with Read tool
- Count existing sections to understand current numbering
- Create TodoWrite to track each step

**During changes:**
- Use MultiEdit for batch renumbering operations
- Never use multiple Edit operations for renumbering
- Work on table of contents first, then section headers

**After changes:**
- Use Read tool to verify changes applied correctly
- Check that no section numbers were missed or duplicated

## Critical Instructions for Claude

### Non-Negotiable Requirements
1. **ALWAYS use TodoWrite** when modifying the handbook
2. **NEVER skip the Read tool** before making changes
3. **ALWAYS use MultiEdit** for renumbering operations
4. **NEVER leave section numbering incomplete**
5. **ALWAYS verify final state** with Read tool before completion

### Command Priorities
1. **Safety first**: Warn about destructive commands
2. **Practicality**: Show complete workflows, not isolated commands  
3. **Recovery**: Always mention how to undo dangerous operations
4. **Progression**: Basic usage before advanced scenarios

The handbook exists to prevent Git disasters and enable confident usage. Every addition must serve this purpose.