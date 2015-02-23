#Put Powershell script in root folder
#Searches all subfolders of root file

#For Canon Raws
$Files = Get-ChildItem -recurse -filter *.CR2

foreach ($file in $Files) 
{
	#Access Exif data using Exiftool by Phil Harvey
	#Download from http://www.sno.phy.queensu.ca/~phil/exiftool/
	#Put exiftool.exe in root folder (where the Powershell script is)
	$meta=([xml](.\exiftool.exe $file.fullname -X -r)).rdf.description

	#Get date and time photo was taken
	$date = $meta.DateTimeOriginal
	
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
	
	#Error handling
	trap
	{
		#if an error occurs move picture into designated error folder
		$FailedPicturePath = "C:\Users\Allie\Pictures\PhotoMove\FailedPictures"
		copy-item $file.fullname $FailedPicturePath
		
		#throw message error and stop execution
		Write-Host "An error has occured!"
		Write-Host $_.ErrorID
		Write-Host $_.Exception.Message
		break
	}
 }