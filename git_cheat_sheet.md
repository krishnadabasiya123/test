# Git Cheat Sheet & Command Documentation

A quick-reference guide for standard Git workflows, commands, and troubleshooting.

---

## 1. Initializing & Cloning Repositories

| Command | Description |
| :--- | :--- |
| `git init` | Initialize a brand new local Git repository in the current folder. |
| `git clone <repo-url>` | Download/clone an existing remote repository to your local machine. |

---

## 2. Basic Workflow (Status, Add, Commit)

| Command | Description |
| :--- | :--- |
| `git status` | Show changed files in your working directory (shows what is staged, unstaged, or untracked). |
| `git diff` | Show the exact line changes that have not been staged yet. |
| `git add <file>` | Stage a specific file for the next commit. |
| `git add .` | Stage **all** modified and new files in the current directory. |
| `git commit -m "Message"` | Save the staged changes to your history with a descriptive message. |

---

## 3. Branches (Create, Switch, Delete)

| Command | Description |
| :--- | :--- |
| `git branch` | List all local branches in the repository. |
| `git branch -a` | List all local and remote branches. |
| `git switch -c <branch-name>` | Create a new branch and switch to it immediately (modern version). |
| `git checkout -b <branch-name>` | Create a new branch and switch to it (traditional version). |
| `git switch <branch-name>` | Switch to an existing branch (modern version). |
| `git checkout <branch-name>` | Switch to an existing branch (traditional version). |
| `git branch -d <branch-name>` | Delete a local branch (only if it has been merged). |

---

## 4. Remote Repositories (Push & Pull)

| Command | Description |
| :--- | :--- |
| `git remote add origin <url>` | Link your local repository to a remote server (e.g. GitHub). |
| `git remote -v` | Verify the URLs of the remote servers connected to your local repository. |
| `git push -u origin <branch-name>` | Push your local branch to the remote repository and set the upstream branch (run this the first time you push). |
| `git push origin <branch-name>` | Push commits on the specified branch to the remote. |
| `git pull origin <branch-name>` | Fetch and merge changes from the remote branch into your current branch. |

---

## 5. Merging & Conflict Resolution

| Command | Description |
| :--- | :--- |
| `git merge <branch-name>` | Merge changes from the specified branch into your **current** branch. |
| `git merge --abort` | Cancel the merge process if a conflict happens and you want to start over. |

### How to handle a merge conflict:
1. Open the conflicted files. Look for these markers:
   ```text
   <<<<<<< HEAD
   [Your local changes on the current branch]
   =======
   [Changes from the branch you are merging in]
   >>>>>>> branch-name
   ```
2. Manually edit the file to keep the correct code and delete the markers.
3. Save the file.
4. Run:
   ```bash
   git add <resolved-file>
   git commit -m "Resolve merge conflict"
   ```

---

## 6. Undoing & Resetting Changes

### A. Unstaging files (undoing `git add .`)
If you ran `git add` but do not want to commit yet (keeps your code changes):
*   **Modern:** `git restore --staged .`
*   **Traditional:** `git reset`

### B. Throwing away uncommitted code changes
If you want to permanently delete all changes made since your last commit:
*   **Modern:** `git restore .`
*   **Traditional:** `git checkout -- .`

### C. Undoing commits (Local history only)
If you committed locally but want to undo it:

*   **Soft Reset (Keep your code):**
    ```bash
    git reset --soft HEAD~1
    ```
    *Undoes the commit; your files will still contain your edits and be ready to commit again.*

*   **Hard Reset (Delete your code):**
    ```bash
    git reset --hard HEAD~1
    ```
    *⚠️ Warning: Permanently deletes the commit and all code changes from it.*

### D. Undoing pushed commits (Safe for remote)
If you already pushed the commit to GitHub and want to undo it without rewriting history:
```bash
git revert HEAD
```
*Creates a new commit that reverses the changes of the last commit.*
