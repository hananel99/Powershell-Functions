#filter a user's member of
function ug{


        $username = Read-Host "Please enter User-name"
        $groupname = Read-Host "Enter group name"
        (Get-ADPrincipalGroupMembership -Identity $username).SamAccountName | select-string $groupname | Sort-Object
}




#view all of a user's member off
function cu_groups{


        $username = Read-Host "Please enter User-name"
        Get-ADPrincipalGroupMembership -Identity $username | Sort-Object | Select-Object name | more


}



#view all of a user's member off with a description
function cu_groups_des{


        $username = Read-Host "Please enter User-name"
        Get-ADPrincipalGroupMembership $username | ForEach-Object {Get-ADGroup $_ -Properties Info,Description | select Name,Info,Description} | Out-GridView

}



#reset a user's password
function resetpassword{


        $username = Read-Host "Insert username"
        $passwd = Read-Host "insert password"
        Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$passwd" -Force)
        Write-output "($username)'s password has been reset"


}


function cu{



        $username = Read-Host "Enter username"
        Get-ADUser $username -Properties * | Select-Object Enabled,
        badPwdCount,Lockedout,
        Vasco-locked,PasswordExpired,PasswordLastSet,description,
        MobilePhone,EmailAddress,HomeDirectory,LastLogonDate,extensionAttribute6


}



function Get-pr{

	$printeserver = read-home "Enter Printer Server Name"
    $printer=Read-Host "Enter Printer Name"
    Get-Printer -Name \\$printserver\$printer -Full | Select-Object -Property Name,DriverName,PortName,RenderingMode,PrinterStatus,Comment,Location,Priority,Shared



}


#check if the user is a member of a 365 group
function cu_365{


        $username=Read-Host "Enter username"
        Get-ADPrincipalGroupMembership $username | ForEach-Object {Get-ADGroup -Identity $_ -Properties * | 
        Select-Object info , name | Select-String '365'}

    
}   

#cu with more data
function cu_full{
        
        
        
        $username = Read-Host "Enter username"
        Get-ADUser $username -Properties * | Select-Object Enabled,
        badPwdCount,Lockedout,
        Vasco-locked,Description,DisplayName,Department,PasswordExpired,PasswordLastSet,
        MobilePhone,EmailAddress,HomeDirectory,LastLogonDate,AccountLockoutTime,Pager
        

}



#cu but directly from clip
function cu_clip{


        $username=Get-Clipboard
        Get-ADUser $username -Properties * | Select-Object Enabled,
        Lockedout,Vasco-locked,Description,Department,
        PasswordExpired,PasswordLastSet,
        MobilePhone,EmailAddress,HomeDirectory


}

#unlock vasco if a user is "vasco locked"
function un_vasco{


        $username = Read-Host "Enter username"
        Set-ADUser $username -Replace @{"vasco-Locked"= 0}
        break


}

#set mobile number
function Set-Mobile{

    
        $username=Read-Host "Please enter username"
        $number=Read-Host "Phone number"
        Set-ADUser $username -MobilePhone $number


}


#set pager number
function Set-Pager{

  
        $username=Read-Host "Please enter username"
        $pager=Read-Host "Pager"
        Set-ADUser $username -Replace @{"Pager"=$pager}


}


#close skype
function Close-Skype{


        Stop-Process -ProcessName UcMapi
        Stop-Process -ProcessName lync
        Stop-Process -ProcessName skype
        break


}


#get vasco data of a user
function show-vasco{


         $username=Read-Host "Enter Username"
         Write-output "($username)'s vasco data."
         Get-ADUser $username -Properties * | Select-Object vasco*
         break


}



#unlock a user
function un{

        
         $username = read-host "Enter username"

         if ((Get-ADUser -Identity $username -Properties lockedout).lockedout){
         Write-Host "user is locked"
         
         }else{
         Write-Host "user is not locked"}
         unlock-adaccount $username
         Write-output "$username has been unlocked."
}





#close all microsoft remote assistance windows
function close-msra{


        Stop-Process -ProcessName msra
        Write-output "Windows Remote Assistance has been closed"


}



#close all sccm windows
function close-sccm{


        stop-process -name 'CmRcViewer'
        Write-output 'Viewer has been closed'


}



#open sccm window
function Open-SccmViewer{


        Set-Location 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\i386'
        Start-Process .\CmRcViewer.exe; Start-Process .\CmRcViewer.exe
        Set-Location /
        Write-output 'Viewer has been opened'


}

#show PC Up Time
function uptime{
	$computer_name = Read-Host "enter computer name"
	$systemInfo = systeminfo -s $computer_name | Select-String "System Boot Time"
	$bootTime = $systemInfo -replace '.*:\s+'
	$currentTime = Get-Date
	$bootTime = [DateTime]::Parse($bootTime)
	$uptime = $currentTime - $bootTime
	return $uptime | Select-Object Days,Hours,Minutes
}

#restart teams program
function Restart-Teams{
	
		$user = whoami
        $username = $user.substring($user.IndexOf("\")+1)
        Stop-Process -Name 'Teams'
        Start-Sleep -Seconds 2
        C:\Users\$username\AppData\Local\Microsoft\Teams\Update.exe --processStart "Teams.exe"
        Write-output "Teams has been restarted"

        
}


#get a description of a group
function group-info{


$group= read-host "Enter group name"
Get-ADGroup "$group" -Properties * | Select-Object GroupCategory,GroupScope,Description,Info,ManagedBy | Format-List
Pause

Get-ADGroupMember "$group" | select SamAccountName,objectClass | Sort-Object -Property SamAccountName, objectClass
echo "`n"
echo "Member Of:
----------"
Get-ADGroup "$group" -Property Memberof | select -ExpandProperty Memberof | ForEach-Object {Get-ADGroup -Identity "$_" | select SamAccountName} | Sort-Object



}

#add a user to a group
function groupadd{


        $group = read-host "Enter Group name"
        $username = Read-Host "Enter Username"
        Add-ADGroupMember -Identity "$group" -Members $username


}

#add a printer
function printeradd{

        $printserver = read-home "Enter Printer Server Name"
        $printer=Read-Host "Enter Printer Name"
        Add-Printer -ConnectionName \\$printserver\$printer


}



#search for a computer
function allcomputers{


        $compname=Read-Host "Enter computer name"
        Get-ADComputer -Filter "Name -like '*$compname*'" -Properties IPv4Address | Select-Object Name,IPv4Address


}



#search for a user
function allusers{


        $username=read-host "Enter username"
        Get-ADUser -Filter "SamAccountName -like '*$username*'" -Property DisplayName,SamAccountName,extensionAttribute6 |
        Select-Object DisplayName,SamAccountName,extensionAttribute6


}


#search in Hebrew
function allusers-heb{


        $username=read-host "Enter username"
        Get-ADUser -Filter "DisplayName -like '*$username*'" -Property DisplayName,SamAccountName,extensionAttribute6 |
        Select-Object DisplayName,SamAccountName,extensionAttribute6 
        
        
}              

function allgroups{


        $compname=Read-Host "Enter group name"
        Get-ADGroup -Filter "Name -like '*$compname*'" -Properties SamAccountName,mail | Select-Object SamAccountName,mail


}



#search for a phone number
function allphones{

        
        $phone=Read-Host "Enter Phone Number"
        Get-ADUser -Filter "Mobile -like '*$phone*'" -Property Mobile | Format-List SamAccountName,Mobile



}


#search for a pager
function allpagers{

        
        $pager=Read-Host "Enter Pager Number"
        Get-ADUser -Filter "Pager -like '*$pager*'" -Property Pager | Format-List SamAccountName,Pager



}


#search for an ID
function allid{

        
        $id=Read-Host "Enter ID Number"
        Get-ADUser -Filter "extensionAttribute6 -like '*$id*'" -Property extensionAttribute6,DisplayName | select DisplayName,SamAccountName,extensionAttribute6



}


function Show-functions{


        Get-ChildItem Function:\


}

#lock the pc
function Lock{


        Set-Location C:\Windows\System32
        rundll32.exe user32.dll,LockWorkStation
        Set-Location /


}





function inet {


        inetcpl.cpl
        echo "Internet Options"
        break
        
        
        }





# Accessing a user's Desktop
function cd_desktop{
    $user = Read-Host "Enter username"
    $computer = read-host "Enter Computer name"
    cd \\$computer\C$\users\$username
    }

# Display the diffenece between 2 Users Groups
function check_groups{

# Read the content of the files into arrays
$username1 = Read-Host "Please enter the first User-name"
$username2 = Read-Host "Please enter the second User-name"

$user1Groups = (Get-ADPrincipalGroupMembership -Identity $username1 | Sort-Object).name

$user2Groups = (Get-ADPrincipalGroupMembership -Identity $username2 | Sort-Object).name

# Get the unique items for each group
$uniqueto1 = $user1Groups | Where-Object { $_ -notin $user2Groups}
$uniqueto2 = $user2Groups | Where-Object { $_ -notin $user1Groups}

# Display the missing groups for each user
Write-Host "`n`nGroups that $username1 has but $username2 doesn't have:`n"
$uniqueto1

Write-Host "`nGroups that $username2 has but $username1 doesn't have:`n"
$uniqueto2

}



function getprinter{
param(
$printserver
$printer)


Add-Printer -ConnectionName \\$printserver\$printer

echo ""

(Get-Printer -Name \\$printserver\$printer -Full | Select-Object -Property Name,DriverName,PortName,RenderingMode,PrinterStatus,Comment,Location,Priority,Shared | Out-String).Trim()

echo ""

(Get-PrintConfiguration -PrinterName \\$printserver\$printer | fl Color | Out-String).Trim()

echo ""
}

function allprinters{
$printername = Read-Host "Enter printer name"
$pr = Get-Printer -ComputerName <printeserver> | Select-Object Name,PortName | Select-String "$printername"
$pr
}