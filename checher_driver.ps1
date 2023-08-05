# Tasks of this program
# Support logging
# checks desired drive for free space 
# lets user specify drive
# Supports both windows and linux
# sends telegram notifications

# for allowing user to do things kind dynamically and that is parameter
param (
    [Parameter(Mandatory = $true)]
    [string]
    $Drive
)

# Log directory
if ($PSVersionTable.Platform -eq 'Unix') {
    $logPath = '/tmp'
}
else{
    $logPath = 'C:\Logs'
}
 
$logFile = "$logPath\driveCheck.log" #logfile

#verify if the directory exists
#create a directory (result boolean)
try{
    if(-not(Test-Path -Path $logPath -ErrorAction Stop)) {
        #output dir is not found, create the dir
        New-Item -ItemType Directory -Path $logPath -ErrorAction Stop | Out-Null
        New-Item -ItemType File -Path $logFile -ErrorAction Stop | Out-Null
    }
}
catch{
    throw
}
#add data 
Add-Content -Path $logFile -Value "[INFO] Running $PSCommandPath"

#verify that poshgram is installed
if(-not (Get-Module -Name PoshGram -ListAvailable)) {
    Add-Content -Path  $logFile -Value "[ERROR] PoshGram is not installed"
    throw
}
else{
    Add-Content -Path  $logFile -Value "[INFO] PoshGram is installed"
}


##get hard drive inforamtaion
try{
    if ($PSVersionTable.Platform -eq 'Unix') {
        #used
        #free
        $volume = Get-PSDrive -Name $Drive
        #verify volume actually exists
        if($volume){
            #for linux
            $total = $volume.Used + $volume.Free
            $percentFree = [int](($volume.Free / $total) * 100)
            Add-Content -Path $logFile -Value "[INFO] Percent Free: $percentFree%"
        }
        else{
            Add-Content -Path $logFile -Value "[ERROR] $Drive was not exists"
            throw
        }
    }
    #for windows
    else{
        $volume = Get-Volume -ErrorAction Stop | Where-Object {$_.DriveLetter -eq $Drive}
        if($volume) {   
        $total = $volume.Size
        $percentFree = [int](($volume.SizeRemaining / $total) * 100)
        Add-Content -Path $logFile -Value "[INFO] Percent Free: $percentFree%"
    }
    else{
        Add-Content -Path $logFile -Value "[ERROR] $Drive was not exists"
        throw
    }}
}
catch{
    Add-Content -Path $logFile -Value "[ERROR] $Drive unable to retrive value inforamtion"
    Add-Content -Path $logFile -Value $_
    throw
}


 
# $logFile = "$logPath\driveCheck.log" #logfile
#send telegram message if the drive is low
if($percentFree -le 20){
    try{
        Import-Module -Name PoshGram -ErrorAction Stop
        Add-Content -Path $logFile -Value "[INFO] Imported PoshGram succefully"

    }
    catch{
        Add-Content -Path $logFile -Value "[ERROR] PoshGram could not be imported"
        Add-Content -Path $logFile -Value $_
    }
    #sent info to user
    Add-Content -Path $logFile -Value "[INFO] Sending Telegram notification"

    #extract from powershell command
   
    # Send-TelegramTextMessage -BotToken $botToken -ChatID $chat -Message "Hello Drive"
    # convert to splat expression
    $sendTelegramTextMessageSplat = @{
        Message = "[LOW SPACE]Drive at $percentFree%"
        ChatID = "-nnnnnnnnn"
        BotToken = "nnnnnnnnn:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
        ErrorAction = 'Stop'
    }
    try{
         Send-TelegramTextMessage @sendTelegramTextMessageSplat 
    Add-Content -Path $lofFile -Value "[INFO] message send succesufuly"
    }
    catch{
        Add-Content -Path $logFile -Value "[ERROR] Error encountered sending message:"
        Add-Content -Path $logFile -Value $_
        throw
    }
   
}