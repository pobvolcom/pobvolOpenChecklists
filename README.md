<img width="128px" src="/images/pobvolOpenChecklistsLogo.png">
<h3>Quickly and easily define checklists with checkpoints and fields | Collect data in a structured way | Free Software | Open Source | Microsoft 365 (Office 365) | PCs/Macs & Mobile Devices | Study</h3>

With the software solution <b>pobvol Open Checklists</b>, your team can easily and quickly define their own checklists with up to 25 checkpoints, assign fields (text, number, date, choices) and possible status to the checkpoints and than transmit the results of checks and activities to your SharePoint lists in a structured manner. Data structures must not be programmed with a lot of effort in databases and lists. German and English are supported.<br />
<br />
<a href="/Docu/pssChecklists-Intro-en.pdf" rel="follow" target="_blank" title="PDF" >Introduction (PDF) ></a>&nbsp;&nbsp;&nbsp;
<a href="/Docu/pssChecklists-Installation-manual.pdf" rel="follow" target="_blank" title="pssChecklists-Installation-manual.pdf" >Installation Manual (PDF) ></a><br />

<br />
<h3>Platform</h3>
<ul>
<li><a href="https://www.microsoft.com/en-us/microsoft-365/business" target="_blank" rel="nofollow"><b>Microsoft 365 Business&#9775;</b></a> must be set up to install and operate the software solution. For information about Microsoft 365 and system requirements, see the page <a href=
"https://www.microsoft.com/en-us/microsoft-365/microsoft-365-and-office-resources#coreui-heading-ve4oosr" target="_blank">Microsoft 365 und Office resources&#9775;</a>. You need a <a href="https://www.microsoft.com/en-us/microsoft-365/business/microsoft-365-business-basic?market=en" target="_blank">Microsoft 365 Business Basic License&#9775;</a> or higher per user. This is not free and must be purchased by you from Microsoft.</li>
<li>To install the solution, you need a Windows PC on which the PC component of the solution is installed. At least Windows 10 must be installed on the PC.</li> <li>Your team uses <b>PCs/Macs or mobile devices</b> (Apple iPads/iPhones, Android tablets/smartphones). Microsoft's minimum requirements for using Power Apps are provided on the website <a href="https://docs.microsoft.com/en-us/power-apps/limits-and-config" target="_blank">Power Apps system requirements and limits - Power Apps | Microsoft Docs&#9775;</a>.</li>
</ul>

<br />
<h3>Products and services used for operation</h3>
<img width="100%" src="/images/pobvolOpenChecklistsEnvironment.png"><br />

<a href="https://docs.microsoft.com/en-us/powershell/" target="_blank" rel="nofollow"><b>Microsoft PowerShell</b>&#9775;</a> with the open-source component <a href="https://learn.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets" target="_blank" rel="nofollow"><b>PnP PowerShell</b>&#9775;</a> is used for the installation of the solution and for data backups. With the script pssChecklistsSetup.ps1 you will create your SharePoint site, group, team and lists. With the script pssChecklistsBackup.ps1 you can save the data from your SharePoint lists in local xml files. PowerShell is included in Microsoft Windows. There are no further license costs.<br />
<br />

The <a href="https://docs.microsoft.com/en-us/powerapps/" target="_blank" rel="nofollow"><b>Microsoft Power Apps</b>&#9775;</a> application <b>pssChecks</b> is the most important part of the solution. The app allows your team to create and adapt the required checklists with checkpoints, to assign fields and status to the checkpoints and to send the results of checks and activities to your SharePoint lists. Power Apps uses a unique programming language known as Power Fx. The code of the app is delivered as open source with the unmanaged Power Apps solution ./Microsoft Power Apps/pobvolChecklists_1_*.zip. Power Apps is included in Microsoft 365 Business Basic.<br />
<br />
        
The <a href="https://docs.microsoft.com/en-us/power-automate/" target="_blank" rel="nofollow"><b>Microsoft Power Automate</b>&#9775;</a> flow <b>pobvol Open Checklists: Create activity report</b> is used to summarize the sent data in a report and to send it by email to the sender. This ensures transparency and helps to verify the sent data. The flow is delivered as open source with the unmanaged Power Apps solution ./Microsoft Power Apps/pobvolChecklists_1_*.zip. Power Automate is included in Microsoft 365 Business Basic.<br />
<br />

Your data is stored in your <a href="https://docs.microsoft.com/en-us/sharepoint/" target="_blank" rel="nofollow"><b>Microsoft 365 SharePoint</b>&#9775;</a> environment. 
This gives you full control over your data and allows you to control who can access it.
I chose SharePoint to keep your license costs as low as possible. 
SharePoint is included in Microsoft 365 Business Basic.
For customers in Germany, <a href="https://www.microsoft.com/de-de/microsoft-365/business/data-security-privacy-germany" rel="nofollow" target="_blank" title="data-security-privacy-germany">Microsoft delivers cloud services from Germany&#9775;</a>. Your business data is stored in compliance with GDPR in Germany - demonstrably secure data storage in German data centers.<br />
<br />

You can use <a href="https://docs.microsoft.com/en-us/sharepoint/dev/spfx/build-for-teams-overview" target="_blank" rel="nofollow"><b>Microsoft Teams</b>&#9775;</a> on PCs/Macs and mobile devices to access documents in your SharePoint library. Power Apps applications can also be started in Teams. Teams is included in Microsoft 365 Business Basic.<br />
<br />

<a href="https://docs.microsoft.com/en-us/power-apps/user/run-app-browser" target="_blank" rel="nofollow"><b>Microsoft Edge</b>&#9775;</a>: When you create a Power Apps application or someone shares an application with you, you can run it in a web browser. Edge can be used on PCs/Macs and mobile devices to run the Power Apps application.<br />
<br />

<a href="https://docs.microsoft.com/en-us/power-apps/maker/canvas-apps/connections/connection-office365-outlook" target="_blank" rel="nofollow"><b>Microsoft Outlook</b>&#9775;</a>: A Power Automate Flow notifies via email about received data. This ensures transparency. Outlook can be used on PCs/Macs and mobile devices to read these emails. Outlook is included in Microsoft 365 Business Basic.<br />
<br />


<h3>Data model</h3>
<img width="100%" src="/images/pobvolOpenChecklistsDataModel.png">

<br />
<h3>Component list</h3>
<table cellspacing="0" border="1">
    <th style="padding:5px;text-align:left;">#</th>
    <th style="padding:5px;text-align:left;" width="300px">Type</th>
    <th style="padding:5px;text-align:left;">Description</th>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">1</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft Power Apps Canvas App</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssChecks</b> App for managing checklists, checkpoints and fields. Capture results of checks and activities and send them to SharePoint lists.</td>
    </tr>
    <tr>                
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">2</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft Power Automate Cloud Flow</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pobvol Open Checklists: Create activity report</b> This flow informs senders by email about the received data. This ensures transparency.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">3</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssActivities</b> This list stores details per check.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">4</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssActivitiesP</b> This list stores details per check and checkpoint.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">5</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssChecklists</b> This list stores details about the checklists.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">6</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssChecklistsText</b> This list stores the names and descriptions of the checklists in different languages.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">7</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssCheckpoints</b> This list stores details about the checkpoints of the checklists.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">8</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssCheckpointsText</b> This list stores the names and descriptions of the checkpoints in different languages.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">9</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssFlexFields</b> This list stores details about the fields.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">10</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssFlexFieldsText</b> This list stores the names of the fields in different languages.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">11</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssLanguages</b> This list stores the translations into the different languages.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">12</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssStatus</b> This list stores the available status values. These can be assigned to the checkpoints.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">13</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft SharePoint List</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssStatusText</b> This list stores the status text in different languages.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">14</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft PowerShell Script</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssChecklistsSetup.ps1</b> This script takes care of the creation/customization of the SharePoint team page and lists during the installation/updates of the solution.</td>
    </tr>
    <tr>
        <td valign="top" style="padding:5px;text-align:right;font-size:smaller;">15</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;">Microsoft PowerShell Script</td>
        <td valign="top" style="padding:5px;text-align:left;font-size:smaller;"><b>pssChecklistsBackup.ps1</b> This script can be used to create a backup of the SharePoint lists.</td>
    </tr>
</table>

<br />
<h3>License</h3>
<img src="/images/gplv3-or-later.png"> 
The open source software solution <b>pobvol Open Checklists</b> is <a href="https://en.wikipedia.org/wiki/Free_software" target="_blank" rel="nofollow">Free Software☯</a></b>. 
You can download the solution, install and operate it in your Microsoft 365 business environment and adapt it to your needs. 
The use of the solution is free of charge. 
You can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version. 
The solution is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details. 
You should receive a copy of the GNU General Public License along with the solution. 
If not, see <a href="https://www.gnu.org/licenses/gpl-3.0" target="_blank" rel="nofollow">GNU General Public License&#9775;</a> for more details.
<br />
<br />
Copyright @ 2025 Volker Pobloth<br />
Location: 66292 Riegelsberg, Germany<br />
E-Mail: kontakt@pobvol.com<br />
Web: https://www.pobvol.com/en/psschecklists.html<br />
<br />
<em><b>Please note: </b>The use of my contact details by third parties to send unsolicited advertising and information materials is hereby expressly excluded! I expressly reserve the right to take legal action in the event of unsolicited sending of advertising information, such as spam mails!</em><br />
<br />
