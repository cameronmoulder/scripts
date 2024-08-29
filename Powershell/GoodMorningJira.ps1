

# Check if the JiraPS module is installed
if (-not (Get-Module -Name JiraPS -ListAvailable)) {
    # Module not installed, install it
    Install-Module -Name JiraPS -Force -Scope CurrentUser -AllowClobber -Repository PSGallery -ErrorAction Stop
}

# Import the JiraPS module
Import-Module -Name JiraPS -ErrorAction Stop

# Tell the module what is the server's address
Set-JiraConfigServer -Server <server>

# Get the user credentials with which to authenticate

$username = <username>
$password = ConvertTo-SecureString <API KEY> -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)


#$cred = Get-Credential

New-JiraSession -Credential $cred

$FullList = Get-JiraIssue -Query <JQL Query>


$FullListCount = $FullList.Count


$TodoList = Get-JiraIssue -Query <JQL Filter>

$ListCount = $TodoList.Count

$GreenTimeSpan = New-TimeSpan -Days 1

$YellowTimeSpan = New-TimeSpan -Days 2

$RedTimeSpan = New-TimeSpan -Days 4

$TodaysDate = Get-Date

Write-Host "---------------------------------------------------------------------------------" -ForegroundColor Red
Write-Host "---------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "---------------------------------------------------------------------------------" -ForegroundColor Green

Write-Host " 🌞☕ Morning! You have $ListCount tickets waiting for support today $TodaysDate "

    if ($TodoList.Count -lt 1) {
        Write-Host "Nothing to do!"  -ForegroundColor Green
    }

    else {
        ForEach($item in $TodoList){

        if(((Get-Date) - $item.Created) -gt $YellowTimeSpan -and ((Get-Date) -$item.Created -lt $RedTimeSpan )){

        Write-Host $item `n  -ForegroundColor Yellow
    }
        elseif (((Get-Date) - $item.Created) -gt $RedTimeSpan  ) {
        Write-Host $item `n  -ForegroundColor Red
    }
        elseif (((Get-Date) - $item.Created) -lt $GreenTimeSpan) {
        Write-Host $item `n  -ForegroundColor Green
    }
    }
}


Write-Host "Other than that, you have $FullListCount tickets in total waiting for support."
