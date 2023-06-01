#Function1

function get-allNDrive-size_count {
param($volume,$outfile)
#Testing - only use within the function 
#$outfile="J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol07.csv"
#$volume="01"
$Processed=0
$Path_base="\\10.36.4.5\c$\vol"
$volume_Path=$Path_base+$volume
$Name_Folders = Get-ChildItem -force $volume_Path | ?{ $_.PSIsContainer }| select name
forEach ($N_Drive in $Name_Folders)
    {
        $N_Drive_name=$N_Drive.name
        $N_Drive_to_audit=$volume_Path+'\'+$N_Drive_name
        $N_Drive_to_audit
        $c = (Get-ChildItem -Path $N_Drive_to_audit -File -Recurse -Force -hidden -ErrorAction SilentlyContinue | Measure-Object).Count
        $s = "{0:N4}" -f ((Get-ChildItem -force -Recurse $N_Drive_to_audit -hidden -erroraction silentlycontinue | measure Length -s).sum / 1MB)
        $Processed++
        ($Name_Folders).count
        $Processed
        $c
        $s
        $N_Drive_name+","+$N_Drive_to_audit+","+$s+","+$c | out-file -filepath $outfile -Append
    }
Send-MailMessage  -SMTPServer isd-smtp.ucl.ac.uk -To p.davy@ucl.ac.uk -From noreply@ucl.ac.uk -Subject $outfile -Body "Done"
}


#Function calls
get-allNDrive-size_count "01" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol01.csv"
get-allNDrive-size_count "02" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol02.csv"
get-allNDrive-size_count "03" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol03.csv"
get-allNDrive-size_count "04" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol04.csv"


get-allNDrive-size_count "07" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol07.csv"
get-allNDrive-size_count "05" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol05.csv"
get-allNDrive-size_count "06" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol06.csv"
get-allNDrive-size_count "08" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol08.csv"


get-allNDrive-size_count "09" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol09.csv"
get-allNDrive-size_count "10" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol10.csv"
get-allNDrive-size_count "11" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol11.csv"
get-allNDrive-size_count "12" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol12.csv"


get-allNDrive-size_count "14" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol14.csv"
get-allNDrive-size_count "13" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol13.csv"
get-allNDrive-size_count "15" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol15.csv"
get-allNDrive-size_count "16" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol16.csv"

#Done
get-allNDrive-size_count "17" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol17.csv"
get-allNDrive-size_count "18" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol18.csv"
get-allNDrive-size_count "19" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol19.csv"
get-allNDrive-size_count "20" "J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol20.csv"


                               
#======================================================#

#Function2

function get-path-user_ad_details {
param($volume,$outfile)

#================================
#Testing - only use within the function 
#$outfile="J:\Temp\utnvpda\get-details_vol01_test__20221221-2.csv"
#$volume="01"
#=================================

#read n drive & file count file
$Base_path_vol_Size_file="J:\Temp\utnvpda\All_N_Size_Count\N_drive_Size_count_vol"
$Base_path_vol_Size_file_ext=".csv"
$path_vol_Size_file="$Base_path_vol_Size_file$volume$Base_path_vol_Size_file_ext"
#setheader
$header='N_Drive','Path','Size_Mb','File_Count'
#$vol_N_TotalSize_FileCount=Get-Content -path "$Base_path_vol_Size_file$volume$Base_path_vol_Size_file_ext"
$vol_N_TotalSize_FileCount=import-csv -path $path_vol_Size_file -Delimiter "," -Header $header
#$Ndrive_Input_test=$vol_N_TotalSize_FileCount.path.split("\")

#Path_base
$Path_base="\\10.36.4.5\c$\vol"

#Exception_list
$exceptionlist= Get-Content "J:\Temp\utnvpda\ignore_user_list.csv"

#NoAssociastion test
#$NoAssocTest="NoAssociation"

#UCL-ALL Test
#$UCLALLTest="ucl-all"

$path = gci ($Path_base+$volume)
$path | foreach{
    #Set $a to null at start of loop
    $a="-"
    $name=$_.name
    $Full_path=$Path_base+$Volume+'\'+$name
    $namelength=$name.length
  #get username fromeach volume path (trim) to var
  $a=Get-ADUser -Identity $name -properties memberof,department,description,employeeid,accountexpires,uidnumber,gidnumber,accountexpirationdate,whencreated,lastlogondate
  #Set $a to known value
  #$a="utnvpda"
  #$a=Get-ADUser -Filter {SamAccountName -eq $name } -properties memberof,department,description,employeeid,accountexpires,uidnumber,gidnumber,accountexpirationdate,whencreated

  #LastLogondate
  #set known state
  $lld_Y="-"
  $lld_m="-"
  $lld_d="-"
  # Year xxxx / Month mm / Day dd
  $lld_y=$a.lastlogondate.year
  $lld_m=$a.lastlogondate.month
  $lld_d=$a.lastlogondate.day

  
  #Does AD accout exist
  #set known state
  $ADExists="-"
  $AdUser_test = Get-ADUser -Filter {SamAccountName -eq $name}
  #$AdUser_test
  if ($AdUser_test -eq $null)
        {
        $ADExists="False"
        }
    else
        {
        $ADExists="True"
        }        
    
  #Get File count and size
  $NDrive_Size_mb="-"
  $NDrive_File_Count="-"
  foreach($item in $vol_N_TotalSize_FileCount)
    {
        if ($item.n_drive -eq $name)
        {
        $NDrive_Size_mb=$item.Size_Mb
        $NDrive_File_Count=$item.File_Count
        }
    }
  
  #Exceptionlist check
  if ($exceptionlist.contains($name))
            {
            #echo "In Exception list"
            $nameException="True"
            }
        else
            {
            #echo "Not In Exception list"
            $nameException="False"
            }
  
   #Check for non standard username lenght
   #Set known state
   $namelength7="-"
   if ( $namelength -ne 7) 
            {
            $namelength7="True"
            }
        else
            {
            $namelength7="False"
            }
   
   #True / False if in No Assoc
   #Set variable before terst for known state
   $InNoAssoc_result="-"
   if ($a.distinguishedname -like "*NoAssociation*")
            {
            $InNoAssoc_result="True"
            }
        else
            {
            $InNoAssoc_result="False"
            }        

    #Set default known variablew state until a match is found and state becomes true
    $InUCL_All_result="-"  
    $InLeavers="-" 
    $leavers_Group="-"
    $Group_membership="-" 
    $Group_membership=Get-ADPrincipalGroupMembership $name | select name
        
    foreach($item in $Group_membership)
        {
        #$name
        #$item
        if ($item -like "*ucl-all*" )  
            {
                $InUCL_All_result="True"
            }
        if (($item -like "*rg-ucl-leavers") -or ($item -like "*rg-ucl-leavers-*") )  
            {
                $InLeavers="True"
                $leavers_Group=$item.name
            }
        }  
      
      #Set variables for selection
      #Marked for deletion
      $MarkedForDeletion="-"  
      if ( (($InNoAssoc_result -eq "TRUE") -AND ($leavers_Group -eq "rg-ucl-leavers-365") -AND ($ADExists -eq "TRUE") -AND ($nameException -eq "FALSE") ) -OR (  $ADExists -eq "FALSE"  )     )
            {
            $MarkedForDeletion="TRUE"
            }
        else
            {
            $MarkedForDeletion="FALSE"
            }        
             
#Output to CSV
   $out_data=[pscustomobject] @{
		MarkedForDeletion=$MarkedForDeletion
        Netappfoldername = $name
        NDrive_Size_mb = $NDrive_Size_mb
        NDrive_File_Count = $NDrive_File_Count
        enabled = $a.enabled
        UsernameNot7chars=$namelength7
        OnExpectionList=$nameException
        ADAccountExists = $ADExists
        Member_of_AD_Grp_UCL_All = $InUCL_All_result
        Published_at_OU_NoAssoc = $InNoAssoc_result
        In_leavers = $InLeavers
        Leavers_group = $leavers_Group
        Fullpath = $Full_path
		samaccountname = $a.samaccountname
		givenname = $a.givenname
		surname = $a.surname
        LastlogonYear=$lld_y
        LastLogonMonth=$lld_m	
        LastLogonDay=$lld_d
		employeeid = $a.employeeid #UPI
		accountexpires = $a.accountexpirationdate
		dn = $a.distinguishedname
		upn = $a.userprincipalname
		uidnumber = $a.uidnumber
		gidnumber = $a.gidnumber
		whencreated = $a.whencreated
        description = $a.description
        department = $a.department
       
        }
        #$MarkedForDeletion+","+$name+","+$NDrive_Size_mb+","+$NDrive_File_Count+","+$a.enabled+","+$namelength7+","+$nameException+","+$ADExists+","+$InUCL_All_result+","+$InNoAssoc_result+","+$InLeavers+","+$leavers_Group+","+$Full_path+","+$a.samaccountname+","+$a.givenname+","+$a.surname+","+$lld_y+","+$lld_m+","+$lld_d+","+$a.employeeid+","+$a.accountexpirationdate+","+$a.distinguishedname+","+$a.userprincipalname+","+$a.uidnumber+","+$a.gidnumber+","+$a.whencreated+","+$a.description+","+$a.department | out-file -filepath $outfile -Append
        $out_data | export-csv -Append -Delimiter ',' -Path $outfile   
   }
Send-MailMessage  -SMTPServer isd-smtp.ucl.ac.uk -To p.davy@ucl.ac.uk -From noreply@ucl.ac.uk -Subject $outfile -Body "Done"
}

#End of Function

#Function calls
get-path-user_ad_details "01" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol01.csv"
get-path-user_ad_details "02" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol02.csv"
get-path-user_ad_details "03" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol03.csv"
get-path-user_ad_details "04" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol04.csv"
get-path-user_ad_details "05" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol05.csv"
get-path-user_ad_details "06" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol06.csv"
get-path-user_ad_details "07" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol07.csv"
get-path-user_ad_details "08" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol08.csv"
get-path-user_ad_details "09" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol09.csv"
get-path-user_ad_details "10" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol10.csv"
get-path-user_ad_details "11" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol11.csv"
get-path-user_ad_details "12" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol12.csv"
get-path-user_ad_details "13" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol13.csv"
get-path-user_ad_details "14" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol14.csv"
get-path-user_ad_details "15" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol15.csv"
get-path-user_ad_details "16" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol16.csv"
get-path-user_ad_details "17" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol17.csv"
get-path-user_ad_details "18" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol18.csv"
get-path-user_ad_details "19" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol19.csv"
get-path-user_ad_details "20" "J:\Temp\utnvpda\All_N_User_selection_output\get-details_vol20.csv"
