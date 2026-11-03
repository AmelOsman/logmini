# logmini

A lightweight Bash log analyzer for quick triage on Linux systems. Point it at one or more log files to get a **severity summary**, or switch to **event mode** to pull out the exact lines you care about with a regex.

Built as the final project for Scripting Language (IT 3038C) at the University of Cincinnati.

## Features
- **Severity counts:** tallies CRITICAL, FATAL, ERROR, WARN/WARNING, NOTICE, INFO, and DEBUG (case-insensitive)
- **Event mode:** prints every line that matches a regex, like a failed-login IP or a service name
- **Multiple files:** analyze several logs in one run with repeated `-f` flags
- **Save results:** write output to a file with `-o` for reports or later review
- **Safe by default:** strict mode (`set -euo pipefail`), input validation, and clear error messages

## Usage
```bash
chmod +x logmini.sh
./logmini.sh -f <logfile> [-f <logfile> ...] [options]
```

| Option | Description |
|---|---|
| `-f FILE` | Log file to read (repeatable) |
| `-p REGEX` | Only include lines matching this regex (POSIX ERE) |
| `-e` | Event mode: print matching lines |
| `-c` | Counts mode: summarize severities (default) |
| `-o FILE` | Write output to a file instead of the screen |
| `-h` | Show help |

## Examples
**Summarize a log by severity:**
```console
$ ./logmini.sh -f sample.log
CRITICAL 1
FATAL    0
ERROR    2
WARN     2
NOTICE   1
INFO     2
DEBUG    1
TOTAL    9
```

**Investigate a suspicious IP (event mode):**
```console
$ ./logmini.sh -f sample.log -e -p '203\.0\.113\.45'
2025-10-01 08:02:14 WARNING sshd[1188]: Failed password for invalid user admin from 203.0.113.45
2025-10-01 08:02:16 WARNING sshd[1188]: Failed password for invalid user admin from 203.0.113.45
2025-10-01 08:02:19 ERROR sshd[1188]: Too many authentication failures for admin from 203.0.113.45
```

**Count only SSH-related severities across multiple logs and save the report:**
```bash
./logmini.sh -f auth.log -f syslog -p sshd -o ssh-report.txt
```

A small [`sample.log`](./sample.log) is included so you can try it right away.

## How It Works
1. Validates options and confirms every log file is readable.
2. Combines the input files and, if `-p` is set, filters lines with `grep -E`.
3. **Counts mode:** extracts severity keywords with `grep -o` and tallies them with `awk`, normalizing case and treating WARNING as WARN.
4. **Event mode:** prints the filtered lines as-is.
5. Sends the result to the screen or to the file given with `-o`.

## Changelog
- **v1.1:** Fixed lowercase `warning` lines not being counted, and fixed the script exiting with no output when a log contains no severity keywords.
- **v1.0:** Original course submission.
