# Script: pssChecklistsBackup.ps1
# Task: Create a backup of your SharePoint lists in subfolder 'Microsoft SharePoint'
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
Function LogWrite
#----------------
{
    Param ([string]$strMessage)
    $strCurrentDateTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    $strValue = $strCurrentDateTime + "  " + $strMessage
    Add-content $strLogfile -value $strValue
}
#---------------------------------------------------------------------------------------
#Get list definitions
Function ExtractSPList
{
    Param ([string]$SPList)
    $fileName = $strPathSharePoint +"\" + $SPList +'.xml'
    Write-Host "Extracting SharePoint list" $SPList
    Write-Host $fileName

    #Write list definition to a xml file
    Get-PnPSiteTemplate -Force -Out $fileName -ListsToExtract "$SPList" -ExcludeHandlers ApplicationLifecycleManagement, AuditSettings, ComposedLook, ContentTypes, CustomActions, ExtensibilityProviders, Features, ImageRenditions, Navigation, None, PageContents, Pages, PropertyBagEntries, Publishing, RegionalSettings, SearchSettings, SiteFooter, SiteHeader, SitePolicy, SiteSecurity, SiteSettings, SupportedUILanguages, SyntexModels, Tenant, TermGroups, Theme, WebApiPermissions, WebSettings, Workflows

    #Add the data to the xml file
    Add-PnPDataRowsToSiteTemplate -Path $fileName -List "$SPList"

}
#---------------------------------------------------------------------------------------

#Current path
$MyPath = $PSScriptRoot

#Variables
$strError = ""
$SPTenant = "null"
$SPTeam = "null"
$PnPRocksId = "null"
$strError = ""

Write-Host "pobvol Checklists: pssChecklistsBackup.ps1 started ...."
Write-Host "Current folder:" $MyPath 

# Log-File
$strLogfile = $MyPath + "\log.txt"
Write-Host "Log file:" $strLogfile

#---------------------------------------------------------------------------
# Get the information necessary to access SharePoint
#---------------------------------------------------------------------------

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
If( $SPTenant -eq "null" -OR $SPTeam -eq "null" -OR $PnPRocksId -eq "null"){
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
# Check the SharePoint group/site
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
    If($SPSiteExist -ne "true"){

        $strError = "Error"

        $strMessage = "Error! Missing the SharePoint group/site " +$SiteAlias
        Write-Host $strMessage
        LogWrite $strMessage

    }    
}

#---------------------------------------------------------------------------
# Backup ist saved in subfolder .\Microsoft SharePoint\yyyy-mm-dd
#---------------------------------------------------------------------------
If($strError -eq "" -AND $SPSiteExist -eq "true"){

    #Create subfolder 
    $Date = Get-Date -Format yyyy-MM-dd
    $strPathSharePoint = $MyPath + '\Microsoft SharePoint\' + $Date
    if (!(Test-Path -Path $strPathSharePoint)) {

        $strMessage = "Creating local backup-folder " +$strPathSharePoint
        Write-Host $strMessage
        LogWrite $strMessage

        New-Item -Path $strPathSharePoint -Type Directory -Force -ErrorAction Stop | Out-Null
    }

    # Create a file per SharePoint list
    if (Test-Path -Path $strPathSharePoint) {

        $strMessage = "Downloading lists from " +$SPSiteURL
        Write-Host $strMessage
        LogWrite $strMessage

        # Connect
        Connect-PnPOnline -Url $SPSiteURL -Interactive -ClientId $PnPRocksId

        # Export lists
        $SPList = "pssActivities"; ExtractSPList $SPList
        $SPList = "pssActivitiesP"; ExtractSPList $SPList
        $SPList = "pssChecklists"; ExtractSPList $SPList
        $SPList = "pssChecklistsText"; ExtractSPList $SPList
        $SPList = "pssCheckpoints"; ExtractSPList $SPList
        $SPList = "pssCheckpointsText"; ExtractSPList $SPList
        $SPList = "pssFlexFields"; ExtractSPList $SPList
        $SPList = "pssFlexFieldsText"; ExtractSPList $SPList
        $SPList = "pssLanguages"; ExtractSPList $SPList
        $SPList = "pssStatus"; ExtractSPList $SPList
        $SPList = "pssStatusText"; ExtractSPList $SPList
    }

}

#---------------------------------------------------------------------------

Write-Host "    " 
Write-Host "Script finished."

Pause
