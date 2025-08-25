Set(ShowDeleteDialog;false);;
Set (locErrorCode; "");;
//--------------------------------------------------------
// Delete flex field
If(IsBlank(locErrorCode);

    // remove from collection
    RemoveIf(MyFlexFields;Title=SelectedFlexField);; 
    
    //all good?
    If(!IsEmpty(Errors([@MyFlexFields]));
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

    //Remove from SP list
    If(IsBlank(locErrorCode) && OnlineStatus=1;

        RemoveIf(pssChecklistsFlexFields;
            Title=SelectedFlexField);; 
        
        RemoveIf(pssChecklistsFlexFieldsText;
            Title=SelectedFlexField);; 

    );;

    If(CountRows(MyFlexFields)>0;
        Set(SelectedFlexField;
            First(MyFlexFields).Title
        );;
        Set(FlexFieldSelected;true);;
    ;//Else
        Set(SelectedFlexField;"");;
        Set(FlexFieldSelected;false);;
    );;
    Set(InitialReadFlexFields;true);;
    Set(ReadFlexFields;true);;

);;

