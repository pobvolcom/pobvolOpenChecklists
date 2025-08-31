// ScreenStatusEdit_SaveGroupButton1_31.vba

Set (ShowDeleteDialog;false);;
Set(_ShowLoadingHint;true);;
//--------------------------------------------------
UpdateContext({locInputCheck:true});;
//--------------------------------------------------
// Status
If(IsBlank(DataCardValue1_31.Text); 
    UpdateContext({locInputCheck:false});;
    Notify("Status must not be empty");;
);;
// Language
If(IsBlank(DataCardValue2_31.Text); 
    UpdateContext({locInputCheck:false});;
    Notify("Language must not be empty");;
);;
//Label
If(IsBlank(DataCardValue3_31.Text);
    UpdateContext({locInputCheck:false});;
    Notify("Label must not be empty");;
);;
//Defect class
If( Value(DataCardValue4_31.Text)<0||
    Value(DataCardValue4_31.Text)>10;
    UpdateContext({locInputCheck:false});;
    Notify("Defect class must be >=0 and <=10");;
);;
//Icon
If(IsBlank(DCIcon5_31.Selected.Value);
    UpdateContext({locInputCheck:false});;
    Notify("Icon must not be empty");;
);;
//--------------------------------------------------
//Daten speichern
//If(locInputCheck, 
//    SubmitForm(EditForm1_31); 
//);
//--------------------------------------------------
If(locInputCheck; 
    Patch(MyStatus; 
        LookUp(MyStatus;Status=SelectedStatus);
        {
            StatusText:DataCardValue3_31.Text;
            DefectClass:Value(DataCardValue4_31.Text);
            Icon:DCIcon5_31.Selected.Value
        }
    );;    

    If(!IsEmpty(Errors([@MyStatus]));
        Set(locErrorCode;
            "Error! Could not patch the record."
        );;
        Notify(
            locErrorCode;
            //LookUp(MyUVVSettings;
            //Title="Fehler beim Speichern!").Wert;
            NotificationType.Error; 
            2000
        );;
    ; //Else
        Set(locErrorCode;"");;
    );;

    If(IsBlank(locErrorCode);
        Patch(colStatus; 
            LookUp(colStatus;Status=SelectedStatus);
            {
                StatusText:DataCardValue3_31.Text;
                DefectClass:Value(DataCardValue4_31.Text);
                Icon:DCIcon5_31.Selected.Value
            }
        );;    
    );;

    If(IsBlank(locErrorCode) && OnlineStatus=1;

        //Record available?
        Set(PatchID;0);;
        Set(PatchID;
            LookUp(pssChecklistsStatus;
            Status=SelectedStatus).ID
        );;
        Patch(pssChecklistsStatus; 
            If(PatchID>0;
                LookUp(pssChecklistsStatus;ID=PatchID)
            ;//Else
                Defaults(pssChecklistsStatus)
            );
            {
                Title:"Status";
                Status:SelectedStatus;
                DefectClass:Value(DataCardValue4_31.Text);
                Icon:DCIcon5_31.Selected.Value
            }
        );;    

        //Record available?
        Set(PatchID;0);;
        Set(PatchID;
            LookUp(pssChecklistsStatusText;
                Status=SelectedStatus&&
                LanguageTag=MyLanguage
            ).ID
        );;
        Patch(pssChecklistsStatusText; 
            If(PatchID>0;
                LookUp(pssChecklistsStatusText;ID=PatchID)
            ;//Else
                Defaults(pssChecklistsStatusText)
            );
            {
                Title:"S";
                Status:SelectedStatus;
                LanguageTag:MyLanguage;
                StatusText:DataCardValue3_31.Text
            }
        );;    
    );;
);;
//--------------------------------------------------
//Daten neu einlesen
Set(_ShowLoadingHint;false);;
If(locInputCheck; 
    //Set(ReadStatus;true);;
    Set(StatusSelected;true);;
    Navigate(ScreenStatus);;
);;
