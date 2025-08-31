# Script: pssChecklistsSetup.ps1
# Task: Setup the SharePoint team page and the lists for the solution
#
#Copyright © 2025 Volker Pobloth (pobvol Software Services)
#
#This file is part of the software solution pobvol Open Checklists.
#
#pobvol Open Checklists is Free Software. 
#
#You can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. The solution is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with the solution. If not, see <http://www.gnu.org/licenses/>.
#
#---------------------------------------------------------------------------------------
Function CreateSPList
{
    Param ([string]$SPList)
    # Does the list already exist?
    $SPListExist = "false"
    $Lists = Get-PnPList
    foreach($List in $Lists) { 
        If($($List.Title) -eq $SPList){
            Write-Host $List.Title "found"
            $SPListExist = "true"
        }
    }
    # Create the list
    If($SPListExist -eq "false"){
        $fileName = $MyPathSharePoint +"\" + $SPList +'.xml'

        $strMessage = "Creating SharePoint list " +$SPList
        Write-Host $strMessage
        LogWrite $strMessage

        $strMessage = $fileName
        Write-Host $strMessage
        LogWrite $strMessage

        Invoke-PnPSiteTemplate -Path $fileName
    }
}
#---------------------------------------------------------------------------------------
Function UpdateSPList
{
    Param ([string]$SPList)
    $fileName = $MyPathSharePoint +"\" + $SPList +'.xml'
    $fileNameProcessed = $MyPathSharePoint +"\" + $SPList +'.xml.bak'
    
    # Excecute only if the file exists
    if (Test-Path -Path $fileName -PathType Leaf) {
        try {

            # Before loading languages we must delete the existing records
            If($SPList -eq "UpdatepssLanguages"){
                $strMessage = "Deleting entries from SP list pssLanguages"
                Write-Host $strMessage
                LogWrite $strMessage
                $DelFromSPList = "pssLanguages"; DeleteItemsFromSPList $DelFromSPList
            }

            $strMessage = "Updating SharePoint list " +$SPList
            Write-Host $strMessage
            LogWrite $strMessage
    
            $strMessage = $fileName
            Write-Host $strMessage
            LogWrite $strMessage

            Invoke-PnPSiteTemplate -Path $fileName

            Copy-Item $fileName $fileNameProcessed -Force
            if (Test-Path -Path $fileNameProcessed -PathType Leaf) {
                try {
                    Remove-Item $fileName -Force
                }
                catch {
                    throw $_.Exception.Message
                }
            }
        }
        catch {
            throw $_.Exception.Message
        }
    }
    
}
#---------------------------------------------------------------------------------------
# Thanks to https://powershellfaqs.com/delete-all-items-from-a-sharepoint-list-using-pnp-powershell/
Function DeleteItemsFromSPList
{
    Param ([string]$DelFromSPList)
    # Does the list already exist?
    $SPListExist = "false"
    $Lists = Get-PnPList
    foreach($List in $Lists) { 
        If($($List.Title) -eq $DelFromSPList){
            $SPListExist = "true"
        }
    }
    # Delete entries from list
    If($SPListExist -eq "true"){
        # Get all items in the list
        $items = Get-PnPListItem -List $DelFromSPList
        # Loop through and delete each item
        foreach ($item in $items) {
            #Write-Host $item.Id
            Remove-PnPListItem -List $DelFromSPList -Identity $item.Id -Force
        }
    }
}
#---------------------------------------------------------------------------------------
Function LogWrite
{
    Param ([string]$strMessage)
    $strCurrentDateTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    $strValue = $strCurrentDateTime + "  " + $strMessage
    Add-content $strLogfile -value $strValue
}
#---------------------------------------------------------------------------------------

# Current path
$MyPath = $PSScriptRoot

$SPTenant = "null"
$SPTeam = "null"
$PnPRocksId = "null"

$fileName = ""
$strError = ""

$AdminSiteURL=""
$SiteAlias = ""
$GroupAlias = ""
$Sites = ""
$SPSiteExist = "false"


Write-Host "pobvol Checklists: pssChecklistsSetup.ps1 started ...."
Write-Host "Current folder:" $MyPath 

# Log-File
$strLogfile = $MyPath + "\log.txt"
Write-Host "Log file:" $strLogfile

#---------------------------------------------------------------------------
# Get the information necessary to access SharePoint
#---------------------------------------------------------------------------

# Copy settings from templates, if the file not exists
$strSource = $MyPath + "\Templates\pssChecklistsSettings.xml"
$strTarget = $MyPath + "\pssChecklistsSettings.xml"
if (!(Test-Path -Path $strTarget)) {
    #Datei anlegen
    $strMessage = "Creating " +$strTarget
    Write-Host $strMessage
    LogWrite $strMessage
    try {
        Copy-Item $strSource -Destination $strTarget
        notepad $strTarget 
        Pause
    }
    catch {
        #throw $_.Exception.Message
        $strMessage = "    " +$_.Exception.Message
        LogWrite $strMessage
    }
}

# Read settings from pssChecklistsSettings.xml
$filename = $MyPath +"\pssChecklistsSettings.xml"
if (Test-Path -Path $filename) {
    $strMessage = "Reading settings from "+$filename
    Write-Host $strMessage
    LogWrite $strMessage
    $xmldata = New-Object xml
    $xmldata.Load( (Convert-Path $filename) )
    $SPTenant = $xmldata.Settings.Entry.Tenant
    $SPTeam = $xmldata.Settings.Entry.Team
    $PnPRocksId = $xmldata.Settings.Entry.PnPRocksId
    Remove-Variable xmldata -ErrorAction SilentlyContinue
}

# List settings
Write-Host "Parameters found:"
Write-Host "    Tenant:" $SPTenant
Write-Host "    Team:" $SPTeam
Write-Host "    PnP Rocks Id:" $PnPRocksId

# All found?
If( $SPTenant -eq "null" -OR $SPTenant -eq "Your Tenant" -OR  
    $SPTeam -eq "null" -OR $SPTeam -eq "Your Team" -OR
    $PnPRocksId -eq "null" -OR $PnPRocksId -eq "Your Id"){
    $strError = "Error"
    $strMessage = "pobvol Checklists: pssChecklistsSetup.ps1"
    LogWrite $strMessage
    $strMessage = "    Processing skipped. Missing parameters!"
    Write-Host $strMessage
    LogWrite $strMessage
    $strMessage = "    Please check your entries in " +$MyPath +'\pssChecklistsSettings.xml'
    Write-Host $strMessage
    LogWrite $strMessage
    Pause
}

#---------------------------------------------------------------------------
# Create the SharePoint group/site
#---------------------------------------------------------------------------
If($strError -eq ""){
    
    # Provide your SharePoint Online Admin center URL
    # $AdminSiteURL = "https://<Tenant_Name>-admin.sharepoint.com"
    $AdminSiteURL = "https://" + $SPTenant +"-admin.sharepoint.com/"

    $strMessage = "Connect to SharePoint Admin center "+$AdminSiteURL
    Write-Host $strMessage
    LogWrite $strMessage

    # Connect-PnPOnline -Url "https://<yourtenant>-admin.sharepoint.com/" -Interactive -ClientId <Your PnP Rocks Id>
    # How to get your own PnP Rocks Id?
    # https://pnp.github.io/powershell/articles/registerapplication
    Connect-PnPOnline -Url $AdminSiteURL -Interactive -ClientId $PnPRocksId
    
    # Get all site collections
    $SiteAlias = $SPTeam
    $GroupAlias = $SPTeam

    $Sites = Get-PnPTenantSite
    $SPSiteExist = "false"
    ForEach($Site in $Sites)
    {
        #$i++;
        #Write-Host "    Site Name:" $($Site.Title)
        #Write-Host "    Site URL:" $($Site.Url)
        If($($Site.Title) -eq $SiteAlias){
            $SPSiteExist = "true"
            $SPSiteURL = $($Site.Url)
        }

    }
    If($SPSiteExist -eq "true"){

        $strMessage = "SharePoint group/site " +$SiteAlias +" exists"
        Write-Host $strMessage
        LogWrite $strMessage
        
    }else {

        $strMessage = "Creating SharePoint group/site " +$SiteAlias
        Write-Host $strMessage
        LogWrite $strMessage
        
        #Thanks to Morgang Tech Space
        #https://morgantechspace.com/2022/09/create-a-new-sharepoint-online-site-using-pnp-powershell.html
        New-PnPSite -Type TeamSite -Title $SPTeam -SiteAlias $SiteAlias -Alias $GroupAlias
    }    
}

#---------------------------------------------------------------------------
# Create the SharePoint lists
#---------------------------------------------------------------------------
If($strError -eq ""){

    $SPSiteExist = "false"
    $Sites = Get-PnPTenantSite
    ForEach($Site in $Sites)
    {
        If($($Site.Title) -eq $SiteAlias){
            $SPSiteExist = "true"
            $SPSiteURL = $($Site.Url)
        }
    }
    
    If($SPSiteExist -eq "true"){

        # Definition files for the lists are save in subfolder 'Microsoft SharePoint'
        $MyPathSharePoint = $MyPath + '\Microsoft SharePoint'

        
        $strMessage = "Connecting to SharePoint site"
        Write-Host $strMessage
        LogWrite $strMessage
        Connect-PnPOnline -Url $SPSiteURL -Interactive -ClientId $PnPRocksId


        # Create SharePoint lists
        $SPList = "pssActivities"; CreateSPList $SPList
        $SPList = "pssActivitiesP"; CreateSPList $SPList
        $SPList = "pssChecklists"; CreateSPList $SPList
        $SPList = "pssChecklistsText"; CreateSPList $SPList
        $SPList = "pssCheckpoints"; CreateSPList $SPList
        $SPList = "pssCheckpointsText"; CreateSPList $SPList
        $SPList = "pssFlexFields"; CreateSPList $SPList
        $SPList = "pssFlexFieldsText"; CreateSPList $SPList        
        $SPList = "pssStatus"; CreateSPList $SPList
        $SPList = "pssStatusText"; CreateSPList $SPList
        $SPList = "pssLanguages"; CreateSPList $SPList


        # Update SharePoint lists
        $SPList = "UpdatepssActivities"; UpdateSPList $SPList
        $SPList = "UpdatepssActivitiesP"; UpdateSPList $SPList
        $SPList = "UpdatepssChecklists"; UpdateSPList $SPList
        $SPList = "UpdatepssChecklistsText"; UpdateSPList $SPList
        $SPList = "UpdatepssCheckpoints"; UpdateSPList $SPList
        $SPList = "UpdatepssCheckpointsText"; UpdateSPList $SPList
        $SPList = "UpdatepssFlexFields"; UpdateSPList $SPList
        $SPList = "UpdatepssFlexFieldsText"; UpdateSPList $SPList        
        $SPList = "UpdatepssStatus"; UpdateSPList $SPList
        $SPList = "UpdatepssStatusText"; UpdateSPList $SPList
        $SPList = "UpdatepssLanguages"; UpdateSPList $SPList

    }
}

#---------------------------------------------------------------------------
# Add Teams to the SharePoint group/site
#---------------------------------------------------------------------------
If($strError -eq "" -AND $SPSiteExist -eq "true"){

    # Once a new M365 group is added to the classic team site, we can use the below command to create a new Microsoft Teams team (Teamify) 
    # using the newly created group which is connected with the site. Provide your team site URL which is connected with a group
    # $SiteURL = "https://contoso.sharepoint.com/sites/salesteamsite"

    # Get the id (Group Id) of the connected group
    $SiteInfo = Get-PnPTenantSite -Identity $SPSiteURL
    $GroupId = $SiteInfo.GroupId.Guid

    # Teamify - Enable Teams in the group which is connected with the site
    New-PnPTeamsTeam -GroupId $GroupId

}

#---------------------------------------------------------------------------

Write-Host "    " 
Write-Host "Script finished."

#Pause

