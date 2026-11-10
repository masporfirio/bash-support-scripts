# Lab: disk space, memory and networking with Bash

**Level:** beginner. **Suggested duration:** 30–45 minutes.

Materials: [script](../../scripts/system_info.sh) and
[study guide](../../docs/system-info-study-guide.md).

## Objectives

- Run a script and distinguish syntax checks from actual execution.
- Interpret available disk space, memory and basic network configuration.
- Explain variables, command substitution, `case`, pipes and filtering with `awk`.

## 1. Prepare

Open a terminal on Linux or macOS. If you do not have the repository yet:

```bash
git clone https://github.com/masporfirio/bash-support-scripts.git
cd bash-support-scripts
```

Otherwise, enter the root of your up-to-date copy. Check the environment:

```bash
pwd
ls scripts/system_info.sh
uname -s
bash -n scripts/system_info.sh
```

`pwd` prints the current directory. `ls` confirms that the file exists.
`uname -s` identifies the system. A successful `bash -n` check normally prints
nothing; it does not run the report.

## 2. Read before running

Open the script in an editor or use:

```bash
cat scripts/system_info.sh
```

`cat` prints the file contents. Identify the section headings, the `system`
variable, both `case` statements and the commands your computer will run.

## 3. Run and inspect

```bash
bash scripts/system_info.sh
echo "$?"
```

Run `echo "$?"` immediately after the script. `$?` holds the previous command's
exit status; zero normally indicates success. In this version, also inspect
every section because the script does not combine all errors into one status.

Check for the disk, memory and network headings. If a section is empty or a
command reports an error, record the command and error message rather than
treating the collection as complete. Consult the limitations in the guide.

## 4. Interpret the output

Record your answers in local study notes:

1. Which system was detected? Which `case` alternative ran?
2. Which mount point did you choose? How much space is available there?
3. On Linux, how do `free` and `available` differ? On macOS, which values appear
   in `PhysMem`, and what do they describe?
4. Which interface is loopback? Which other interface has an IP address?
5. Is a default gateway present? Which interface uses it? If absent, what is
   the observed context?
6. Why do these observations still not prove that internet access and DNS work?

## 5. Run each command separately

On both platforms:

```bash
df -h
```

On Linux only:

```bash
free -h
ip -brief address
ip route show
```

On macOS only:

```bash
top -l 1 -n 0
top -l 1 -n 0 | awk '/^PhysMem:/ { print }'
ifconfig
route -n get default
```

Compare the complete `top` output with the filtered output. Values may change
between samples because the system continues running.

## 6. Review questions

1. What does `$(...)` do? Why is `system = value` not a valid Bash assignment?
2. What are `;;`, `*)` and `esac` used for?
3. Where does the data travel through the memory command's pipe?
4. What does `^` mean in the `awk` filter?
5. Why does `bash -n` not detect a missing `free` command?
6. How do `bash script.sh` and `./script.sh` differ regarding execute permission?

## 7. Optional challenge

Make a copy to experiment with:

```bash
cp scripts/system_info.sh scripts/system_info_exercise.sh
```

`cp` creates the copy. In that copy, add a heading showing the detected system
using `printf` and the existing variable. Check it with `bash -n` and run it.
Next, investigate missing-command detection with `command -v` and how
`set -o pipefail` changes a pipeline's exit status. Do not change the network
configuration or fill the disk to perform this exercise.

## Completion criteria

- [ ] I read and explained the commands for my operating system.
- [ ] I checked the syntax and ran the script locally.
- [ ] I inspected all three sections and resolved or documented any errors.
- [ ] I recorded and interpreted disk, memory, interfaces and routing information.
- [ ] I answered the questions in my own words.

**Initial status:** materials prepared; student practice has not yet been verified.
Record the date, operating system and observations after completing the activity.
