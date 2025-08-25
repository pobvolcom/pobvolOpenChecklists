Set(CurrentTime;Now());;
//-----------------------------------------------------
If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
);;
//------------------------------------------------
If(ActivitySelected;
    Set(ActivitySelected;false);;

    Set(_ShowLoadingHint;true);;

    Set(SelectedActivityRecord;
        First(Filter(MyActivities;ID=SelectedActivity))
    );;

    Set(SActivityKEY;SelectedActivityRecord.KEY);;
     Set(SActivityTitle;SelectedActivityRecord.Title);;
    Set(SActivityChecklistText;
        LookUp(MyChecklists;Title=SActivityTitle;ChecklistText)
    );;
    Set(SActivityUser;SelectedActivityRecord.User);;
    Set(SActivityUserEMail;SelectedActivityRecord.UserEMail);;
    Set(SActivityDate;SelectedActivityRecord.Date);;
    Set(SActivityDocumentStatus;SelectedActivityRecord.DocumentStatus);;
    Set(SActivityComments;SelectedActivityRecord.Comments);;

    //-----------------------------------------------------
    
    Clear(SComponents);;
    ForAll(
        Filter(colCheckpoints;Title = SActivityTitle) As aSource;
        
        Collect(SComponents;
            {
                ParentID:SelectedActivity;
                KEY:SActivityKEY;
                Pos:aSource.Pos;
                Checkpoint:aSource.Checkpoint;
                CheckpointText:
                    LookUp(colCheckpointsText;
                        Title=SActivityTitle &&
                        Checkpoint=aSource.Checkpoint&&
                        LanguageTag=Left(Language();2);
                        CheckpointText);
                Required:aSource.Required;
                PossibleStatus:
                        If(!IsBlank(aSource.Status1);aSource.Status1)&
                        If(!IsBlank(aSource.Status2);";"&aSource.Status2)&
                        If(!IsBlank(aSource.Status3);";"&aSource.Status3)&
                        If(!IsBlank(aSource.Status4);";"&aSource.Status4)&
                        If(!IsBlank(aSource.Status5);";"&aSource.Status5);
                Status:"";
                StatusText:"";
                DefectClass:0;
                Comments:"";
                FlexForm:aSource.FlexForm;
                F1:"";
                F2:"";
                F3:"";
                F4:"";
                F5:"";
                F1Title:"";
                F2Title:"";
                F3Title:"";
                F4Title:"";
                F5Title:"";
                F1Label:"";
                F2Label:"";
                F3Label:"";
                F4Label:"";
                F5Label:""
            }
        )
    );;
    //-----------------------------------------------------
    //Transform field FlexForm into collection colFlexForm 
    Clear(colFlexForm);;
    ForAll(SComponents As aSource;
        ForAll(Split(aSource.FlexForm;"DisplayOrder:");
            If(!IsBlank(Value);
                Collect(colFlexForm;
                    {
                        Pos:aSource.Pos;
                        DisplayOrder:
                            First(Split(Value;",")).Value;
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
                            FlexFieldText)
                        }
                )
            )
        );;
    );;
    //-----------------------------------------------------
    //Transfer title and text into SComponents 
    ForAll(colFlexForm As aPatch;
        Patch(SComponents;
            LookUp(SComponents;Pos=aPatch.Pos);
            Switch(aPatch.DisplayOrder;
                "1";
                    {F1Title:aPatch.Question;
                     F1Label:aPatch.QuestionText};
                "2";
                    {F2Title:aPatch.Question;
                     F2Label:aPatch.QuestionText};
                "3";
                    {F3Title:aPatch.Question;
                     F3Label:aPatch.QuestionText};
                "4";
                    {F4Title:aPatch.Question;
                     F4Label:aPatch.QuestionText};
                "5";
                    {F5Title:aPatch.Question;
                     F5Label:aPatch.QuestionText}
            )
        )
    );;
    //-----------------------------------------------------
    //Now add the existing data to the correct flex field
    //Note: We cannot use DisplayOrder for the transfer 
    //We must use the title od the flex field for the same!
    ForAll(
        
        Filter(MyActivitiesP;KEY=SActivityKEY) As aPatch;

        Patch(SComponents;
            LookUp(SComponents;Pos=aPatch.Pos);
            {
                Status:aPatch.Status;
                StatusText:aPatch.StatusText;
                DefectClass:aPatch.DefectClass;
                Comments:aPatch.Comments;

                F1:
                    Switch(
                        LookUp(SComponents;Pos=aPatch.Pos;F1Title);
                        aPatch.F1Title;Text(aPatch.F1);
                        aPatch.F2Title;Text(aPatch.F2);
                        aPatch.F3Title;Text(aPatch.F3);
                        aPatch.F4Title;Text(aPatch.F4);
                        aPatch.F5Title;Text(aPatch.F5);
                        ""
                    );
                F2:
                    Switch(
                        LookUp(SComponents;Pos=aPatch.Pos;F2Title);
                        aPatch.F1Title;Text(aPatch.F1);
                        aPatch.F2Title;Text(aPatch.F2);
                        aPatch.F3Title;Text(aPatch.F3);
                        aPatch.F4Title;Text(aPatch.F4);
                        aPatch.F5Title;Text(aPatch.F5);
                        ""
                    );
                F3:
                    Switch(
                        LookUp(SComponents;Pos=aPatch.Pos;F3Title);
                        aPatch.F1Title;Text(aPatch.F1);
                        aPatch.F2Title;Text(aPatch.F2);
                        aPatch.F3Title;Text(aPatch.F3);
                        aPatch.F4Title;Text(aPatch.F4);
                        aPatch.F5Title;Text(aPatch.F5);
                        ""
                    );
                F4:
                    Switch(
                        LookUp(SComponents;Pos=aPatch.Pos;F4Title);
                        aPatch.F1Title;Text(aPatch.F1);
                        aPatch.F2Title;Text(aPatch.F2);
                        aPatch.F3Title;Text(aPatch.F3);
                        aPatch.F4Title;Text(aPatch.F4);
                        aPatch.F5Title;Text(aPatch.F5);
                        ""
                    );
                F5:
                    Switch(
                        LookUp(SComponents;Pos=aPatch.Pos;F5Title);
                        aPatch.F1Title;Text(aPatch.F1);
                        aPatch.F2Title;Text(aPatch.F2);
                        aPatch.F3Title;Text(aPatch.F3);
                        aPatch.F4Title;Text(aPatch.F4);
                        aPatch.F5Title;Text(aPatch.F5);
                        ""
                    )
            }
        )
    );;
    //-----------------------------------------------------
    Set(locErrorCode;"");;
    Set(SCheckpointPos;0);;
    Set(_ShowLoadingHint;false);;

);;
