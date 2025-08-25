If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
);;
//---------------------------------------------
//Load all checkpoints from SP or from cache to local collections
If(IsBlank(InitialReadCheckpoints)||InitialReadCheckpoints;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadCheckpoints;false);;
    //-----------------------------------------------------
    If(OnlineStatus=1;
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
            Clear(colCheckpoints);;
            Clear(colCheckpointsText);;
            
            Set(FooterText;"Loading checkpoints from cache");;
            LoadData(colCheckpoints;"Checkpoints";true);;

            Set(FooterText;"Loading checkpoints text from cache");;
            LoadData(colCheckpointsText;"CheckpointsText";true);;
        )
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
//Load checkpoints
If(IsBlank(ReadCheckpoints)||ReadCheckpoints;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(FooterText;"Loading checkpoints");;
    //-----------------------------------------------------
    Set(ReadCheckpoints;false);;
    //-----------------------------------------------------
    If(IsBlank(CheckpointsSortDescending);
        Set(CheckpointsSortDescending;false)
    );;
    //-----------------------------------------------------
    //load checkpoints from local collections
    ClearCollect(MyCheckpoints;
        SortByColumns(
            AddColumns(
                ShowColumns(
                    Filter(
                        colCheckpoints;
                        Title=SelectedChecklist
                    );
                    Title;Checkpoint;Pos;Required;Status1;Status2;Status3;Status4;Status5;FlexForm
                ) As aSource;

                CheckpointText;
                    LookUp(colCheckpointsText;
                    Title=aSource.Title&&
                    Checkpoint=aSource.Checkpoint&&
                    LanguageTag=Left(Language();2);
                    CheckpointText);
                
                Description;
                    LookUp(colCheckpointsText;
                    Title=aSource.Title&&
                    Checkpoint=aSource.Checkpoint&&
                    LanguageTag=Left(Language();2);
                    Description)
                    
            );
            "Pos";If(CheckpointsSortDescending;
            SortOrder.Descending;SortOrder.Ascending)
        )
    );;
    If(CountRows(MyCheckpoints)>0;
        If(IsBlank(SelectedCheckpoint);
            Set(SelectedCheckpoint;
            First(MyCheckpoints).Checkpoint)
        );;
        Set(CheckpointSelected;true);;
    ;//Else
        Set(SelectedCheckpoint;"");;
        Set(CheckpointSelected;true);;
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//-----------------------------------------------------
If(CheckpointSelected;

    Set(SelectedCheckpointRecord;
        First(Filter(MyCheckpoints;
        Title=SelectedChecklist&&
        Checkpoint=SelectedCheckpoint))
    );;

    Set(SCheckpointPos;
        SelectedCheckpointRecord.Pos);;
    Set(SCheckpointText;
        SelectedCheckpointRecord.CheckpointText);;
    
    Set(SCheckpointDescription;
        SelectedCheckpointRecord.Description);;
    Set(SCheckpointDescription;
        Substitute(SCheckpointDescription;Char(10);"<br>")
    );;

    Set(SCheckpointRequired;
        SelectedCheckpointRecord.Required);;

    Set(SCheckpointStatus1;
        SelectedCheckpointRecord.Status1);;
    Set(SCheckpointStatus2;
        SelectedCheckpointRecord.Status2);;
    Set(SCheckpointStatus3;
        SelectedCheckpointRecord.Status3);;
    Set(SCheckpointStatus4;
        SelectedCheckpointRecord.Status4);;
    Set(SCheckpointStatus5;
        SelectedCheckpointRecord.Status5);;

    Set(SCheckpointFlexForm;
        SelectedCheckpointRecord.FlexForm);;

    //FlexForm auseinandernehmen 
    Clear(colFlexForm);;
    //result of the Split() function is a Value
    ForAll(Split(SCheckpointFlexForm;"DisplayOrder:");
        If(!IsBlank(Value) &&
            Value(First(Split(Value;",")).Value)<6;
            Collect(colFlexForm;
                {
                    Pos:SCheckpointPos;
                    DisplayOrder:
                        First(Split(Value;",")).Value;
                    Definition:
                        "DisplayOrder:"&Value;
                    Question:
                        First(Split(
                        Last(Split(Value;"Question:")).Value
                        ;",")).Value;
                    QuestionText:
                        LookUp(
                        MyFlexFields;
                        Title=First(Split(
                        Last(Split(Value;"Question:")).Value
                        ;",")).Value;
                        FlexFieldText);
                    ResponseType:
                        First(Split(
                        Last(Split(Value;"ResponseType:")).Value
                        ;",")).Value;
                    Choices:
                        If("Choices" in Value;
                            First(Split(
                            Last(Split(Value;"Choices:")).Value
                            ;",")).Value
                        )
                }
            )
        )
    );;

    Set(SCheckpointF1;
        LookUp(colFlexForm;Value(DisplayOrder)=1;Definition));;
    Set(SCheckpointF1Label;
        LookUp(colFlexForm;Value(DisplayOrder)=1;QuestionText));;

    Set(SCheckpointF2;
        LookUp(colFlexForm;Value(DisplayOrder)=2;Definition));;
    Set(SCheckpointF2Label;
        LookUp(colFlexForm;Value(DisplayOrder)=2;QuestionText));;

    Set(SCheckpointF3;
        LookUp(colFlexForm;Value(DisplayOrder)=3;Definition));;
    Set(SCheckpointF3Label;
        LookUp(colFlexForm;Value(DisplayOrder)=3;QuestionText));;

    Set(SCheckpointF4;
        LookUp(colFlexForm;Value(DisplayOrder)=4;Definition));;
    Set(SCheckpointF4Label;
        LookUp(colFlexForm;Value(DisplayOrder)=4;QuestionText));;

    Set(SCheckpointF5;
        LookUp(colFlexForm;Value(DisplayOrder)=5;Definition));;
    Set(SCheckpointF5Label;
        LookUp(colFlexForm;Value(DisplayOrder)=5;QuestionText));;


    Set(CheckpointSelected;false);;

);;
//-----------------------------------------------------
