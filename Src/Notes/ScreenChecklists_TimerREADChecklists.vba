If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
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
    ;//Else
        If(MyDeviceType="Mobile";
            Clear(colChecklists);;
            Clear(colChecklistsText);;
            Clear(colCheckpoints);;
            Clear(colCheckpointsText);;
            
            Set(FooterText;"Loading checklists from cache");;
            LoadData(colChecklists;"Checklists";true);;

            Set(FooterText;"Loading checklists text from cache");;
            LoadData(colChecklistsText;"ChecklistsText";true);;
            
            Set(FooterText;"Loading checkpoints from cache");;
            LoadData(colCheckpoints;"Checkpoints";true);;

            Set(FooterText;"Loading checkpoints text from cache");;
            LoadData(colCheckpointsText;"CheckpointsText";true);;
        )
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//---------------------------------------------
//Load checklists from local collection
If(IsBlank(ReadChecklists)||ReadChecklists;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(ReadChecklists;false);;
    //-----------------------------------------------------
    If(IsBlank(ChecklistsSortDescending);
        Set(ChecklistsSortDescending;true)
    );;
    //-----------------------------------------------------
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
    );;
    If(CountRows(MyChecklists)>0;
        If(IsBlank(SelectedChecklist);
            Set(SelectedChecklist;First(MyChecklists).Title)
        );;
        Set(ChecklistSelected;true);;
    ;//Else
        Set(SelectedChecklist;"");;
        Set(ChecklistSelected;false);;
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
If(ChecklistSelected;
    Set(SChecklistText;
        LookUp(MyChecklists;Title=SelectedChecklist;ChecklistText)
    );;
    Set(SDescription;
        LookUp(MyChecklists;Title=SelectedChecklist;Description)
    );;
    Set(SDescription;Substitute(SDescription;Char(10);"<br>"));;
    Set(SCheckpoints;
        //Filter(MyChecklists;Title=SelectedChecklist).Checkpoints
        LookUp(MyChecklists;Title=SelectedChecklist;Checkpoints)
    );;
    Set(ChecklistSelected;false);;
);;
//-----------------------------------------------------
Set(_ShowLoadingHint;false);;
Set(FooterText;"");;
