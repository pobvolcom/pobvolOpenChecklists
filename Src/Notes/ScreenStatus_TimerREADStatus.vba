If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
);;
//------------------------------------------------
//Load Status
If(IsBlank(InitialReadStatus)||InitialReadStatus=true;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadStatus;false);;
    //-----------------------------------------------------
    If(IsBlank(StatusSortDescending);
        Set(StatusSortDescending;false)
    );;
    //-----------------------------------------------------
    If(OnlineStatus=1;
        //-------------------------------------------------
        //load Status from SP list
        Set(FooterText;"Loading Status");;
        Refresh(pssChecklistsStatus);;
        ClearCollect(colStatus;
            AddColumns(
                ShowColumns(
                    Filter(pssChecklistsStatus;
                        SortNo>=0
                    );
                    ID;Titel;Status;SortNo;DefectClass;Icon
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
        //-------------------------------------------------
        //load Status text from SP list
        /*
        Set(FooterText;"Loading Status text");;
        Refresh(pssChecklistsStatusText);;
        ClearCollect(colStatusText;
            ShowColumns(
                Filter(pssChecklistsStatusText;
                    Load=true
                );
                ID;Title;Text;LanguageTag
            )
        );;
        // Save checklists text locally
        If(MyDeviceType="Mobile";
            SaveData(colStatusText;"StatusText")  
        );;
        */
    ;//Else
        If(MyDeviceType="Mobile";
            Clear(colStatus);;
            //Clear(colStatusText);;
            
            Set(FooterText;"Loading Status from cache");;
            LoadData(colStatus;"Status";true);;

            //Set(FooterText;"Loading Status text from cache");;
            //LoadData(colStatusText;"StatusText";true);;

        )
    );;
    ClearCollect(MyStatus;
        SortByColumns(
            ShowColumns(
                colStatus;
                Status;SortNo;DefectClass;Icon;StatusText
            );
            "SortNo";SortOrder.Ascending
        )
    );;

    If(CountRows(MyStatus)>0;
        If(IsBlank(SelectedStatus);
            Set(SelectedStatus;
                First(
                    Sort(
                        Filter(MyStatus;Status<>Blank());
                        StatusText
                    )
                ).Status
            )
        );;
        Set(StatusSelected;true);;
    ;//Else
        Set(SelectedStatus;"");;
        Set(StatusSelected;false);;
    );;

    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 

);;
//------------------------------------------------
If(StatusSelected=true;
    /*
    Set(SStatusSortNo;
        LookUp(MyStatus;Status=SelectedStatus;SortNo)
    );;
    */
    Set(SStatusDefectClass;
        LookUp(MyStatus;Status=SelectedStatus;DefectClass)
    );;
    Set(SStatusIcon;
        LookUp(MyStatus;Status=SelectedStatus;Icon)
    );;
    Set(SStatusText;
        LookUp(MyStatus;Status=SelectedStatus;StatusText)
    );;
    Set(StatusSelected;false);;
);;
//-----------------------------------------------------
Set(_ShowLoadingHint;false);;
Set(FooterText;"");;
