extends Node

enum Month { JAN = 1, FEB = 2, MAR = 3, APR = 4, MAY = 5, JUN = 6, JUL = 7,
		AUG = 8, SEP = 9, OCT = 10, NOV = 11, DEC = 12 }

const MONTH_NAME = [ 
		"Jan", "Feb", "Mar", "Apr", 
		"May", "Jun", "Jul", "Aug", 
		"Sep", "Oct", "Nov", "Dec" ]

const WEEKDAY_NAME = [ 
		"Sunday", "Monday", "Tuesday", "Wednesday", 
		"Thursday", "Friday", "Saturday" ]

func get_days_in_month(month : int, year : int) -> int:
	var number_of_days : int
	if(month == Month.APR || month == Month.JUN || month == Month.SEP
			|| month == Month.NOV):
		number_of_days = 30
	elif(month == Month.FEB):
		var is_leap_year = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
		if(is_leap_year):
			number_of_days = 29
		else:
			number_of_days = 28
	else:
		number_of_days = 31
	
	return number_of_days

func get_weekday(day : int, month : int, year : int) -> int:
	var t : Array = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
	if(month < 3):
		year -= 1
	return (year + year/4 - year/100 + year/400 + t[month - 1] + day) % 7

func get_weekday_name(day : int, month : int, year : int) -> String:
	var day_num = get_weekday(day, month, year)
	return WEEKDAY_NAME[day_num]

func get_month_name(month : int) -> String:
	return MONTH_NAME[month - 1]

func hour() -> int:
	return OS.get_datetime()["hour"]

func minute() -> int:
	return OS.get_datetime()["minute"]

func second() -> int:
	return OS.get_datetime()["second"]

func day() -> int:
	return OS.get_datetime()["day"]

func weekday() -> int:
	return OS.get_datetime()["weekday"]

func month() -> int:
	return OS.get_datetime()["month"]

func year() -> int:
	return OS.get_datetime()["year"]

func daylight_savings_time() -> int:
	return dst()

func dst() -> int:
	return OS.get_datetime()["dst"]
