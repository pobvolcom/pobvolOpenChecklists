Set(ShowDeleteDialog;false);;
Set (locErrorCode; "");;
//--------------------------------------------------------
// Delete Status
If(IsBlank(locErrorCode);

    // remove from collection
    RemoveIf(MyStatus;Status=SelectedStatus);; 
    
    //all good?
    If(!IsEmpty(Errors([@MyStatus]));
        Set(locErrorCode; 
            LookUp(colLanguage;Title="Error! Was not able to delete the status";Wert)
        );;
        Notify(
            locErrorCode;
            NotificationType.Error;2000
        );;
    ;// Else
        Set (locErrorCode; "");;
    );;

    // Save Status locally
    If(IsBlank(locErrorCode);
        RemoveIf(colStatus;Status=SelectedStatus);; 
        If(MyDeviceType="Mobile" && IsBlank(locErrorCode);
            SaveData(colStatus;"Status")  
        );;
    );;

    //Remove from SP list
    If(IsBlank(locErrorCode) && OnlineStatus=1;

        RemoveIf(pssChecklistsStatus;
            Status=SelectedStatus);; 

        RemoveIf(pssChecklistsStatusText;   Status=SelectedStatus);; 
    );;

    If(CountRows(MyStatus)>0;
        Set(SelectedStatus;
            First(Filter(MyStatus;Status<>Blank())).Status
        );;
        Set(StatusSelected;true);;
    ;//Else
        Set(SelectedStatus;"");;
        Set(StatusSelected;false);;
    );;
    Set(InitialReadStatus;true);;
    Set(ReadStatus;true);;

);;

