$jsonData = Get-Content .\ad_config.json | ConvertFrom-JSON
$Global:Domain = $jsonData.domain
$num_groups = 12
$MaxUserGroups = 2

$group_names = (Get-Content "data/groups.txt")
$first_names = (Get-Content "data/firstNames.txt")
$last_names = (Get-Content "data/lastNames.txt")
$passwords = (Get-Content "data/passwords.txt")
$groups = @(Get-Random -InputObject $group_names -Count $num_groups)
$users = @()



#echo (Get-Random -InputObject $group_names -Count $num_groups)

$num_users = 10
for ($i = 0; $i -lt $num_users; $i++) {
    $first_name = (Get-Random -InputObject $first_names)
    $last_name = (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)
    $new_user = @{
        "name"="$first_name $last_name"
        "password"="$password"
        "groups"=@((Get-Random -InputObject $groups -Count (Get-Random -Minimum 1 -Maximum $MaxUserGroups)))
    }
    $users += $new_user
}


$TableJson = ConvertTo-Json -InputObject @{
    "domain"=$Domain
    "groups"=([string]$groups)
    "users"=$users
}

echo ($TableJson)
