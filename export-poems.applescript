-- Export every Apple Note tagged #poetry or #poem to plain text files.
-- Reads only. Changes nothing in Notes.
set outFolder to (POSIX path of (path to home folder)) & "Website Builds for Projects/jamesharveywords/notes-export/"
set exported to 0
set logText to ""
with timeout of 7200 seconds
tell application "Notes"
	set allNotes to (every note whose plaintext contains "#poetry" or plaintext contains "#poem")
	repeat with n in allNotes
		set b to ""
		try
			set b to plaintext of n
		end try
		if (b contains "#poetry") or (b contains "#poem") then
			set t to "untitled"
			try
				set t to name of n
			end try
			set fName to "unknown"
			set acct to "unknown"
			try
				set f to folder of n
				set fName to name of f
				set acct to name of container of f
			end try
			set creDate to ""
			set modDate to ""
			try
				set creDate to (creation date of n) as string
				set modDate to (modification date of n) as string
			end try
			set exported to exported + 1
			set safeName to my cleanName(t)
			set fileName to (text -3 thru -1 of ("00" & exported)) & "-" & safeName & ".txt"
			set header to "TITLE: " & t & linefeed & "FOLDER: " & acct & " / " & fName & linefeed & "CREATED: " & creDate & linefeed & "MODIFIED: " & modDate & linefeed & "----" & linefeed & linefeed
			my writeFile(outFolder & fileName, header & b)
			set logText to logText & fileName & tab & creDate & linefeed
		end if
	end repeat
end tell
end timeout
my writeFile(outFolder & "_index.tsv", logText)
display dialog "Exported " & exported & " poems." buttons {"OK"} default button 1

on cleanName(s)
	set bad to {"/", ":", "\\", "*", "?", "\"", "<", ">", "|", linefeed, return, tab}
	set out to ""
	repeat with c in (characters of s)
		set c to c as string
		if bad contains c then
			set out to out & "-"
		else
			set out to out & c
		end if
	end repeat
	if length of out > 60 then set out to text 1 thru 60 of out
	if out is "" then set out to "untitled"
	return out
end cleanName

on writeFile(p, txt)
	do shell script "printf '%s' " & quoted form of txt & " > " & quoted form of p
end writeFile
