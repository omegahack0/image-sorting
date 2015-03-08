#Put Powershell script in root folder
#Searches all subfolders of root file

#For Canon Raws
$Files = Get-ChildItem -recurse -filter *.CR2

if($Files -eq $null) 
{
	write-host "No Canon Raws in this folder" -ForegroundColor Yellow
	Exit
}

foreach ($file in $Files) 
{
	#Access Exif data using Exiftool by Phil Harvey
	#Download from http://www.sno.phy.queensu.ca/~phil/exiftool/
	#Put exiftool.exe in root folder (where the Powershell script is)
	$meta=([xml](.\exiftool.exe $file.fullname -X -r)).rdf.description

	#Get date and time photo was taken
	$date = $meta.DateTimeOriginal
	
	if([string]::IsNullOrEmpty($date)) 
	{
		try
		{
			write-host $file.fullname + ": has no capture date" -ForegroundColor Red
			$noDatePath = "*insert file path here*"
			write-host "moving file to " + $noDatePath -ForegroundColor Red
			copy-item $file.fullname $noDatePath
			Remove-Item $file.fullname
		}
		catch
		{
			write-host "Caught an exception:" -ForegroundColor Red
			write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
			write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
		}
	}
	else
	{
		try
		{
			#build Year, Month, Day
			$stryear = $date.Substring(0, 4)
			$strmonth = $date.Substring(5, 2)
			$strday = $date.Substring(8, 2)
	
			#build folder name
			$datetaken = $stryear + "-" + $strmonth + "-" + $strday
	
			#path pictures are copied to
			$targetpath = "C:\Users\Allie\Pictures\PhotoMove" + "\" + $stryear + "\" + $datetaken
   
			#if folder exists copy file into path
			#else create folder and copy into path
			if (test-path $targetpath)
			{
			copy-item $file.fullname $targetpath
			remove-item $file.fullname
			}
			else
			{
				new-item $targetpath -type directory
				copy-item $file.fullname $targetpath
				remove-item $file.fullname
			}
			
			write-host $file.fullname + ": moved to " + $targetpath -ForegroundColor Green
		}
		catch
		{
			$failedPicturePath = "*insert file path here*"
			copy-item $file.fullname $failedPicturePath -ForegroundColor Red

			write-host $file.fullname + ": moved to " + $failedPicturePath
			write-host "Caught an exception:" -ForegroundColor Red
			write-host "Exception Type: $($_.Exception.GetType().FullName)" -ForegroundColor Red
			write-host "Exception Message: $($_.Exception.Message)" -ForegroundColor Red
		}
	}
}
