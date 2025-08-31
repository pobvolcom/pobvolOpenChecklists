//Set( CurrentTime; Now() );;
//------------------------------------------------
If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
);;
//------------------------------------------------
If(IsBlank(MyDeviceType);
    Set(MyDeviceType;
        If(Location.Altitude > 0 || 
        !IsBlank(Acceleration.X)||
        Acceleration.Y > 0 ||
        Acceleration.Z > 0;
            "Mobile";
            "Desktop"
        )
    );;
);;
//------------------------------------------------
//Load language
If(IsBlank(InitialReadLanguage)||InitialReadLanguage;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadLanguage;false);;
    //-----------------------------------------------------
    If(OnlineStatus=1;
        //load language from SP list
        Set(FooterText;"Loading language");;
        Refresh(pssChecklistsLanguages);;
        ClearCollect(colLanguage;
            ShowColumns(
                Filter(pssChecklistsLanguages;
                    LanguageTag=Left(Language();2)
                );
                ID;Title;Wert
            )
        );;
        // Save language locally
        If(MyDeviceType="Mobile";
            SaveData(colLanguage;"Language")  
        );;
    ;//Else
        If(MyDeviceType="Mobile";
            Clear(colLanguage);;
            Set(FooterText;"Loading language from cache");;
            LoadData(colLanguage;"Language";true);;
        )
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
//Load activities from cache (on mobile devices)
If((IsBlank(InitialReadActivities)||InitialReadActivities) && MyDeviceType="Mobile";
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadActivities;false);;
    //-----------------------------------------------------
    ClearCollect(MyActivities; 
    {
        ID:Value(Text(CountRows(MyActivities)+1)); 
        KEY:"";
        Title:"Checklist";
        User:User().FullName;
        UserEMail:"";
        Date:Now();
        DocumentStatus:"New";
        Comments:""
    }
    );;
    Clear(MyActivities);; 

    ClearCollect(MyActivitiesP;
    {
        ParentID:1;
        KEY:"";
        Pos:1;
        Checkpoint:"Checkpoint";
        CheckpointText:"CheckpointText";
        Status:"Status";
        StatusText:"";
        DefectClass:0;
        Comments:"Comments";
        F1:"Text1";
        F2:"Text2";
        F3:"Text3";
        F4:"Text4";
        F5:"Text5";
        F1Title:"Title1";
        F2Title:"Title2";
        F3Title:"Title3";
        F4Title:"Title4";
        F5Title:"Title5";
        F1Label:"Label1";
        F2Label:"Label2";
        F3Label:"Label3";
        F4Label:"Label4";
        F5Label:"Label5"
    }
    );;
    Clear(MyActivitiesP);;
    //-----------------------------------------------------
    //If(MyDeviceType="Mobile";
        Clear(MyActivities);;
        Set(FooterText;"Loading activities from cache");;
        LoadData(MyActivities;"Activities";true);;
        LoadData(MyActivitiesP;"ActivitiesP";true);;
    //);;
    //-------------------------------------------------
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
//Response types
If(IsBlank(InitialReadResponseTypes)||InitialReadResponseTypes;
    Set(_ShowLoadingHint;true);;
    Set(InitialReadResponseTypes;false);;
    ClearCollect(colResponseTypes;
        {Type:"Text"};
        {Type:"Number"};
        {Type:"Combobox"};
        {Type:"Radio"};
        {Type:"Date"}
    );;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
//Load checklists
If(IsBlank(InitialReadChecklists)||InitialReadChecklists;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadChecklists;false);;
    //-----------------------------------------------------
    If(IsBlank(ChecklistsSortDescending);
        Set(ChecklistsSortDescending;false)
    );;
    If(IsBlank(CheckpointsSortDescending);
        Set(CheckpointsSortDescending;false)
    );;
    If(IsBlank(FlexFieldsSortDescending);
        Set(FlexFieldsSortDescending;false)
    );;
    //-----------------------------------------------------
    If(OnlineStatus=1;
        //-------------------------------------------------
        //load checklists from SP list
        Set(FooterText;"Loading checklists");;
        Refresh(pssChecklistsChecklists);;
        ClearCollect(colChecklists;
            ShowColumns(
                Filter(pssChecklistsChecklists;
                    Load=true
                );
                ID;Title;Load
            )
        );;
        // Save checklists locally
        If(MyDeviceType="Mobile";
            SaveData(colChecklists;"Checklists")  
        );;
        //-------------------------------------------------
        Set(FooterText;"Loading checklists text");;
        Refresh(pssChecklistsChecklistsText);;
        ClearCollect(colChecklistsText;
            ShowColumns(
                Filter(pssChecklistsChecklistsText;
                    Load=true
                );
                ID;Title;ChecklistText;Description;LanguageTag
            )
        );;
        // Save checklists text locally
        If(MyDeviceType="Mobile";
            SaveData(colChecklistsText;"ChecklistsText")  
        );;
        //-------------------------------------------------
        //load checkpoints from SP list
        Set(FooterText;"Loading checkpoints");;
        Refresh(pssChecklistsCheckpoints);;
        ClearCollect(colCheckpoints;
            ShowColumns(
                Filter(pssChecklistsCheckpoints;
                    Load=true
                );
                ID;Title;Checkpoint;Pos;Required;PossibleStatus;Status1;Status2;Status3;Status4;Status5;FlexForm
            )
        );;
        // Save checkpoints locally
        If(MyDeviceType="Mobile";
            SaveData(colCheckpoints;"Checkpoints")  
        );;
        //-------------------------------------------------
        Set(FooterText;"Loading checkpoints text");;
        Refresh(pssChecklistsCheckpointsText);;
        ClearCollect(colCheckpointsText;
            ShowColumns(
                Filter(pssChecklistsCheckpointsText;
                    Load=true
                );
                ID;Title;Checkpoint;CheckpointText;Description;LanguageTag
            )
        );;
        // Save checkpoints text locally
        If(MyDeviceType="Mobile";
            SaveData(colCheckpointsText;"CheckpointsText")  
        );;
        //-------------------------------------------------
        //load flex fields from SP list
        Set(FooterText;"Loading flex fields");;
        Refresh(pssChecklistsFlexFields);;
        ClearCollect(colFlexFields;
            ShowColumns(
                Filter(pssChecklistsFlexFields;
                    Load=true
                );
                ID;Title;ResponseType;Choices;Load
            )
        );;
        // Save flex fields locally
        If(MyDeviceType="Mobile";
            SaveData(colFlexFields;"FlexFields")  
        );;
        //-------------------------------------------------
        //load flex fields text from SP list
        Set(FooterText;"Loading flex fields text");;
        Refresh(pssChecklistsFlexFieldsText);;
        ClearCollect(colFlexFieldsText;
            ShowColumns(
                Filter(pssChecklistsFlexFieldsText;
                    Load=true
                );
                ID;Title;Text;LanguageTag
            )
        );;
        // Save checklists text locally
        If(MyDeviceType="Mobile";
            SaveData(colFlexFieldsText;"FlexFieldsText")  
        );;
    ;//Else
        If(MyDeviceType="Mobile";
            Clear(colChecklists);;
            Clear(colChecklistsText);;
            Clear(colCheckpoints);;
            Clear(colCheckpointsText);;
            Clear(colFlexFields);;
            Clear(colFlexFieldsText);;
            
            Set(FooterText;"Loading checklists from cache");;
            LoadData(colChecklists;"Checklists";true);;

            Set(FooterText;"Loading checklists text from cache");;
            LoadData(colChecklistsText;"ChecklistsText";true);;
            
            Set(FooterText;"Loading checkpoints from cache");;
            LoadData(colCheckpoints;"Checkpoints";true);;

            Set(FooterText;"Loading checkpoints text from cache");;
            LoadData(colCheckpointsText;"CheckpointsText";true);;
            
            Set(FooterText;"Loading flex fields from cache");;
            LoadData(colFlexFields;"FlexFields";true);;

            Set(FooterText;"Loading flex fields text from cache");;
            LoadData(colFlexFieldsText;"FlexFieldsText";true);;
        )
    );;
    //-------------------------------------------------
    If(OnlineStatus=1 || MyDeviceType="Mobile";
        Set(FooterText;"Loading MyChecklists");;
        ClearCollect(MyChecklists;
            SortByColumns(
                AddColumns(
                    ShowColumns(
                        colChecklists;
                        Title
                    ) As aSource;

                    ChecklistText;
                        LookUp(colChecklistsText;
                        Title=aSource.Title&&
                        LanguageTag=Left(Language();2);
                        ChecklistText);
                    
                    Description;
                        LookUp(colChecklistsText;
                        Title=aSource.Title&&
                        LanguageTag=Left(Language();2);
                        Description);

                    Checkpoints;
                        ShowColumns(
                            Filter(colCheckpoints;
                            Title=aSource.Title
                            );
                            Title;Checkpoint
                        )

                );
                "ChecklistText";If(ChecklistsSortDescending;
                SortOrder.Descending;SortOrder.Ascending)
            )
        )
    );;
    If(CountRows(MyChecklists)>0;
        Set(SelectedChecklist;First(MyChecklists).Title);;
        Set(ChecklistSelected;true);;
    ;//Else
        Set(SelectedChecklist;"");;
        Set(ChecklistSelected;false);;
    );;
    //-------------------------------------------------
    If(OnlineStatus=1 || MyDeviceType="Mobile";
        Set(FooterText;"Loading MyFlexFields");;
        ClearCollect(MyFlexFields;
            SortByColumns(
                AddColumns(
                    ShowColumns(
                        colFlexFields;
                        Title;ResponseType;Choices
                    ) As aSource;

                    FlexFieldText;
                        LookUp(colFlexFieldsText;
                        Title=aSource.Title&&
                        LanguageTag=Left(Language();2);
                        Text)

                );
                "FlexFieldText";If(FlexFieldsSortDescending;
                SortOrder.Descending;SortOrder.Ascending)
            )
        );;
        Collect(MyFlexFields; 
        {
            Title:"";
            ResponseType:"";
            Choices:"";
            FlexFieldText:""
        });;
    );;
    If(CountRows(MyFlexFields)>0;
        Set(SelectedFlexField;First(MyFlexFields).Title);;
        Set(FlexFieldSelected;true);;
    ;//Else
        Set(SelectedFlexField;"");;
        Set(FlexFieldSelected;false);;
    );;
    //-------------------------------------------------
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
//Load status
If(IsBlank(InitialReadStatus)||InitialReadStatus;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadStatus;false);;
    //-----------------------------------------------------
    If(OnlineStatus=1;
        //load status from SP list
        Set(FooterText;"Loading status");;
        Refresh(pssChecklistsStatus);;
        ClearCollect(colStatus;
            AddColumns(
                ShowColumns(
                    pssChecklistsStatus;
                    ID;Status;DefectClass;Icon
                ) As aSource;
                StatusText;                        
                    LookUp(pssChecklistsStatusText;
                    Status=aSource.Status &&
                    LanguageTag=Left(Language();2);
                    StatusText)
            )
        );;
        // Save status locally
        If(MyDeviceType="Mobile";
            SaveData(colStatus;"Status")  
        );;
    ;//Else
        If(MyDeviceType="Mobile";
            Clear(colStatus);;
            Set(FooterText;"Loading status from cache");;
            LoadData(colStatus;"Status";true);;
        )
    );;
    //-------------------------------------------------
    If(OnlineStatus=1 || MyDeviceType="Mobile";
        ClearCollect(MyStatus;
            SortByColumns(
                ShowColumns(
                    colStatus;
                    Status;DefectClass;Icon;StatusText
                );
                "StatusText";SortOrder.Ascending
            )
        )
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
//List of possible icons
If(IsBlank(InitialReadIcons)||InitialReadIcons;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadIcons;false);;
    //-----------------------------------------------------
    ClearCollect(colIcons; 
        {Value:"Icon.Add";Icon:Icon.Add};
        {Value:"Icon.AddDocument";Icon:Icon.AddDocument};
        {Value:"Icon.AddLibrary";Icon:Icon.AddLibrary};
        {Value:"Icon.AddToCalendar";Icon:Icon.AddToCalendar};
        {Value:"Icon.AddUser";Icon:Icon.AddUser};
        {Value:"Icon.Blocked";Icon:Icon.Blocked};
        {Value:"Icon.Flag";Icon:Icon.Flag};
        {Value:"Icon.CheckBadge";Icon:Icon.CheckBadge};
        {Value:"Icon.ThumbsUp";Icon:Icon.ThumbsUp};
        {Value:"Icon.ThumbsDown";Icon:Icon.ThumbsDown};
        {Value:"Icon.EmojiNeutral";Icon:Icon.EmojiNeutral};
        {Value:"Icon.EmojiHappy";Icon:Icon.EmojiHappy};
        {Value:"Icon.EmojiSmile";Icon:Icon.EmojiSmile};
        {Value:"Icon.EmojiSad";Icon:Icon.EmojiSad};
        {Value:"Icon.Warning";Icon:Icon.Warning};
        {Value:"Icon.Medical";Icon:Icon.Medical};
        {Value:"Icon.Enhance";Icon:Icon.Enhance}
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------


