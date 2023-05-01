extends Node

func join(arr, seperator):
	return seperator.join(arr);
	
func seperate(currentstring, delimiter):
	return currentstring.split(delimiter);
	
func split(currentstring, delimiter):
	return currentstring.split(delimiter);

func uppercase(currentstring):
	return currentstring.to_upper();

func lowercase(currentstring):
	return currentstring.to_lower();
	
func removefromstring(fullstring, substring):
	var t = positioninstring(fullstring, substring);
	if t == -1:
		return fullstring;
	else:
		return removefromstring(getroot(fullstring, substring) + getbranch(fullstring, substring), substring);

func isinstring(fullstring, substring):
	if substring in fullstring:	return true;
	return false;

func positioninstring(fullstring, substring, start = 0):
	return fullstring.find(substring, start);

func letterat(currentstring, position = 0):
	return currentstring.substr(position, 1);
	
func mid(currentstring, start = 0, length = 1):
	return currentstring.substr(start, length);
	
func left(currentstring, length = 1):
	return currentstring.left(length);

func right(currentstring, length = 1):
	return currentstring.right(length);
	
func removefromleft(currentstring, length = 1):
	return right(currentstring, (currentstring.length()) - length);

func removefromright(currentstring, length = 1):
	return left(currentstring, (currentstring.length()) - length);
	
func reversetext(currentstring):
	var reversedstring = "";
	
	var i = 0;
	while (i < currentstring.length()):
		reversedstring += currentstring.substr(currentstring.length() - i - 1, 1);
		i += 1;
	
	return reversedstring;

func replacechar(currentstring, ch = "|", ch2 = ""):
	return currentstring.replace(ch, ch2);

func getlastbranch(currentstring, ch):
	var i = currentstring.length() - 1;
	
	while (i >= 0):
		if (mid(currentstring, i, 1) == ch):
			return mid(currentstring, i + 1, currentstring.length() - i - 1);
		i = i - 1;
	return currentstring;

func getroot(currentstring, ch):
	var i = 0;
	while (i < currentstring.length()):
		if (mid(currentstring, i, 1) == ch):
			return mid(currentstring, 0, i);
		i = i + 1;
	return currentstring;

func getbranch(currentstring, ch):
	var i = 0;
	while i < currentstring.length():
		if (mid(currentstring, i, 1) == ch):
			return mid(currentstring, i + 1, currentstring.length() - i - 1);
		i = i + 1;
	return currentstring;

func getbetweenbrackets(currentstring):
	while (mid(currentstring, 0, 1) != "(" && currentstring.length() > 0):
		currentstring = mid(currentstring, 1, currentstring.length() - 1);
	while (mid(currentstring, currentstring.length()-1, 1) != ")" && currentstring.length() > 0):
		currentstring = mid(currentstring, 0, currentstring.length() - 1);
	
	if (currentstring.length() <= 0):
		return "";
	return mid(currentstring, 1, currentstring.length() - 2);

func trimspaces(currentstring):
	while (mid(currentstring, 0, 1) == " " && currentstring.length() > 0):
		currentstring = mid(currentstring, 1, currentstring.length() - 1);
	while (mid(currentstring, currentstring.length() - 1, 1) == " " && currentstring.length() > 0):
		currentstring = mid(currentstring, 0, currentstring.length() - 1);
	
	while (mid(currentstring, 0, 1) == "\t" && currentstring.length() > 0):
		currentstring = mid(currentstring, 1, currentstring.length() - 1);
	while (mid(currentstring, currentstring.length() - 1, 1) == "\t" && currentstring.length() > 0):
		currentstring = mid(currentstring, 0, currentstring.length() - 1);
	
	if (currentstring.length() <= 0):
		return "";
	return currentstring;

func isnumber(currentstring):
	if currentstring.is_valid_float():
		return true;
		
	if currentstring.is_valid_integer():
		return true;
	
	return false;
