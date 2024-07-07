-- Sarah Toll
-- ID# 1159798
-- this file is to implement printing a visual calendar based on a year the user inputted
with Ada.Text_IO; use Ada.Text_IO;
procedure cal is
    infp : file_type; 
    type monthcal is array(1..6, 1..7) of integer;
    type number is array(1..10, 1..7) of character;
    type params is array(1..4) of number;
    type allnumbers is array(0..9) of number;
    -- check if the year is valid in the gregorian calendar
    function isvalid(year : in integer) return boolean is
    begin
        if year >= 1582 then 
            return true;
        end if;
        return false;
    end isvalid;
    -- checks if the year is a leap year
    function leapyear(year: in integer) return boolean is
    begin
        -- if it is disibible by 4, need to check special cases
        if year rem 4 = 0 then
            if year rem 100= 0 and year rem 400 = 0 then
                return True;
            elsif year rem 100 = 0 then
                return False;
            else
                return True;
            end if;
        end if;
        -- if it not divisible by 4, alwasy false
        return false;
    end leapyear;

    -- get the langauge from the user for the language to print out the months and days in
    procedure getlanguage(lang: out character) is
    begin
        lang := 'a';
        -- loops until the user chooses english or french
        while lang /= 'e' and lang /='f' loop
            put_line("do you want english or french? type e for english or f for french");
            get(lang);
        end loop;
    end;

    -- gets year from the user until it is a valid year
    procedure getyear(year: out integer) is
    begin
        year := -1;
        while not isvalid(year) loop
            put_line("enter the year for the calendar - must be after 1582");
            year := Integer'Value(get_line);
        end loop;
    end;

    -- gets the calendars year, language and the first day based off the formula
    procedure readcalinfo(year: out integer; firstday: out integer; lang : out character) is
    y : integer;
    begin
        getyear(year);
        y:= year - 1;
        firstday := (36 + y + (y / 4) - (y / 100) + (y / 400)) mod 7;
        getlanguage(lang);
    end;
    
    -- gets the number of days in a  month based off the month and year
    function numdaysinmonth(month: in integer; year: in integer) return integer is
    begin
        -- counting january as 0, april, june, september, and november have 30 days
        if month = 3 or month = 5 or month = 8 or month = 10 then
            return 30;
        elsif month = 1 then
        -- this is february
            if leapyear(year) then
                return 29;
            else
                return 28;
            end if;
        -- the rest of the months have 31 days
        else
            return 31;
        end if;
    end numdaysinmonth;
    
    -- prints the rows based off the row in english
    procedure printrowheadingenglish(row: in integer) is
    begin
        if row = 0 then
            put("        January        ");
            put("        February        ");
            put("        March        ");
        elsif row = 1 then
            put("        April        ");
            put("          May          ");
            put("         June         ");
        elsif row = 2 then
            put("         July         ");
            put("        August        ");
            put("        September        ");
        else
            put("        October        ");
            put("        November        ");
            put("        December        ");
        end if;
        put_line("");
        -- pritns all the headings for the days
        put(" Su Mo Tu We Th Fr Sa   ");
        put("Su Mo Tu We Th Fr Sa   ");
        put_line("Su Mo Tu We Th Fr Sa");

    end;

    -- prints headings of the months in french based on the row
    procedure printrowheadingfrench(row: in integer) is
    begin
        if row = 0 then
            put("        Janvier        ");
            put("        Février        ");
            put("        Mars        ");
        elsif row = 1 then
            put("        Avril         ");
            put("         Mai         ");
            put("         Juin        ");
        elsif row = 2 then
            put("        Juillet        ");
            put("         Août         ");
            put("        Septembre        ");
        else
            put("        Octobre        ");
            put("        November        ");
            put("        Décembre        ");
        end if;
        put_line("");
        -- prints heading of the rows for the days
        put(" Di Lu Ma Me Je Ve Sa   ");
        put("Di Lu Ma Me Je Ve Sa   ");
        put_line("Di Lu Ma Me Je Ve Sa");

    end;
    procedure printrowheading(lang: in character; row: in integer) is
    begin
        if lang = 'e' then
            printrowheadingenglish(row);
        else
            printrowheadingfrench(row);
        end if; 
    end;
    -- fills in a monthcal object based on the first day and the number of days in the month
    function fillmonth(firstday: in out integer; numdays: in integer) return monthcal is
    diff: integer := 7;
    day : integer;
    month: monthcal;
    firstempty: integer :=0;
    tempfirstday: integer;
    begin
        for row in 0..5 loop
            diff := 7 - firstday;
            -- if it is the first row, needs to indent
            if row = 0 then
                for index in 1..firstday loop
                    month(row+1, index) := 0;
                end loop;
                
                for i in 1..diff loop
                    month(1, i+firstday) := i;
                end loop;
            else
                -- loop through the 7 days and 0 if its over the number of days in a month
                for i in 1..7 loop
                    day := i + row * 7 - firstday;
                    if day > numdays then
                        month(row+1,i) := 0;
                        -- if it is the first empty day, then store what the next first day should be
                        if firstempty = 0 then
                            tempfirstday := i -1;
                            firstempty := 1;
                        end if;
                    else
                        month(row+1, i) := day;
                    end if;
                end loop;
            end if;
        end loop;
        -- change the first day for the next month
        firstday:= tempfirstday;
        return month;
    end fillmonth;

    -- reads in a specific letter from the textfile
    procedure readletter(number1: in out number) is
    begin
        -- each letter is 10 in height and 7 in row
        for i in 1..10 loop
            for j in 1..7 loop
                get(infp, number1(i, j));
            end loop;
        end loop;
    end;
    -- pritn out each of the letters selected, and indent them all so it is centered
    procedure printletters(number1: in number; number2: in number; number3: in number; number4: in number; indent: in integer) is
    begin
        -- loop through each row of the numbers
        for i in 1..10 loop
            --indent the numbers 
            for j in 1..indent loop
                put(" ");
            end loop;
            -- loop through each item in that row for all the numbers
            for j in 1..7 loop
                put(number1(i, j));
            end loop;
            -- put space between for each
            put("   ");
            for j in 1..7 loop
                put(number2(i, j));
            end loop;
            put("   ");
            for j in 1..7 loop
                put(number3(i, j));
            end loop;
            put("   ");
            for j in 1..7 loop
                put(number4(i, j));
            end loop;
            put_line("");
        end loop;
    end;
    --prints the banner on the top of the year in giant numbers
    procedure banner(year: in integer; indent: in integer) is
    nums: allnumbers;
    paramaters: params;
    yearstring : string(1..5);
    currnum: integer;
    begin
        -- read in each of the letters from the text file named 'numbers.txt'
        open(infp,in_file,"numbers.txt");
        for i in 0..9 loop
            readletter(nums(i));
        end loop;
        close(infp);
        -- loop through each integer in the year by converting to string
        yearstring := Integer'Image(year);
        put_line("");
        put_line("");
        for y in 2..5 loop
            -- get each integer back to a character
            currnum := Character'Pos(yearstring(y)) - 48;
            -- for each integer in the year, set the parameters to the number needed
            paramaters(y-1) := nums(currnum);
        end loop;
        --prints the letters based on parameters selected
        printletters(paramaters(1), paramaters(2), paramaters(3), paramaters(4), indent);
        put_line("");
    end;
    --prints one specific month based on the row and monthcal
    procedure printmonth(month: in monthcal; k: in integer) is
    day: integer;
    begin
        for j in 1..7 loop
            day := month(k, j);
            if day < 10 then
                put(" ");
            end if;
            if day /= 0 then
                put(Integer'Image(day));
            else
                put("  ");
            end if;
        end loop;
        put("  ");
    end;
    -- prints the row of each month using print month
    procedure printrowmonth(row: in integer; month1: in monthcal; month2: in monthcal; month3: in monthcal) is
    begin
        printmonth(month1, row);
        printmonth(month2, row);
        printmonth(month3, row);
        put_line("");
    end;
    -- procedure to build the whole calendar
    procedure buildcalendar is
    year : integer;
    lang : character;
    first :integer := 0;
    jan: monthcal;
    feb: monthcal;
    march: monthcal;
    april: monthcal;
    may: monthcal;
    june: monthcal;
    july: monthcal;
    august: monthcal;
    sept: monthcal;
    oct: monthcal;
    nov: monthcal;
    dec: monthcal;
    begin
        -- get year, first day and language for the calendar
        readcalinfo(year, first, lang);
        banner(year, 15);
        put_line("");
        -- initialize the dates of each month
        jan := fillmonth(first, numdaysinmonth(0, year));
        feb := fillmonth(first, numdaysinmonth(1, year));
        march := fillmonth(first, numdaysinmonth(2, year));
        april := fillmonth(first, numdaysinmonth(3, year));
        may := fillmonth(first, numdaysinmonth(4, year));
        june := fillmonth(first, numdaysinmonth(5, year));
        july := fillmonth(first, numdaysinmonth(6, year));
        august := fillmonth(first, numdaysinmonth(7, year));
        sept := fillmonth(first, numdaysinmonth(8, year));
        oct := fillmonth(first, numdaysinmonth(9, year));
        nov := fillmonth(first, numdaysinmonth(10, year));
        dec := fillmonth(first, numdaysinmonth(11, year));

        -- loop through each row of 3 monhts in the calendar
        for r in 0..3 loop
            -- print months and day names based on language
            printrowheading(lang, r);
            -- loop through the weeks
            for k in 1..6 loop
                -- print the row of the month based on the greater row in the whole calendar
                if r = 0 then
                    printrowmonth(k, jan, feb, march);
                elsif r = 1 then
                    printrowmonth(k, april, may, june);
                elsif r = 2 then
                    printrowmonth(k,july, august, sept);
                else
                    printrowmonth(k, oct, nov, dec);
                end if;
            end loop;
            put_line("");
        end loop;
    end;
-- main program just runs build calendar
begin
    buildcalendar;
end cal;
