# mygrep.sh - Mini grep

This repository contains a mini version of the `grep` command implemented as a Bash shell script (`mygrep.sh`).

## Features

This script supports the following basic functionalities command:

* **Case-insensitive search:** Searches for a given string within a text file, ignoring case.
* **Print matching lines:** Displays the lines from the file that contain the search string.

It also includes the following command-line options:

* `-n`: Shows the line numbers for each matching line.
* `-v`: Inverts the match, printing lines that do not contain the search string.
* `-vn` or `-nv`: Combines the `-v` and `-n` options.
* `--help`: Prints usage information (Bonus).

## Usage
To use the script, make it executable and run it from your terminal:

```bash
chmod +x mygrep.sh
./mygrep.sh [OPTIONS] PATTERN FILE
