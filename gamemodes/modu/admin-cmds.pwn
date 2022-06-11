CMD:makeadmin(playerid, params[])
{
    if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][pAdmin] >= 2)
    {
        new playerb, adminlvl, insert[128];

		if(sscanf(params, "ui", playerb, adminlvl))
	        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /makeadmin [playerid/name] [level 0-3]");
        
        if(adminlvl < 0 || adminlvl > 3)
            return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: Invalid Admin Level");
        
        SendClientMessageEx(playerid, color_yellow, "You've just made: %s admin level: %i", ReturnName(playerb), adminlvl);
        SendClientMessageEx(playerb, color_red, "[Admin]{FFFFFF}:You've just been made Admin level: %i by: %s", adminlvl, ReturnName(playerid));

        PlayerInfo[playerb][pAdmin] = adminlvl;
        pAduty[playerb] = 0;
        SetPlayerHealth(playerb,100);
        LoadModeColor(playerb);
        mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pAdmin = %i WHERE acc_dbid = %i", adminlvl, PlayerInfo[playerb][pDBID]);
        mysql_tquery(ourConnection, insert);
        
    }
	else return SendClientMessage(playerid, color_red, "[Error]{FFFFFF} You're not allowed to use this Command");
    return 1;
}

CMD:slap(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb, string[120];
    new Float:slx, Float:sly, Float:slz;
    if(sscanf(params, "u", playerb))
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /slap [playerid]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");

    if(INL[playerb]){
    SendClientMessage(playerid, color_purple, "[Admin]{FFFFFF}: You cannot /slap someone that in is the lobby.");
    return 1;
    }

    GetPlayerPos(playerb, slx, sly, slz);
    SetPlayerPos(playerb, slx, sly, slz+5);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        PlayerPlaySound(i, 1130, 0.0, 0.0, 0.0);
    }

    format(string, sizeof(string), "[AdmCmd]{FD0000}: Moon has slaped %s (%d) face so hard, his face became a Pancake", ReturnName(playerb), playerb);
    SendClientMessageToAll(color_banned, string);

    return 1;
}

CMD:fakeban(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    new playerb, banreason[150], string[150];
    if(sscanf(params, "us[150]", playerb, banreason))
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /fakeban [playerid] [Reason]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");
    format(string, sizeof(string), "{FF2F00}%s has been Banned by admin %s Reason: %s", ReturnName(playerb), ReturnName(playerid), banreason);
    SendClientMessageToAll(color_red, string);
    SendClientMessage(playerb, color_banned, "=============You are permanently banned============");
    SendClientMessage(playerb, color_banned, "You are permanently banned.");
    SendClientMessageEx(playerb, color_banned, "Reason: (FAKE BAN) %s", banreason);
    SendClientMessageEx(playerb, color_banned, "Banned by: %s", ReturnName(playerid)); 
    SendClientMessage(playerb, color_banned, "");
    SendClientMessage(playerb, color_banned, "[!] You can appeal your ban on our discord (https:// discord .gg /rdaTBA6rgS)");
    SendClientMessage(playerb, color_banned, "[!] NOTE: you are not banned.");
    new msgstring[150];
    format(msgstring, sizeof(msgstring), "[AdmWarning]{FFFFFF}: %s %s (%d) fake banned %s (%d)",GetAdminRank(playerid), ReturnName(playerid),playerid, ReturnName(playerb),playerb);
    SendAdminMessage(color_banned,msgstring);
    return 1;
} 

CMD:jetpack(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has a jetpack", ReturnName(playerid),playerid);
	SendAdminMessage(color_banned,string);
	SetPlayerSpecialAction(playerid,2);
    return 1;
}

CMD:kick(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb, kickreason[120], string[120];
    if(sscanf(params, "us[120]", playerb, kickreason))
        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /kick [playerid] [Reason]");

    if(PlayerInfo[playerb][pBan] > 0 && PlayerInfo[playerid][pAdmin] < 3){
        return SendClientMessage(playerid, color_red, "Only server owner can use admin commands on admins.");
    }

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");

    format(string, sizeof(string), "%s has been kicked by %s Reason: %s", ReturnName(playerb), ReturnName(playerid), kickreason);
    SendClientMessageToAll(color_banned, string);
    SendClientMessage(playerb, color_banned, "=============You have been kicked============");
    SendClientMessage(playerb, color_banned, "Behave or you will be banned.");
    SendClientMessageEx(playerb, color_banned, "Kicked for: %s", kickreason);
    SendClientMessageEx(playerb, color_banned, "Kicked by: %s", ReturnName(playerid)); 
    SendClientMessage(playerb, color_banned, "");
    SendClientMessage(playerb, color_banned, "[!] You have been kicked, you can rejoin the game at anytime ");
    SendClientMessage(playerb, color_banned, "[!] NOTE: you are not banned.");
    KickEx(playerb);    
    return 1;
}

CMD:mute(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb, insert[128], mutereason[120], string[120];
    if(sscanf(params, "us[120]", playerb, mutereason))
        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /mute [playerid] [Reason]");

    if(PlayerInfo[playerb][pBan] > 0 && PlayerInfo[playerid][pAdmin] < 3){
        return SendClientMessage(playerid, color_red, "Only server owner can use admin commands on admins.");
    }

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");

    format(string, sizeof(string), "%s has been Muted by %s Reason: %s ", ReturnName(playerb), ReturnName(playerid), mutereason);
    SendClientMessageToAll(color_banned, string);  

    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pMute = 1 WHERE acc_dbid = %i",  PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert); 
    PlayerInfo[playerb][pMute] = 1;
    return 1;
}
CMD:unmute(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    new playerb, insert[128];
    if(sscanf(params, "u", playerb))
        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /unmute [playerid]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");
    SendClientMessage(playerb, color_lime, "You have been unmuted.");

    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has unmuted ID %d", ReturnName(playerid),playerid, playerb);
	SendAdminMessage(color_banned,string);

    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pMute = 0 WHERE acc_dbid = %i",  PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert); 
    
    PlayerInfo[playerb][pMute] = 0;
    return 1;
}
CMD:ban(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    new playerb, banreason[150], string[150];
    if(sscanf(params, "us[150]", playerb, banreason))
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /ban [playerid] [Reason]");

    if(PlayerInfo[playerb][pBan] > 0 && PlayerInfo[playerid][pAdmin] < 3){
        return SendClientMessage(playerid, color_red, "Only server owner can use admin commands on admins.");
    }

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");
    format(string, sizeof(string), "{FF2F00}%s has been Banned by admin %s Reason: %s", ReturnName(playerb), ReturnName(playerid), banreason);
    SendClientMessageToAll(color_red, string);
    PlayerInfo[playerb][pBan] = 1;
    SendClientMessage(playerb, color_banned, "=============You are permanently banned============");
    SendClientMessage(playerb, color_banned, "You are permanently banned.");
    SendClientMessageEx(playerb, color_banned, "Reason: %s", banreason);
    SendClientMessageEx(playerb, color_banned, "Banned by: %s", ReturnName(playerid)); 
    SendClientMessage(playerb, color_banned, "");
    SendClientMessage(playerb, color_banned, "[!] You can appeal your ban on our discord (https://discord.gg/rdaTBA6rgS)");
    SendClientMessage(playerb, color_banned, "[!] Please do not ban evade or you will not be unbanned.");

    new insert[300];
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pBan = 1 WHERE acc_dbid = %i",  PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert); 
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pBanReason = '%e' WHERE acc_dbid = %d", banreason, PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert);
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pBanAdmin = '%e' WHERE acc_dbid = %d", ReturnName(playerid), PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert);
    KickEx(playerb);
    return 1;
}

CMD:ac(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1){
        SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
        return 0;
    }

	if(isnull(params))
	{
	    return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /(a)c [text]");
	}
	if(PlayerInfo[playerid][pAdmin] > 0)	
	{
		new string[218];
		format(string, sizeof(string), "[Admin Chat] {FFA500}%s {FFFFFF}%s {FFA500}(%d){FFFFFF}: %s", GetAdminRank(playerid), PlayerInfo[playerid][pAccName],playerid, params);
		SendAdminMessage(color_red, string);
		return 1;
	}
    return 1;
}


CMD:a(playerid, params[])
{
	return cmd_ac(playerid, params);
}

CMD:gotomode(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

	if(!strcmp(params, "copchase", true))
	{
		SetTimerEx("UnfreezeTimer", 3000, false, "i", playerid);
		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 1565.2571,-1685.1045,62.1910);
		SendClientMessage(playerid, color_red, "[Cop Chase]{FFFFFF}: Welcome to Cop Chase (You used AdmCmd to get here)");
		SendClientMessage(playerid, color_red, "[Cop Chase]{FFFFFF}: Walk over the Cop icon to get started."); 
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) went to Cop Chase", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
	}
	else if(!strcmp(params, "grove", true))
	{
		new g_loc = random(3);
        SetPlayerPos(playerid, GsfLocations[g_loc][0], GsfLocations[g_loc][1], GsfLocations[g_loc][2]);
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) went to Grove", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
	}
	else if(!strcmp(params, "wh", true))
	{
        new w_loc = random(4);
        SetPlayerPos(playerid, WdmLocations[w_loc][0], WdmLocations[w_loc][1], WdmLocations[w_loc][2]);
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) went to Warehouse DM", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
	}
		else if(!strcmp(params, "lobby", true))
	{
		SetPlayerPos(playerid, 376.1006,2469.7708,16.5846);
	}
        else
    {
       SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /gotomode [copchase|grove|wh|lobby]");
    }
	return 1;
}

CMD:copchase(playerid, params[])
{
	SetTimerEx("UnfreezeTimer", 3000, false, "i", playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerPos(playerid, 1565.2571,-1685.1045,62.1910);
	SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: Welcome to Cop Chase");
	SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: Walk over the Cop icon to get started."); 
    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) went to Cop Chase", ReturnName(playerid),playerid);
	SendAdminMessage(color_banned,string);
    return 1;
}

CMD:goto(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

	new targetid;
	if(sscanf(params, "u", targetid))
	{
	    SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /goto [playerid|name]");
		return 1;
	}
	else
	{
		if(!IsPlayerConnected(targetid))
		{
		    return SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: That Player is not online");
		}
	//	TeleportToPlayer(playerid, targetid);
	}

	return 1;
}


CMD:annouce(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    if(isnull(params))
    {
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /annouce [message]");
    }

    new astring[322];
    format(astring, sizeof(astring), "%s", params);
    TextDrawSetString(annoucetext, astring);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        ServerIsAnnoucing = 1;
        TextDrawShowForPlayer(i, annoucegreen);
        TextDrawShowForPlayer(i, annoucetext);
    }
    new string[248];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) is annoucing ''%s''", ReturnName(playerid),playerid,astring);
	SendAdminMessage(color_banned,string);
    return 1;
}


CMD:cc(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

	if(!strcmp(params, "annouce", true))
	{
        TextDrawHideForAll(annoucegreen);
        TextDrawHideForAll(annoucetext);
        ServerIsAnnoucing = 0;
	}
	else if(!strcmp(params, "chat", true))
	{
        for(new i = 0; i < MAX_PLAYERS; i++)
        ClearChatbox(i, 45);
        SendClientMessageToAll(color_purple, "~ Florida DM ~ | {FFFFFF}F:DM");
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has cleared the Chatbox!", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
	}
	else if(!strcmp(params, "gmx", true))
	{
        TextDrawHideForAll(gmxtd);
        SendClientMessageToAll(color_red,"[Restart]{FFFFFF}: The server restart has been canceled");
        KillTimer(GmxTimer);
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has stopped the GMX!", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
	}
    else if(!strcmp(params, "death", true))
    {
        for(new i = 0; i < MAX_PLAYERS; i++)
        SendDeathMessage(225, 255, 255);
        new string[82];
		format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has cleared the DeathBox", ReturnName(playerid),playerid);
		SendAdminMessage(color_banned,string);
    }
    else
    {
       SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /cc [chat|annouce|gmx|death]");
    }
	return 1;
}

CMD:gmx(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

	if(!strcmp(params, "confirm", true))
	{
    TextDrawShowForAll(gmxtd);
    SendClientMessageToAll(color_red,"[Restart]{FFFFFF}: Server will restart in 5 seconds");
    GmxTimer = SetTimer("SetToGmx", 6500, false);
    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has used /gmx!", ReturnName(playerid),playerid);
	SendAdminMessage(color_banned,string);
    SendClientMessage(playerid, color_cyan, "Use ''/cc gmx'' to stop the restart");
	}
        else
    {
        SendClientMessage(playerid, color_red, "[WARNING]{FFFFFF}: use {FD0000}''/gmx confirm'' {FFFFFF}to proceed.");
        new string[82];
	    format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has attempted to use /gmx!", ReturnName(playerid),playerid);
	    SendAdminMessage(color_banned,string);
    }
	return 1;
}

CMD:ahelp(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

	new alevel = PlayerInfo[playerid][pAdmin];
	if(alevel >= 1)
	{
		SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /ban, /unmute, /listmuted, /jetpack, /gotomode, /kick, /a(c)");
        SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /freeze, /unfreeze, /say, /unban, /slap, /aduty, /apm");
        SendClientMessage(playerid, color_error, "[Support]{FFFFFF}: /vs, /cs");
        SendClientMessage(playerid, color_error, "[Report]{FFFFFF}: /vr, /cr");
	}
	if(alevel >= 2)
	{
		SendClientMessage(playerid, color_yellow,"[Developer]{FFFFFF}: /gmx, /annouce, /cc, /makehimtalk, /botsay, /crime, /fakeban");
        SendClientMessage(playerid, color_yellow,"[Developer]{FFFFFF}: /setdonator, /unsetdonator, /makeadmin");
	}
	if(alevel >= 3)
	{
		SendClientMessage(playerid, color_ask,"[Owner]{FFFFFF}: /freezeall, /unfreezeall, /forcelobbyall, /clearalltickets");
	}
	return 1;
}

CMD:listmuted(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    for(new i; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pMute] == 1)
				{
                    new string[38];
				    format(string, sizeof(string), "%s {FFFFFF} is muted.", ReturnName(i));
					SendClientMessage(playerid, color_banned, string);
                }
            }
        }
    return 1;
}

CMD:freezeall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        TogglePlayerControllable(i, 0);
    }
    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has froze all the players in the server", ReturnName(playerid),playerid);
	SendAdminMessage(color_banned,string);
    SendClientMessageToAll(color_cyan,"You have been frozen by a owner.");
    return 1;
}

CMD:unfreezeall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        TogglePlayerControllable(i, 1);
    }
    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has unfrozen all the players in the server", ReturnName(playerid),playerid);
	SendAdminMessage(color_banned,string);
    SendClientMessageToAll(color_cyan,"You have been unfrozen by a owner.");
    return 1;
}

CMD:forcelobbyall(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 3)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        return cmd_lobby(i, params);
    }
    new string[82];
	format(string, sizeof(string), "[AdmCmd]{FFFFFF}: %s (%d) has forced lobby to all the players in the server", ReturnName(playerid),playerid);
	SendAdminMessage(color_banned,string);
    SendClientMessageToAll(color_cyan,"You have been sent to the lobby by a owner.");
    return 1;
}

CMD:freeze(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb, string[120];
    if(sscanf(params, "u", playerb))
        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /freeze [playerid]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");

    if(PlayerInfo[playerb][pBan] > 0 && PlayerInfo[playerid][pAdmin] < 3){
        return SendClientMessage(playerid, color_red, "Only server owner can use admin commands on admins.");
    }

    format(string, sizeof(string), "%s has been frozen by %s", ReturnName(playerb), ReturnName(playerid));
    SendClientMessageToAll(color_banned, string);
    TogglePlayerControllable(playerb, 0);
    return 1;
}

CMD:unfreeze(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb, string[120];
    if(sscanf(params, "u", playerb))
        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /freeze [playerid]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");

    format(string, sizeof(string), "%s has been unfrozen by %s", ReturnName(playerb), ReturnName(playerid));
    SendClientMessage(playerb ,color_banned, string);
    TogglePlayerControllable(playerb, 1);
    return 1;
}

CMD:botsay(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    if(isnull(params))
    {
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /botsay [message]");
    }

    new string[182];
    format(string, sizeof(string), "Moon{FFFFFF}: %s", params);
    SendClientMessageToAll(0xFD0000FF,string);
    return 1;
}

CMD:say(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    if(isnull(params))
    {
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /say [message]");
    }

    new string[182];
    format(string, sizeof(string), "{FD0000}%s %s (%d): %s",GetAdminRank(playerid),PlayerInfo[playerid][pAccName],playerid, params);
    SendClientMessageToAll(color_banned,string);
    return 1;
}


CMD:crime(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");

    new playerb, crimetype;

	if(sscanf(params, "ui", playerb, crimetype))
	    return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /crime [playerid/name] [type 3-22]");
        
    if(crimetype < 3 || crimetype > 22)
        return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: Number must be between 3 to 22"); // Diego don't touch
        
    SendClientMessageEx(playerid, color_red, "[Crime]{FFFFFF}: Playing crime sound for %s, type %i", ReturnName(playerb), crimetype);
    PlayCrimeReportForPlayer(playerb, 0, crimetype);
    return 1;
}


CMD:unban(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1){
        return SendClientMessage(playerid, color_red, "You're not allowed to use this Command");
    }
    new username[MAX_PLAYER_NAME];
    if(sscanf(params, "s[24]", username))return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /unban [username]");
    
    new insert[256];
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE `accounts` SET `pBan`='0' WHERE `acc_name`='%e'", username);
    mysql_tquery(ourConnection, insert, "OnPlayerUnbanned", "is", playerid, username);
    return 1;
}

forward OnPlayerUnbanned(playerid, username[]);
public OnPlayerUnbanned(playerid, username[])
{
    new message[300];

    if(cache_affected_rows()){
          format(message, sizeof(message), "[Unban] %s has been unbanned by %s %s (%d)", username, GetAdminRank(playerid), ReturnName(playerid), playerid);
          SendAdminMessage(color_banned, message);
    }
    else{
          format(message, sizeof(message), "%s cant be unbanned", username);
          SendClientMessage(playerid, color_red, message);          
    }
    return 1;
}

CMD:setdonator(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    {
        return SendClientMessage(playerid, color_red, "You are not authorized to use this command.");
    }
    new playerb, insert[200], string[200];
	if(sscanf(params, "u", playerb))
	    return SendClientMessage(playerid, color_red, "[Usage]{FFFFFF}: /setdonator [playerid/name]");
        
    SendClientMessageEx(playerid, color_ask, "You've just made ID: %d that player a Donator.",playerb);
    SendClientMessageEx(playerb, color_ask, "[Donator]{FFFFFF}: You've just been made Donator by %s",ReturnName(playerid));

    format(string, sizeof(string), "[Donator]{FFFFFF}: %s has been set as a donator by %s (%d)", ReturnName(playerb), ReturnName(playerid),playerid);
    SendAdminMessage(color_ask, string);

    PlayerInfo[playerb][pDonator] = 1;
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pDonator = 1 WHERE acc_dbid = %i", PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert);
    return 1;
}

CMD:unsetdonator(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 2)
    {
        return SendClientMessage(playerid, color_red, "You are not authorized to use this command.");
    }
    new playerb, insert[200], string[200];
	if(sscanf(params, "u", playerb))
	    return SendClientMessage(playerid, color_red, "[Admin]{FFFFFF}: /unsetdonator [playerid/name]");
        
    SendClientMessageEx(playerid, color_ask, "You've removed the donator status from %s", ReturnName(playerb));
    SendClientMessageEx(playerb, color_ask, "[Donator]{FFFFFF}: Your donation status has expired/removed by %s (%d)",ReturnName(playerid),playerid);
        
    format(string, sizeof(string), "[Donator]{FFFFFF}: %s has been removed as a donator by %s", ReturnName(playerb), ReturnName(playerid));
    SendAdminMessage(color_ask, string);

    PlayerInfo[playerb][pDonator] = 0;
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE accounts SET pDonator = 0 WHERE acc_dbid = %i", PlayerInfo[playerb][pDBID]);
    mysql_tquery(ourConnection, insert); 
    return 1;
}

CMD:aduty(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
    {
        return SendClientMessage(playerid, color_red, "You are not authorized to use this command.");
    }

    if(!pAduty[playerid])
    {
        pAduty[playerid] = 1;
        SetPlayerHealth(playerid, 800);
        SetPlayerColor(playerid, 0xFD0000FF);
        SendClientMessage(playerid, color_red,"[Admin Duty]{FFFFFF}: You went on duty");
    }
    else
    {
        pAduty[playerid] = 0;
        LoadModeColor(playerid);
        SetPlayerHealth(playerid, 100);
        SendClientMessage(playerid, color_red,"[Admin Duty]{FFFFFF}: You went off duty");
    }
    return 1;
}

CMD:vs(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb;
    if(sscanf(params, "u", playerb))
        return SendClientMessage(playerid, color_red, "[Support]{FFFFFF}: /vs [ticketid]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This ticket has expired or does not exist");

    if(ActiveSupport[playerb] == 0){
    SendClientMessage(playerid, color_purple, "[Support]{FFFFFF}: This ticket id does not exist");
    return 1;
    }

    ActiveSupport[playerb] = 0;
    SendClientMessageEx(playerb, color_ticket, "%s (%d) is now looking into your submitted support request.", ReturnName(playerid),playerid);
	if (_:g_SupportLogChannel == 0)
	g_SupportLogChannel = DCC_FindChannelById("827402863947939890");
    new stringa[250];
    format(stringa, sizeof(stringa), "[AdmCmd]{FD0000}: %s (%d) support ticket has been taken by %s %s (%d)", ReturnName(playerb), playerb, GetAdminRank(playerid), ReturnName(playerid), playerid);
    SendAdminMessage(color_red, stringa);
    new stringb[250];
    format(stringb, sizeof(stringb), "[Support] %s %s(%d) is looking in to %s(%d) submitted support",GetAdminRank(playerid),ReturnName(playerid),ReturnName(playerb),playerb );
    DCC_SendChannelMessage(g_SupportLogChannel, stringb);

    return 1;
}

CMD:vr(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, color_red, "You're not Allowed to use this Command.");
    
    new playerb;
    if(sscanf(params, "u", playerb))
        return SendClientMessage(playerid, color_red, "[Report]{FFFFFF}: /vr [ticketid]");

    if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This ticket has expired or does not exist");

    if(ActiveReport[playerb] == 0){
    SendClientMessage(playerid, color_purple, "[Report]{FFFFFF}: This ticket id does not exist");
    return 1;
    }

    ActiveReport[playerb] = 0;
    SendClientMessageEx(playerb, color_ticket, "%s %s (%d) is looking in to your submitted report", GetAdminRank(playerid), ReturnName(playerid),playerid);
	if (_:g_ReportLogChannel == 0)
	g_ReportLogChannel = DCC_FindChannelById("827402805710028811");
    new stringa[250];
    format(stringa, sizeof(stringa), "[AdmCmd]{FD0000}: %s %s (%d) is looking in to %s (%d) submitted report",GetAdminRank(playerid),ReturnName(playerid),ReturnName(playerb),playerb);
    SendAdminMessage(color_red, stringa);
    new stringb[250];
    format(stringb, sizeof(stringb), "[Report] %s %s(%d) is looking in to %s(%d) submitted report",GetAdminRank(playerid),ReturnName(playerid),ReturnName(playerb),playerb);
    DCC_SendChannelMessage(g_ReportLogChannel, stringb);

    return 1;
}


/*
CMD:acreategroup(playerid, params[])
{
    new grID = groupid+1,query[128],player,str[128];
    if(PlayerInfo[playerid][pAdmin] < 2)
    {
        return SendClientMessage(playerid, color_red, "You are not authorized to use this command.");
    }
    if(sscanf(params, "u", player)) return SendClientMessage(playerid,color_red,"[USAGE]: /creategroup [playerid/Name]");
	if(!IsPlayerConnected(player)) return SendClientMessage(playerid,color_red,"[Error]{FFFFFF}: Player hasn't connected to server yet.");
	if(PlayerInfo[player][grouppid] != 0) return SendClientMessage(playerid,color_red,"[Error]{FFFFFF}: Player already is in a group.");
//	if(playerid == player) return SendClientMessage(playerid,color_red,"[ERROR]: You can't give a group to yourself.");
    GroupInfo[grID][gID] = grID;
    GroupInfo[grID][gchat] = 0;
    format(GroupInfo[grID][gTAG],5,"None");
    PlayerInfo[player][grouppid] = grID;
    format(GroupInfo[grID][gName],128,"None");
    format(GroupInfo[grID][gOwnerName],32,ReturnName(player));
	mysql_format(ourConnection, query, sizeof(query), "INSERT INTO `groups` (`gID`, `gchat`, `gTAG`, `gName`, `gOwnerName`) VALUES (%d,%d,%d,'%e','%e')",
	grID+1,
	GroupInfo[grID][gchat],
	GroupInfo[grID][gTAG],
	GroupInfo[grID][gName],
	GroupInfo[grID][gOwnerName]);
    mysql_tquery(ourConnection, query, "GroupCreated", "i",grID);
    format(str,sizeof(str),"[Group]{FFFFFF}: %s (%d) has created %s and has set %s as the group owner",ReturnName(playerid), playerid, GroupInfo[grID][gName],GroupInfo[grID][gOwnerName]);
    SendAdminMessage(color_red,str);
	return 1;
}*/