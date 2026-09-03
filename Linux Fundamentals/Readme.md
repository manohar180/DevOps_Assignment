# Linux Fundamentals Assignment

**Name:** Vanukuri Manohar Reddy
**Course:** DevOps Fundamentals


Hey! This is my README for the Linux Fundamentals module. I went through the tasks and tested these commands on my local WSL setup to see how they actually work in practice. Here are my notes and outputs.

---

## Task 1: Soft Links vs. Hard Links

* **Soft Link (Symlink):** This is exactly like a "Shortcut" in Windows. It’s just a file that points to the file path of the original. If I delete the original file, the soft link breaks and becomes useless (a dangling link). It gets a brand new inode number.
* **Hard Link:** This is like creating a second physical doorway to the exact same room of data on the hard drive. It shares the exact same inode number as the original file. If I delete the original file, the hard link still works perfectly because the underlying data hasn't been deleted yet.

### My Hands-on Test

First, I created a dummy file:

```bash
echo "Testing out Linux links for DevOps" > original.txt

```

Then I created both types of links:

```bash
ln original.txt hard_link.txt      # Created the hard link
ln -s original.txt soft_link.txt   # Created the soft link (-s flag)

```

To prove they work differently, I checked their inodes using `ls -li`:

```text
1458291 -rw-r--r-- 2 manohar manohar 35 Sep 3 18:00 hard_link.txt
1458291 -rw-r--r-- 2 manohar manohar 35 Sep 3 18:00 original.txt
1458299 lrwxrwxrwx 1 manohar manohar 12 Sep 3 18:01 soft_link.txt -> original.txt

```

*Notice how `original.txt` and `hard_link.txt` share the exact same inode `1458291`, but `soft_link.txt` gets its own.*

**Interview Question Prep:** "What happens if you delete the source file?"
If I run `rm original.txt`, the hard link will still output "Testing out Linux links for DevOps" if I cat it. But if I try to `cat soft_link.txt`, the terminal will throw a "No such file or directory" error because the path it points to is gone. Also, hard links can't cross different file systems, but soft links can!

---

## Task 2: `adduser` vs `useradd`

I used to think these were the exact same thing, but they behave totally differently on Ubuntu/WSL.

* **`useradd`:** This is the low-level, native command. If I just run `useradd newuser`, it barely does anything. It doesn't prompt me for a password, it doesn't create a home directory (unless I pass the `-m` flag), and it doesn't set a default shell. It's meant for background automation scripts, not real people.
* **`adduser`:** This is the one we *should* be using on Ubuntu. It’s actually a Perl script that runs `useradd` in the background but adds a nice interactive wizard.

### Creating a Test User

I used `adduser` to create a test user, and it automatically set up the home folder and prompted me for all the details:

```bash
sudo adduser devtestuser

```

**What happened:**

```text
Adding user `devtestuser' ...
Creating home directory `/home/devtestuser' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
Changing the user information for devtestuser
	Full Name []: Dev Test User
	Room Number []: 
Is the information correct? [Y/n] Y

```

Much easier! I verified it by checking `/etc/passwd` and saw the user was added with `/bin/bash` ready to go.

---

## Task 3: `journalctl`

`journalctl` is basically the master log reader for Linux systems running `systemd`. Instead of hunting down individual text files in `/var/log`, `journalctl` pulls everything (kernel logs, boot logs, service logs) into one place.

Here are the commands I found most useful during practice:

* `journalctl` -> Dumps every log ever (usually too much info).
* `journalctl -b` -> Shows logs just for the current boot session.
* `journalctl -f` -> "Follow" mode. It prints logs live as they happen, which is awesome for debugging a crashing app.

### Checking a Specific Service

To check the logs for just one service (like SSH), I used the `-u` (unit) flag and `-n` to limit it to the last 15 lines so it wouldn't flood my terminal:

```bash
sudo journalctl -u ssh -n 15

```

It printed out the recent SSH daemon startups and connection attempts.

---

## Task 4: My Linux Command Cheat Sheet

I practiced these essential commands to navigate around my WSL terminal. Here's my quick reference guide:

### Moving Around

* `pwd`: "Print working directory" - tells me exactly what folder I'm currently in.
* `ls -la`: Lists everything in a folder, including hidden files (the `-a`) and shows permissions (the `-l`).
* `cd /path/`: Changes my directory.

### Messing with Files

* `mkdir -p project/src`: Makes a new directory. The `-p` is great because it creates parent folders if they don't exist yet.
* `touch newfile.txt`: Creates a blank file.
* `cp -r folder1 folder2`: Copies a folder. Need the `-r` (recursive) if it's a directory!
* `mv file.txt /new/path/`: Moves a file, but I also use this just to rename files.
* `rm -rf folder/`: The dangerous one. Force deletes a folder and everything inside it without asking.

### Reading Files

* `cat file.txt`: Spits the whole file output into the terminal.
* `head -n 10 file.txt` / `tail -n 10 file.txt`: Shows just the first or last 10 lines of a file.

### Permissions (The tricky part)

* `chmod +x script.sh`: Makes a script executable so I can run it.
* `chown user:group file.txt`: Changes who owns the file.

### System Checks

* `top` (or `htop`): Opens a live task manager showing what's eating my CPU/RAM.
* `df -h`: Shows how much hard drive space I have left (in human-readable sizes like GB).
* `free -h`: Shows my current RAM usage.