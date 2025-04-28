## Reflective Section

### Argument and Option Handling

The script's argument and option handling begins by immediately checking if the first command-line argument (`$1`) is exactly `--help`. If it is, the `print_usage` function is called to display instructions on how to use the script, and then the script exits with a success code (0).

For processing the standard short options (`-n` and `-v`), the `getopts` command is employed within a `while` loop. The option string `"nv"` tells `getopts` to look for these specific options. As each valid option is found, it is stored in the `$opt` variable, and a `case` statement is used to determine which option was encountered. If `$opt` is `n`, the `show_line_numbers` variable is set to `true`. If `$opt` is `v`, the `invert_match` variable is set to `true`. If `getopts` encounters an option not in the `"nv"` string, the `\?)` case is matched, an error message indicating an invalid option is printed to standard error, the `print_usage` function is called, and the script exits with an error code (1).

After the `while` loop finishes processing all the options, the `shift $((OPTIND - 1))` command is crucial. The `OPTIND` variable is set by `getopts` to the index of the next argument to be processed. By shifting the positional parameters, we effectively remove the processed options from the beginning of the argument list, ensuring that `$1` now correctly refers to the `PATTERN` and `$2` to the `FILE` provided by the user.

Finally, the script checks if the number of remaining positional arguments (`$#`) is exactly 2 (the pattern and the filename). If not, an error message is printed, the usage information is displayed, and the script exits.

### Potential Future Improvements

To enhance `mygrep.sh` with regular expression support (similar to `grep -E`), I would introduce a new command-line option, perhaps `-E`, using `getopts`. When this option is detected, a flag variable (`regex_mode`) would be set to `true`. In the main search loop, if `regex_mode` is true, I would use Bash's `=~` operator directly with the `$trimmed_line` and `$pattern` without any case conversion. This would allow for more complex pattern matching.

For implementing case-sensitive search (like `grep -i`), I would add an `-i` option to the `getopts` string. Upon encountering this option, an `ignore_case` flag (currently defaulted to `true`) would be set to `false`. The conditional statement performing the search would then be modified to use a direct string comparison (`[[ "$trimmed_line" == "$pattern" ]]`) when `ignore_case` is `false`, bypassing the lowercase conversion.

Adding a count of matching lines (`grep -c`) would involve introducing a counter variable initialized to zero. Inside the main loop, whenever a match is found based on the current options, this counter would be incremented. If a `-c` option (added via `getopts`) is detected, the script would, after processing the entire file, print only the final count and suppress the printing of the individual matching lines.

To support listing only filenames containing matches (`grep -l`), the script would need to handle multiple file arguments. An outer loop would iterate through each provided filename. Inside this loop, a boolean flag (`found_match`) would be used to track if any match was found in the current file. If the `-l` option (added via `getopts`) is present, after processing each file, the script would check the `found_match` flag. If it's true, the current filename would be printed, and the script would then proceed to the next file. The inner loop for processing lines would likely break after the first match in a file if `-l` is active to mimic `grep`'s behavior.

### Hardest Part of Implementation

The most challenging aspect of developing `mygrep.sh` was ensuring the correct and logical interaction between the `-v` (invert match) and `-n` (show line numbers) options, particularly when they were used in combination (`-vn`). Carefully structuring the nested `if` statements to apply both conditions correctly – printing non-matching lines along with their numbers – required thorough testing and debugging. Initially, there were scenarios where the line numbers were not being displayed correctly for inverted matches or where the logic for inverting was not consistently applied. Additionally, handling the subtle differences in how the `read` command processes the last line of a file, especially when it lacks a trailing newline character, and then ensuring that trailing empty lines were correctly ignored without affecting the processing of the actual content lines, proved to be another significant hurdle that required careful refinement of the loop condition and line processing logic.
