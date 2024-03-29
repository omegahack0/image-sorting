# image-sorting
sorts images by date captured, using powershell script and exiftool

These scripts will sort images by date and insert them into dated folder.
For example an image taken on the 22nd of February 2015 will be moved into a folder called 2015-02-22.
The location of the folder '2015-02-22' is determined in the script. See How to section below.

It is recommended you read this document in full before using the scripts!

There are two scripts currently available. One for Canon Raw images and one for Jpegs.

Bear in mind these scripts have been tested on small subsets of files and are not optimized to 
process thousands of images at once. The processing power of you computer will also determine the
speed at which these images will be processed.

## Requirements 

* Powershell 2.0.1.1 or higher
* exiftool by Phil Harvey - http://www.sno.phy.queensu.ca/~phil/exiftool/

## How to use it
1. Put the chosen script into the root folder where your images reside
2. Download the exiftool by Phil Harvey - http://www.sno.phy.queensu.ca/~phil/exiftool/
3. Put the efixtool file in the same directory as the script
4. When the date of capture is not available in the image's metadata, the file is moved to a 'no date' folder: 
	On line 28 in the script, specify the path where these images will be moved to. For example:
	$noDatePath = "c:\*Insert path here*\failed-sorting\no-dates"
5. On line 53 in the script, in the first part of the string, 
	specify which path you want the pictures saved to:
		$targetpath = "C:\*insert file path here*" + "\" + $stryear + "\" + $datetaken
6. If an error occurs, the image will be moved into an error folder. Specify the path to this folder
   on line 71
		$FailedPicturePath = "C:\*Path to failed images*"

## Work in progress

* Optimize script for large file stores
* Incorporate better error handling
* One script to rule them all!
