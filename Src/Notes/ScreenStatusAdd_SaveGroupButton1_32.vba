// ScreenStatusAdd_SaveGroupButton1_32.vba

Set (ShowDeleteDialog;false);;
Set(_ShowLoadingHint;true);;
//--------------------------------------------------
UpdateContext({locInputCheck:true});;
Set(locErrorCode;"");;
//--------------------------------------------------
// Status
If(IsBlank(DataCardValue1_32.Text); 
    UpdateContext({locInputCheck:false});;
    Notify("Status must not be empty");;
);;
If(!IsBlank(DataCardValue1_32.Text); 
    If(!IsBlank(LookUp(MyStatus;Status=DataCardValue1_32.Text;Status));
        UpdateContext({locInputCheck:false});;
        Notify("Status must not exists");;
    );;
);;
//--------------------------------------------------
//Daten speichern
//If(locInputCheck, 
//    SubmitForm(EditForm1_32); 
//);
//--------------------------------------------------
If(locInputCheck; 

    //0=Edit;1=Add
    Patch(MyStatus; 
        If(EditForm1_32.Mode=0;
            LookUp(MyStatus;Status=SelectedStatus)
        ;//Else
            Defaults(MyStatus)
        );
        {
            Status:DataCardValue1_32.Text
        }
    );;    

    If(!IsEmpty(Errors([@MyStatus]));
        Set(locErrorCode;
            "Error! Could not save the new entry!"
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
        Set(SelectedStatus;DataCardValue1_32.Text);;
        Set(StatusSelected;true);;
    );;

    If(IsBlank(locErrorCode) && OnlineStatus=1;
        //0=Edit;1=Add
        Patch(pssChecklistsStatus; 
            If(EditForm1_32.Mode=0;
                LookUp(pssChecklistsStatus;Status=SelectedStatus)
            ;//Else
                Defaults(pssChecklistsStatus)
            );
            {
                Title:"Status";
                Status:DataCardValue1_32.Text
            }
        );;

        If(!IsEmpty(Errors([@pssChecklistsStatus]));
            Set(locErrorCode;
                "Error! Could not save the new entry!"
            );;
            Set(SelectedStatus;Blank());;
            Notify(
                locErrorCode;
                //LookUp(MyUVVSettings;
                //Title="Fehler beim Speichern!").Wert;
                NotificationType.Error; 
                2000
            );;
        ; //Else
            Set(locErrorCode;"");;
            Set(StatusSelected;true);;
        );;


    );;
);;
//--------------------------------------------------
//Daten neu einlesen
Set(_ShowLoadingHint;false);;
If(locInputCheck && IsBlank(locErrorCode); 
    Set(StatusSelected;true);;
    Set(InitialReadStatus;true);;
    Set(ReadStatus;true);;    
    EditForm(EditForm1_31);;
    Navigate(ScreenStatusEdit);;
);;
