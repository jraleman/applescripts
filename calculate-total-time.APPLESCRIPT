-- time the following operation:
--set start_time to (time of (current date)) -- start timing

set this_folder to (choose folder with prompt "Pick the folder containing the video files to process:") as string

set video_ext_list to {"3g2", "3gp", "3gp2", "3gpp", "3mm", "60d", "aep", "ajp", "amv", "asf", "asx", "avb", "avi", "avs", "bik", "bix", "box", "byu", "cvc", "dce", "dif", "dir", "divx", "dv", "dvr-ms", "dxr", "eye", "fcp", "flc", "fli", "flv", "flx", "gl", "grasp", "gvi", "gvp", "ifo", "imovieproject", "ivf", "ivs", "izz", "izzy", "lsf", "lsx", "m1v", "m2v", "m4e", "m4u", "m4v", "mjp", "mkv", "moov", "mov", "movie", "mp4", "mpe", "mpeg", "mpg", "mpv2", "msh", "mswmm", "mvb", "mvc", "nvc", "ogm", "omf", "prproj", "prx", "qt", "qtch", "rm", "rmvb", "rp", "rts", "sbk", "scm", "smil", "smv", "spl", "srt", "ssm", "svi", "swf", "swi", "tivo", "ts", "vdo", "vf", "vfw", "vid", "viewlet", "viv", "vivo", "vob", "vro", "wm", "wmd", "wmv", "wmx", "wvx", "yuv"}

tell application "Finder"
	set these_files to ((files of folder this_folder whose name extension is in video_ext_list) as alias list)
end tell

set filesCount to count of these_files

set total_duration_of_files_in_seconds to ""
set files_with_no_duration to 0

repeat with i from 1 to filesCount
	set this_file to (item i of my these_files)
	set this_info to info for this_file
	if visible of this_info is true and alias of this_info is false then
		-- insert actions here for: this_file
		set this_file_duration_in_seconds to do shell script "mdls -name kMDItemDurationSeconds -raw -nullMarker 0 " & quoted form of POSIX path of this_file
		if this_file_duration_in_seconds is not 0 then
			set total_duration_of_files_in_seconds to total_duration_of_files_in_seconds + this_file_duration_in_seconds
		else
			set files_with_no_duration to files_with_no_duration + 1
		end if
	end if
end repeat

set total_duration_in_hms to do shell script " echo " & total_duration_of_files_in_seconds & " | awk '{printf \"%03d:%02d:%02d\",$0/3600,$0%3600/60,$0%60}'"

(*
set end_time to (time of (current date)) -- stop timing.
set elapsed_time to end_time - start_time
log "2. elapsed_time is is " & elapsed_time & " seconds."
*)

display dialog "Files processed : " & (count of these_files) & return & "Files without duration : " & files_with_no_duration & return & "Total duration of " & (count of these_files) - files_with_no_duration & " files in h:m:s : " & total_duration_in_hms with title "Length of all videos in a folder" buttons {"OK"} default button 1