# logmini.sh — Simple Log Analyzer

## Executive Summary
The **logmini.sh** script is a lightweight Bash tool that analyzes log files. It can count errors and warnings, search for specific events using regular expressions, and export results to a file. This makes it useful for administrators, developers, or students who want a fast way to interpret log data without heavy external tools.

---

## Purpose
This script was created to fulfill an assignment requirement:
- Take options and arguments
- Include a `-h` help option
- Handle invalid arguments
- Change output depending on options
- Use regular expressions
- Interact with files

---

## Features
- Takes multiple log files as input (`-f FILE`)  
- Help menu (`-h`) with usage examples  
- Error handling for invalid/missing arguments or unreadable files  
- Two output modes:
  - Counts (`-c`, default)  
  - Events (`-e`)  
- Regex filtering (`-p PATTERN`)  
- Save output to a file (`-o FILE`)  

---

## Setup

1. Open **Terminal** on Mac (or Linux).  
2. Navigate into the project folder (example if on Desktop):  
   ```bash
   cd ~/Desktop/logmini
3.	Make the script executable (first time only): chmod +x logmini.sh


## USUAGE
Basic: ./logmini.sh -f <logfile> [options]


Options:
	•	-f FILE : Log file to read (repeatable)
	•	-p REGEX : Filter by regex
	•	-e : Event mode (print matching lines)
	•	-c : Counts mode (default)
	•	-o FILE : Save results to file
	•	-h : Help menu

## Running All Tests 

✅ Test 1 — Count severities in sample.log
./logmini.sh -f sample.log

CRITICAL  1
FATAL     0
ERROR     1
WARN      1
NOTICE    0
INFO      1
DEBUG     1
TOTAL     5

Explanation: One entry each for CRITICAL, ERROR, WARN, INFO, and DEBUG.


✅ Test 2 — Count severities in errors.log'
./logmini.sh -f errors.log

CRITICAL  2
FATAL     0
ERROR     3
WARN      0
NOTICE    0
INFO      0
DEBUG     0
TOTAL     5

Explanation: Only ERROR and CRITICAL messages are present.


✅ Test 7 — Save summary output to a file
./logmini.sh -f errors.log -c -o report.txt
CRITICAL  2
FATAL     0
ERROR     3
WARN      0
NOTICE    0
INFO      0
DEBUG     0
TOTAL     5

Explanation: Instead of printing to screen, the results are saved into report.txt.


