Set(ShowDeleteDialog;false);;
Set (locErrorCode; "");;
//--------------------------------------------------------
// Delete checklist
If(IsBlank(locErrorCode);

    // remove from collection
    RemoveIf(MyCheckpoints;
        Title=SelectedChecklist&&
        Checkpoint=SelectedCheckpoint);; 
    
    //all good?
    If(!IsEmpty(Errors([@MyCheckpoints]));
        Set(locErrorCode; "Error! Was not able to delete the checkpoint");;
        Notify(
            locErrorCode;
            //LookUp(MyUVVSettings;
            //Title="Fehler beim Löschen in UVVKundenliste").Wert;
            NotificationType.Error;2000
        );;
    ;// Else
        Set (locErrorCode; "");;
    );;

    // Generate pos number
    If(IsBlank(locErrorCode);
        ClearCollect(
            MyCheckpoints;
            ForAll(
                Sequence(CountRows(MyCheckpoints));
                Patch(
                    Last(FirstN(MyCheckpoints; Value));
                    {Pos:Value}
                )
            )
        )
    );;

    //Remove from SP list
    If(IsBlank(locErrorCode) && OnlineStatus=1;
        RemoveIf(pssChecklistsCheckpoints;
            Title=SelectedChecklist&&
            Checkpoint=SelectedCheckpoint
        );; 
        RemoveIf(pssChecklistsCheckpointsText;
            Title=SelectedChecklist&&
            Checkpoint=SelectedCheckpoint
        );; 
        ForAll(MyCheckpoints As aSource;
            Patch(pssChecklistsCheckpoints;
                LookUp(pssChecklistsCheckpoints;
                Title=aSource.Title&&
                Checkpoint=aSource.Checkpoint);
                {Pos:aSource.Pos}
            )
        );;
    );;

    If(CountRows(MyCheckpoints)>0;
        Set(SelectedCheckpoint;
            First(MyCheckpoints).Checkpoint
        );;
        Set(CheckpointSelected;true);;
    ;//Else
        Set(SelectedCheckpoint;"");;
        Set(CheckpointSelected;false);;
    );;
    
    //Set(InitialReadCheckpoints;true);;
    //Set(ReadCheckpoints;true);;

);;

