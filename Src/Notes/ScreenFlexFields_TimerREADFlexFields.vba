If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
);;
//------------------------------------------------
//Load FlexFields from SP
If(IsBlank(InitialReadFlexFields)||InitialReadFlexFields;
    Set(_ShowLoadingHint;true);;
    //-----------------------------------------------------
    Set(InitialReadFlexFields;false);;
    //-----------------------------------------------------
    If(IsBlank(FlexFieldsSortDescending);
        Set(FlexFieldsSortDescending;false)
    );;
    //-----------------------------------------------------
    If(OnlineStatus=1;
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
            Clear(colFlexFields);;
            Clear(colFlexFieldsText);;
            
            Set(FooterText;"Loading flex fields from cache");;
            LoadData(colFlexFields;"FlexFields";true);;

            Set(FooterText;"Loading flex fields text from cache");;
            LoadData(colFlexFieldsText;"FlexFieldsText";true);;

        )
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//---------------------------------------------
//Load flex fields from local collection
If(IsBlank(ReadFlexFields)||ReadFlexFields;
    Set(_ShowLoadingHint;true);;
    Set(ReadFlexFields;false);;
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
    //-----------------------------------------------------
    If(CountRows(MyFlexFields)>0;
        If(IsBlank(SelectedFlexField);
            Set(SelectedFlexField;First(MyFlexFields).Title)
        );;
        Set(FlexFieldSelected;true);;
    ;//Else
        Set(SelectedFlexField;"");;
        Set(FlexFieldSelected;false);;
    );;
    Set(FooterText;"");;
    Set(_ShowLoadingHint;false);; 
);;
//------------------------------------------------
If(FlexFieldSelected;
    Set(SFlexFieldText;
        LookUp(MyFlexFields;Title=SelectedFlexField;FlexFieldText)
    );;
    Set(SFlexFieldResponseType;
        LookUp(MyFlexFields;Title=SelectedFlexField;ResponseType)
    );;
    Set(SFlexFieldChoices;
        LookUp(MyFlexFields;Title=SelectedFlexField;Choices)
    );;
    Set(FlexFieldSelected;false);;
);;
//-----------------------------------------------------
Set(_ShowLoadingHint;false);;
Set(FooterText;"");;
