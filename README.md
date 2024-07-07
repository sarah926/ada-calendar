# ada-calendar
Created a visual calendar printing in the command line using Ada.
Prompts user for the year (must be after 1582), prints a banner out of numbers with the year at the top and then prints the whole calendar year in an aesthetic readable format.
To compile and run:
1. gcc -c cal.adb  
2. gnatmake cal.adb
3. ./cal

# setup with ada
- installed ada gnat compiler from https://github.com/simonjwright/distributing-gcc/releases
- set path as export PATH=/opt/gcc-13.2.0-aarch64/bin:$PATH

- uses a text file called numbers.txt to read in the numbers
