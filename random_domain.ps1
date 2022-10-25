$group_names = (Get-Content "code/data/groups.txt")
$first_names = (Get-Content "code/data/firstNames.txt")
$last_names = (Get-Content "code/data/lastNames.txt")
$passwords = (Get-Content "code/data/passwords.txt")



$groups = @()
$num_groups = 10

echo (Get-Random -InputObject $first_names -Count 5)
