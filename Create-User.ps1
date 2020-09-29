Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Confirm:$False -Force
$computer = $Env:ComputerName
$securestring = Get-Content \\datadrive\wallpaper\WebStat\config.xml | ConvertTo-SecureString -Key (Get-Content \\datadrive\wallpaper\WebStat\ssl.key)
$table = New-Object System.Data.DataTable
$table.Columns.Add("HostName", "string") | Out-Null
$table.Columns.Add("Date", "string") | Out-Null
$table.Columns.Add("Name", "string") | Out-Null
$table.Columns.Add("Disabled", "string") | Out-Null
$table.Columns.Add("IsAdmin", "boolean") | Out-Null
$user = "isys"
$description =  "Local Administrator"
$group = "Administrators"
$ObjOU = [ADSI]"WinNT://$computer"
$objGroup = [ADSI]"WinNT://$computer/$group"
$membersObj = @($objGroup.psbase.Invoke("Members")) 
$members = ($membersObj | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)})
function User-MemberShip
{
    $Local_Users = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True"
    foreach($UserScan in $Local_Users)
    {
        $r = $table.NewRow()
        $usr_name = $UserScan.name
        $usr_disabled = $UserScan.disabled
        $r.HostName = $computer
        $r.date = date
        $r.Name = $usr_name
        $r.Disabled = $usr_disabled
        If ($members -contains $usr_name) 
        {
            $r.IsAdmin = "True"
        }
        else
        {
            $r.IsAdmin = "False"
        }
        $table.Rows.Add($r)       
}
$table| Export-Csv \\datadrive\wallpaper\Workstation_Audit\$computer.csv -NoTypeInformation
}

try
    {
       [ADSI]::Exists("WinNT://localhost/$User,user") -eq 'True'
       User-MemberShip
    }
    catch
    {
        $objUser = $objOU.Create("User", $user)
        $objUser.setpassword([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($securestring)))))
        $objUser.put("description",$description)
        $objUser.SetInfo()
        $objGroup.add("WinNT://$computer/$user")
        $objGroup.SetInfo()
        User-MemberShip
    }
