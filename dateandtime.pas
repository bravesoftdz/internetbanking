unit dateAndTime;

interface
	
	uses Dos, sysutils;

	procedure getDateString(var date : string);
	procedure turnDateToInt(var day, month, year : word; stringDate : string);

implementation
	procedure getDateString(var date : string);
	var
		mday, wday, year, month : word;

	begin
		GetDate(year,month,mday,wday);
		writeln(year);
		writeln(month);
		writeln(mday);
		date := IntToStr(mday) + '/' + IntToStr(month) + '/' + IntToStr(year);
		writeln(date);
	end;

	procedure turnDateToInt(var day, month, year : word; stringDate : string);

	var
		i : integer;
	 	dayString, monthString, yearString : string;

	begin
		i := 1;
		dayString := '';
		monthString := '';
		yearString := '';
		repeat
			dayString := dayString + stringDate[i];
			i := i + 1; 
		until (stringDate[i] = '/');
		i := i + 1;
		repeat
			monthString := monthString + stringDate[i];
			i := i + 1; 
		until (stringDate[i] = '/');
		i := i + 1;
		repeat
			yearString := yearString + stringDate[i];
			i := i + 1; 
		until (stringDate[i] = '/') or (i > length(stringDate));
		day := StrToInt(dayString);
		month := StrToInt(monthString);
		year := StrToInt(yearString);
	end;
end.