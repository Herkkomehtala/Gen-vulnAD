param([Parameter(Mandatory=$true)] $Jsonfile)


function CreateADGroup() {
    param([Parameter(Mandatory=$true)] $groupObject)

    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global

}
function CreateADUser(){
    param([Parameter(Mandatory=$true)] $userObject)

    # Pull required info from config file
    $name = $userObject.name
    $password = $userObject.password

    # Carve out a first initial, last name structure for username
    $firstname, $lastname = $name.Split(" ")
    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = $username

    # Create the AD user
    Write-Host "Creating $username User..."
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to an appropriate group
    foreach ($group_name in $userObject.groups) {
        try {
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group_name -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
        {
            Write-Warning “WARNING! AD Group $group_name not found while creating user $name”
        }
    }
    
}

$jsonData = Get-Content $Jsonfile | ConvertFrom-JSON
$Global:Domain = $jsonData.domain

foreach ( $group in $jsonData.groups){
    CreateADGroup $group
}

foreach ( $user in $jsonData.users){
    CreateADUser $user
}