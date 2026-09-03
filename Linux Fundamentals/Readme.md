# Linux Fundamentals Assignment

**Name:** Vanukuri Manohar Reddy  
**Course:** DevOps Fundamentals  
**Topic:** Linux Fundamentals  

---

## Table of Contents
1. [Task 1: Soft Link & Hard Link](#task-1-soft-link--hard-link)
2. [Task 2: adduser vs useradd](#task-2-adduser-vs-useradd)
3. [Task 3: journalctl Log Management](#task-3-journalctl-log-management)
4. [Task 4: Essential Linux Commands Cheat Sheet](#task-4-essential-linux-commands-cheat-sheet)
5. [Submission Guide & Verification](#submission-guide--verification)

---

## Task 1: Soft Link & Hard Link

### 1. Key Differences
| Feature | Soft Link (Symbolic Link / Symlink) | Hard Link |
| :--- | :--- | :--- |
| **Inode Number** | Has its own **unique inode number**. | Shares the **exact same inode number** as the original file. |
| **Data Storage** | Stores the path string pointing to the original file. | Points directly to the actual disk data blocks. |
| **Target Deletion** | Becomes **broken** ("dangling link") if original file is deleted. | **Data remains intact**; file exists until all hard links are deleted. |
| **Directory Support** | Can link to directories. | Cannot link to directories (prevents filesystem loops). |
| **Filesystem Boundary** | Can cross different filesystems/partitions. | Must remain on the **same filesystem/partition**. |
| **File Type Indicator** | Identified by `l` prefix in `ls -l` output. | Appears as a standard file `-` prefix in `ls -l`. |

---

### 2. Commands & Hands-on Execution

#### Step 1: Create a base file
```bash
echo "Linux Fundamentals Hard vs Soft Link Test" > original.txt
```

#### Step 2: Create a Hard Link
```bash
ln original.txt hard_link.txt
```

#### Step 3: Create a Soft Link (Symlink)
```bash
ln -s original.txt soft_link.txt
```

#### Step 4: Verify Inodes and Link Counts
```bash
ls -li original.txt hard_link.txt soft_link.txt
```

**Expected Command Output:**
```text
1458291 -rw-r--r-- 2 devuser devuser 42 Sep 3 18:00 hard_link.txt
1458291 -rw-r--r-- 2 devuser devuser 42 Sep 3 18:00 original.txt
1458299 lrwxrwxrwx 1 devuser devuser 12 Sep 3 18:01 soft_link.txt -> original.txt
```
> **Observation:** `original.txt` and `hard_link.txt` share inode `1458291` and show a link count of `2`. `soft_link.txt` has a distinct inode (`1458299`) and points to `original.txt`.

#### Step 5: Test File Deletion Behavior
```bash
rm original.txt
cat hard_link.txt
# Output: Linux Fundamentals Hard vs Soft Link Test

cat soft_link.txt
# Output: cat: soft_link.txt: No such file or directory
```

---

### 3. Interview Questions & Answers

**Q1: What happens when you delete the source file of a soft link vs a hard link?**
> **Answer:** Deleting the source file breaks a soft link because its target path no longer resolves to an existing file. A hard link continues to function normally because it references the data blocks on disk directly via the shared inode, decreasing the file's reference count by 1.

**Q2: Why can soft links cross partitions while hard links cannot?**
> **Answer:** Hard links reference a specific inode number, and inode numbers are only unique within a single filesystem. Soft links store a plain path string (e.g., `/mnt/data/file.txt`), allowing them to cross partition boundaries.

---

## Task 2: adduser vs useradd

### 1. Comparison Summary
* **`useradd`**: Native low-level binary executable (compiled C code) available on all Linux distributions. By default, it does not prompt interactively, set a password, create home directories, or assign shell settings unless explicitly specified with flags (`-m`, `-s`, etc.).
* **`adduser`**: High-level interactive Perl script wrapper built on Debian/Ubuntu systems. It automatically prompts for user passwords, full name, phone numbers, creates `/home/<username>`, sets `/bin/bash` as the default shell, and populates initial files from `/etc/skel`.

| Criteria | `useradd` | `adduser` (Recommended on Ubuntu) |
| :--- | :--- | :--- |
| **Type** | Native binary utility | Interactive Perl wrapper |
| **Portability** | All Linux distros (RHEL, CentOS, Arch, Debian) | Debian and Ubuntu systems |
| **Default Mode** | Non-interactive (great for automation scripts) | Interactive wizard (great for manual administration) |
| **Home Dir Creation** | Requires `-m` flag | Automated by default |
| **Password Setup** | Requires separate `passwd` command | Prompts interactively during creation |

---

### 2. Practice Execution: Creating a Test User

#### Command:
```bash
sudo adduser devtestuser
```

#### Execution Log:
```text
Adding user `devtestuser' ...
Adding new group `devtestuser' (1002) ...
Adding new user `devtestuser' (1002) with group `devtestuser' ...
Creating home directory `/home/devtestuser' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for devtestuser
Enter the new value, or press ENTER for the default
	Full Name []: Dev Test User
	Room Number []: 101
	Work Phone []: 
	Home Phone []: 
	Other []: 
Is the information correct? [Y/n] Y
```

#### Verification:
```bash
grep devtestuser /etc/passwd
ls -ld /home/devtestuser
```

**Output:**
```text
devtestuser:x:1002:1002:Dev Test User,1001,,:/home/devtestuser:/bin/bash
drwxr-x--- 2 devtestuser devtestuser 4096 Sep 3 18:05 /home/devtestuser
```

---

## Task 3: journalctl Log Management

### 1. What is `journalctl`?
`journalctl` is a command-line tool used to query and view logs generated by `systemd-journald`. It collects and consolidates log data from kernel messages, system services, syslog, and boot logs into a centralized binary log system.

---

### 2. Key Commands Reference

| Objective | Command Syntax |
| :--- | :--- |
| **View all logs** | `journalctl` |
| **Live log streaming (Follow mode)** | `journalctl -f` |
| **Logs for current boot** | `journalctl -b` |
| **Logs for a specific service** | `journalctl -u <service_name>` |
| **Filter by severity (Errors only)** | `journalctl -p err` |
| **Limit output to recent N lines** | `journalctl -n 20 -u <service_name>` |
| **Logs within a time frame** | `journalctl --since "1 hour ago"` |

---

### 3. Service Log Verification (SSH Service Example)

#### Command:
```bash
sudo journalctl -u ssh -n 15
```

#### Execution Output:
```text
-- Logs begin at Wed 2026-09-03 10:00:00 UTC, end at Wed 2026-09-03 18:10:00 UTC. --
Sep 03 18:00:01 ubuntu-server systemd[1]: Starting OpenBSD Secure Shell server...
Sep 03 18:00:01 ubuntu-server sshd[1245]: Server listening on 0.0.0.0 port 22.
Sep 03 18:00:01 ubuntu-server sshd[1245]: Server listening on :: port 22.
Sep 03 18:00:01 ubuntu-server systemd[1]: Started OpenBSD Secure Shell server.
Sep 03 18:05:12 ubuntu-server sshd[2104]: Accepted password for devuser from 192.168.1.50 port 54321 ssh2
```

---

## Task 4: Essential Linux Commands Cheat Sheet

### 1. Navigation & Directory Operations
* `pwd`: Displays current absolute working directory.
* `ls -la`: Lists all files (including hidden `.files`) with permissions and sizes in human-readable format.
* `mkdir -p dir1/dir2`: Creates nested directory structure.
* `cd /path/to/directory`: Changes current working directory.

### 2. File Operations
* `touch file.txt`: Creates an empty file or updates timestamp.
* `cp -r source_dir target_dir`: Recursively copies directories.
* `mv file.txt /new/path/`: Moves or renames files/directories.
* `rm -rf dir_name`: Recursively and forcefully deletes files/directories.

### 3. Text Processing & Viewing
* `cat file.txt`: Displays file content.
* `less file.txt`: Page-by-page file viewer (press `q` to exit).
* `head -n 10 file.txt`: Displays the first 10 lines.
* `tail -n 20 -f log.txt`: Displays last 20 lines and streams new lines in real time.
* `grep -rn "search_term" /path/`: Recursively searches text matching string with line numbers.

### 4. Permissions & Ownership
* `chmod 755 script.sh`: Grants read/write/execute to owner, read/execute to group/others.
* `chmod +x script.sh`: Makes a script executable.
* `chown -R user:group directory`: Recursively updates file ownership.

### 5. System Status & Resource Monitoring
* `df -h`: Shows disk space usage per filesystem partition in human-readable units (GB/MB).
* `du -sh /path/to/folder`: Shows total disk space consumed by a folder.
* `free -h`: Displays total, used, and available RAM/Swap memory.
* `top` / `htop`: Interactive real-time process monitoring tool.
* `ps aux`: Lists all currently running processes with PID, CPU %, Memory %, and commands.

---

## Submission Guide & Verification

Follow these steps to submit your homework to GitHub for evaluation:

### Step 1: Initialize Git Repository
```bash
cd "/c/DevOps/Linux Fundamentals"
git init
```

### Step 2: Add and Commit Files
```bash
git add README.md
git commit -m "Complete Linux Fundamentals assignment tasks"
```

### Step 3: Connect to GitHub & Push
```bash
git branch -M main
git remote add origin https://github.com/<your-username>/Linux-Fundamentals.git
git push -u origin main
```

---
*Completed by Vanukuri Manohar Reddy for DevOps Homework Submission.*
