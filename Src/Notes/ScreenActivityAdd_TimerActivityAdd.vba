Set( CurrentTime; Now() );;
//------------------------------------------------
If(Connection.Connected;
    Set (OnlineStatus; 1)
;// Else    
    Set (OnlineStatus; 0)
);;
