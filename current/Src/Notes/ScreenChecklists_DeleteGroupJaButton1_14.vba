Set(ShowDeleteDialog;false);;
Set (locErrorCode; "");;
//--------------------------------------------------------
// Delete checklist
If(IsBlank(locErrorCode);

    // remove from collection
    RemoveIf(MyChecklists;Title=SelectedChecklist);; 
    
    //all good?
    If(!IsEmpty(Errors([@MyChecklists]));
        Set(locErrorCode; "Error! Was not able to delete the checklist");;
        Notify(
            locErrorCode;
            //LookUp(MyUVVSettings;
            //Title="Fehler beim Löschen in UVVKundenliste").Wert;
            NotificationType.Error;2000
        );;
    ;// Else
        Set (locErrorCode; "");;
    );;

    // Save checklists locally
    If(MyDeviceType="Mobile" && IsBlank(locErrorCode);
        SaveData(MyChecklists;"MyChecklists")  
    );;

    //Remove from SP list
    If(IsBlank(locErrorCode) && OnlineStatus=1;
        RemoveIf(pssChecklistsChecklists;Title=SelectedChecklist);; 
        RemoveIf(pssChecklistsChecklistsText;Title=SelectedChecklist);; 
        RemoveIf(pssChecklistsCheckpoints;Title=SelectedChecklist);; 
        RemoveIf(pssChecklistsCheckpointsText;Title=SelectedChecklist);; 
    );;

    If(CountRows(MyChecklists)>0;
        Set(SelectedChecklist;
            First(MyChecklists).Title
        );;
        Set(ChecklistSelected;true);;
    ;//Else
        Set(SelectedChecklist;"");;
        Set(ChecklistSelected;false);;
    );;
    Set(InitialReadChecklists;true);;
    Set(ReadChecklists;true);;

);;

