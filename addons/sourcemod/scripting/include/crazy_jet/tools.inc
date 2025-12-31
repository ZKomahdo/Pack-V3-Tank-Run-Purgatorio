stock _CloseHandle(&Handle:handle)
{
    if(handle != INVALID_HANDLE)
    {
        CloseHandle(handle);
        handle = INVALID_HANDLE;
    }
}

public IsValidClient(client) 
{ 
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}