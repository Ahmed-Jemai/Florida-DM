//#pragma warning disable 239
//#pragma warning disable 214

#include <a_samp>
#define SSCANF_NO_NICE_FEATURES
#include <crashdetect>
#include <sscanf2>
#include <zcmd>
#include <a_mysql>
#include <mSelection>
#include <streamer>
#include <foreach>
#include <discord-connector>
#include <afk>
#include <discord-cmd>
#define SCRIPT_VERSION "Florida DM"

#include "./modu/defines.pwn"

//Discord Vars
#define SendDiscordMessage DCC_SendChannelMessage

new DCC_Channel:g_ReportLogChannel;
new DCC_Channel:g_SupportLogChannel;
new DDC_Channel:g_BotCommandsChannel;

//-------TextDraws----
//Sprunk
new Text:sprunkbk;
new Text:sprunkred;
new Text:sprunkh;
new Text:sprunkval;
new Text:sprunkown;
new Text:sprunknme;
new Text:sprunktype;

// main td?

new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;
new Text:Textdraw4;

// hit marker
new Text:HitMarker;
new hittimer;

// gmx td

new Text:gmxtd;

// td ccc
new Text:ccc_Textdraw5;
new Text:ccc_Textdraw6;
new Text:ccc_Textdraw7;
new Text:ccc_Textdraw8;

// stats td
//Variables
//new PlayerText:StatsScoreTD[MAX_PLAYERS];
new PlayerText:StatsKDTD[MAX_PLAYERS];
new PlayerText:StatsModeTD[MAX_PLAYERS];
new PlayerText:StatsNameTD[MAX_PLAYERS];
//new PlayerText:StatsSkinTD[MAX_PLAYERS];
new PlayerText:LocationTD[MAX_PLAYERS];

// annouce td

new Text:annoucegreen;
new Text:annoucetext;
new ServerIsAnnoucing;

//Tickets

new ActiveReport[MAX_PLAYERS];
new ActiveSupport[MAX_PLAYERS];

//Settings

new togpm[MAX_PLAYERS];
new publicoff[MAX_PLAYERS];
new showconnect[MAX_PLAYERS];
new showlocation[MAX_PLAYERS];
new showhitmarker[MAX_PLAYERS];

//----------Vehicles---------------//
//gwar
new pLastUsed[MAX_PLAYERS];
new gwar_grove[10];
new gwar_ballas[10];
new gwar_azceta[10];
new gwar_vagos[11];
//vip gwar
new gwar_azcetavip[1];
new gwar_grovevip[1];
new gwar_ballasvip[1];
new gwar_vagosvip[1];

//cop chase
new copchase_police[13];
new copchase_criminal[13];

//----------CreatePickup-----------//
new CopChasePickup;
new GwarSprunkPickup[5];
//-----------Versus------------//
//-----------------DUEL----------//

new bool:InvitedDuel[MAX_PLAYERS];
new IdDuel[MAX_PLAYERS];
new bool:UsingArena;
new Counting = 5;
new CountDueling[5][5] ={"~r~1","~b~2","~p~3","~y~4","~g~5"};
// Mode Detector

new ModeDetectionResults[MAX_PLAYERS];

// Admin Duty

new pAduty[MAX_PLAYERS];

//------------------Dm Areas / Lobby Vars----------------------------//
new INL[MAX_PLAYERS]; // In lobby Status
new INGWR[MAX_PLAYERS];  // in Gang war status
new LVPD[MAX_PLAYERS]; // in LVpd arena status
new WDM[MAX_PLAYERS]; // in Ware house dm status
new INDM[MAX_PLAYERS]; // in Dm status 

//actors
new Actordm; 
new Actorgwr;
new Actorvs;
new Actorcopchase;

new INRCDM[MAX_PLAYERS]; // in rc ground dm status
new PDM[MAX_PLAYERS]; //in Pleasure dm status
new SDM[MAX_PLAYERS]; // in sniper dm status
new GDM[MAX_PLAYERS]; // in Ghost town dm area status

// ------- Gang war Vars -----------//
new GSF[MAX_PLAYERS]; // In GSF team status
new NBA[MAX_PLAYERS]; // In NBA team status
new LSV[MAX_PLAYERS];  // in LSV team status
new VAR[MAX_PLAYERS];  // in Various team Status
new turflimit;
new turf;
new PLAYERCAP[MAX_PLAYERS];
new caping;
new caped; // Turf is capped
new nbacaping; // NBA are Captureing
new varcaping;  // VAR are capturing
new lsvcaping;// LSV are capturing
new gsfcaping ;  // GSF are capturing
new capedbynba; // Turf is captured by NBA
new capedbylsv; // Turf is captured by GSF
new capedbyvar; // Turf is captured by VAR
new capedbygsf; // Turf is captured by LSV
new turftime; 
new KILLSPREE[MAX_PLAYERS];

//
new GmxTimer;
//

//cop chase vars
new INCOP[MAX_PLAYERS]; //being in Cop Chase
new COPLEO[MAX_PLAYERS]; //being swat/sapd/fbi
new COPVOL[MAX_PLAYERS];//defined for /r
new COPPOLICE[MAX_PLAYERS]; // for /r
new COPFBI[MAX_PLAYERS]; // for /r
new COPHRT[MAX_PLAYERS];// for /r
new COPCRIM[MAX_PLAYERS]; // criminal
// end of cop chase vars

new playerLogin[MAX_PLAYERS];
//-------------- Skins Vars --------------------//
new joinskin = mS_INVALID_LISTID;
new gsfskin = mS_INVALID_LISTID; 
new nbaskin = mS_INVALID_LISTID;
new lsvskin = mS_INVALID_LISTID;
new varskin = mS_INVALID_LISTID;
new policeskin = mS_INVALID_LISTID;

new fbiskin = mS_INVALID_LISTID;
//-------------account data stuff--------------//

enum P_ACCOUNT_DATA
{
    pDBID,
	gSkin, // grove skins stored
	nSkin, // ////////
	lSkin, // /// 
	vSkin, // //// 
	pAccName[60],
	pMoney,
	pKills,
	pDeaths,
	pScore,
	pMute,
	pBan,
	pDonator,
	pBanReason,
	pBanDate,
	pBanAdmin,
	pAdmin,
	pSkin,
	grouppid,
	grouprank[32], // Pskin stored
	bool:pLoggedin
}
//new groupid=-1;


new PlayerInfo[MAX_PLAYERS][P_ACCOUNT_DATA];

/*
enum groupsDATA
{
	gID,
	gName[128],
	gOwnerName[32],
	gchat,
	gTAG
};
new GroupInfo[MAX_GROUPS][groupsDATA];
new groupvariables[MAX_PLAYERS][2];
*/
//--------------------------------///
enum Vector3 {
  Float:x,
  Float:y,
  Float:Z
}

new locations[9][Vector3] = {
    // place your coords here
    {376.1006,2469.7708,16.5846},
    {370.5598,2469.9504,16.5846},
    {365.4152,2470.1277,16.5846},
    {365.7121,2475.5298,16.5846},
    {370.2319,2475.3789,16.5846},
    {375.3858,2474.9541,16.5846},
    {372.9134,2467.5376,16.5846},
    {368.3280,2462.5168,16.5846},
    {376.0320,2461.6362,16.5846}
};

//-------------------LVPD-------------------------------------------//

new Float:LvpdLocations[5][3] = {
	{289.0496,168.1495,1007.1719},
	{265.7121,177.8508,1003.0234},
	{245.8876,148.6157,1003.0234},
	{239.0486,140.8305,1003.0234},
	{225.1446,141.5526,1003.0234}
};

//--------------------WDM Locations---------------------------------//

new Float:WdmLocations[4][3] = {
	{1404.8436,-37.9528,1000.9127},
	{1408.8740,-9.4860,1000.9225},
	{1370.1227,1.3195,1000.9259},
	{1385.7327,-29.4326,1000.9221}

};


//-----------RCDM Spawn locations---------------------------------//

new Float:RandomLocations[6][3] = {
    {-974.4043,1075.2675,1344.9893},
    {-971.1730,1098.6224,1344.9908},
    {-996.4645,1048.7456,1342.3790},
    {-1052.8442,1047.8080,1343.2664},
    {-1098.9122,1079.4275,1341.8438},
    {-1126.9934,1050.7898,1345.7157}
};


//------------------Pleasuer dm Locations ===================================//
new Float:PdmLocations[5][3] = {
	{-2650.4873,1408.5455,906.2734},
	{-2674.9656,1396.3260,906.4609},
	{-2686.8784,1424.2056,906.4609},
	{-2666.3035,1423.5043,912.4114},
	{-2640.762939,1406.682006,906.460937}
};

//=========================Sniper Dm locations ============================//
new Float:SdmLocations[4][3] = {
	{-1307.2635,951.1805,1036.5547},
	{-1284.2697,979.3960,1036.9832},
	{-1408.8906,1059.7404,1038.5428},
	{-1480.0658,1041.8961,1038.3656}
};
//=========================Ghost town Dm locations ============================//

new Float:GdmLocations[5][3] = {
	{-362.0218,2244.5146,42.4844},
	{-333.5226,2219.1729,42.4883},
	{-359.8234,2197.7471,42.4844},
	{-440.3313,2214.8699,42.4297},
	{-419.8005,2234.0447,42.4297}

};

//=========================Gang war GSF locations ============================//

new Float:GsfLocations[3][3] = {
	{2495.3521,-1689.5631,14.5091},
	{2498.1624,-1652.0914,13.4889},
	{2512.6851,-1669.8492,13.4865}
};

//=========================Gang war NBA locations ============================//

new Float:NbaLocations[3][3] = {
	{2171.6921,-1614.7716,14.3171},
	{2166.4895,-1593.0443,14.3516},
	{2175.8350,-1598.5226,14.3516}

};

//========================= Gang War LSV locations ============================//

new Float:LsvLocations[2][3] = {
	{2232.4470,-1457.5726,24.0085},
	{2254.4854,-1452.8417,23.8281}
};
//========================= GANG WAR VAR locations ============================//

new Float:VarLocations[3][3] = {
	{1892.2242,-2021.6604,13.5469},
	{1872.2274,-2025.3639,13.5544},
	{1870.2988,-2037.4833,13.5469}
};
//-----------Statics----------------------------//

static stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser", "SFPD Cruiser", "LVPD Cruiser",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

//------------------------MYSQL CONNECTION--------------------------------------//
new MySQL:ourConnection;
#define SQL_HOSTNAME "localhost"
#define SQL_USERNAME "root"
#define SQL_DATABASE "florida_deathmatch"
#define SQL_PASSWORD ""

//=============================================================================//
main()
{
	print("\n----------------------------------");
	print(" Florida Deathmatch ");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
    ourConnection = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_PASSWORD, SQL_DATABASE);

    if(mysql_errno() == 0)
    {
        printf ("[DATABASE]: Connection established to MYSQL", SQL_DATABASE);
    }
    else
    {
        printf ("[DATABASE]: Connection failed to MYSQL", SQL_DATABASE);
        SendRconCommand("Exit");
        return 0;
    }
//===============SKINS========================================//
	//Login Skins:
    joinskin = LoadModelSelectionMenu("a_skins.txt");
	//Gang War:
    gsfskin  = LoadModelSelectionMenu("g_gsf.txt");
    lsvskin  = LoadModelSelectionMenu("g_lsv.txt");   
    varskin  = LoadModelSelectionMenu("g_var.txt");
    nbaskin  = LoadModelSelectionMenu("g_nba.txt");
	//Police Chase:
	fbiskin = LoadModelSelectionMenu("c_fbi.txt");
	policeskin = LoadModelSelectionMenu("c_police.txt");
    // Pickups
	CopChasePickup = CreatePickup(1247, 1, 1565.2725,-1692.8180,62.1910); 
	GwarSprunkPickup[0] = CreatePickup(1274, 23, 2229.7592, -1457.9022, 23.8303, -1); //near jeff church
	GwarSprunkPickup[1] = CreatePickup(1274, 23, 2145.0109, -1645.8503, 15.0804, -1); //ballas
	GwarSprunkPickup[2] = CreatePickup(1274, 23, 1929.5269, -1773.1405, 13.4013, -1); //bigdollar
	GwarSprunkPickup[3] = CreatePickup(1274, 23, 2496.6188, -1643.3398, 13.7771, -1); //bigdollar
	GwarSprunkPickup[4] = CreatePickup(1274, 23, 1869.3774, -2035.8093, 13.5413, -1); //bigdollar
// ================= ACTORS =====================================//
    Actorvs = CreateActor(132, 376.0784, 2457.8845, 16.5846, 357.3683);
    CreateDynamic3DTextLabel("{FF8282}[!] {FFFFFF}Shoot to join Versus", -1, 376.0784, 2457.8845, 17.5846, 100);
    Actorgwr = CreateActor(106, 371.8899, 2458.1199, 16.5846, 1.7110);
    CreateDynamic3DTextLabel("Shoot to join Gang Wars", -1, 371.8899, 2458.1199, 17.5846, 100);
    Actordm = CreateActor(136, 366.2433, 2458.1440, 16.5846, 354.8301);
    CreateDynamic3DTextLabel("Shoot for the DM Menu", -1, 366.2433, 2458.1440, 17.5846, 100);
	Actorcopchase = CreateActor(266, 369.2019, 2458.1045, 16.5846, 353.1014);
	CreateDynamic3DTextLabel("{FF8282}[!] {FFFFFF}Shoot to join Cop Chase", -1, 369.2019, 2458.1045, 17.5846, 100); 
	CreateDynamic3DTextLabel(" {FF8282}Under Development", color_red, 369.2019, 2458.1045, 17.7000, 100);
	CreateDynamic3DTextLabel(" {FF8282}Under Development", color_red, 376.0784, 2457.8845, 17.7000, 100);
    SetActorInvulnerable(Actordm, false);
    SetActorInvulnerable(Actorgwr, false);
	SetActorInvulnerable(Actorcopchase, false);
	SetActorInvulnerable(Actorvs, false);

    SetGameModeText("Florida Deathmatch");
    DisableInteriorEnterExits();
	//Turfs
	turflimit = CreateDynamicRectangle(1903.5, -1762.5001831054688, 1949.5, -1801.5001831054688, -1, -1, -1);
	turf = GangZoneCreate(1903.5, -1762.5001831054688, 1949.5, -1801.5001831054688);
	// Modulars
	#include "./modu/textdraws/global.pwn"
	#include "./modu/mapping.pwn" 
	#include "./modu/vehicles.pwn"

return 1;
}

public OnPlayerRequestClass(playerid, classid)
{

	if(PlayerInfo[playerid][pLoggedin] == false)
	{
     	SetSpawnInfo( playerid, 0, 0, 563.3157, 3315.2559, 0, 269.15, 0, 0, 0, 0, 0, 0 );
     	TogglePlayerSpectating(playerid, true);
     	TogglePlayerSpectating(playerid, false);
     	SetPlayerCamera(playerid);
    	return 1;
 	}
	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], 2098.5088,1159.1156,11.6484, 65.2418, 0, 0, 0, 0, 0, 0 );
 	SpawnPlayer(playerid);
	SetPlayerTeam(playerid, 1);
	
    return 0;
}


public OnPlayerConnect(playerid)
{
	//textdraws
	#include "./modu/textdraws/player.pwn"
//-------------------------[GS9 Exterior Removed Objects]----------------------//
	RemoveBuildingForPlayer(playerid, 1412, 1917.3203, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1912.0547, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1906.7734, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1927.8516, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1922.5859, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1938.3906, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1933.1250, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1778.4531, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1774.3125, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1771.3438, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1951.6094, -1821.1250, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1951.6094, -1815.8594, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1951.6094, -1810.5938, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1951.6094, -1805.3281, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1948.9844, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1943.6875, -1797.4219, 13.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1951.6094, -1800.0625, 13.8125, 0.25);
	//Removes vending machines
    RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
//==================MIlleclaouns ========================================//
	SetPlayerColor(playerid, color_white);
    SetPlayerCamera(playerid);
	ResetStatus(playerid);
	new string[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(string, sizeof(string), "[Server]{FFFFFF}: {e803fc}%s {FFFFFF}has joined the server.",name);
//	groupvariables[playerid][0] = -1;
//   groupvariables[playerid][1] = 0;
    SendConnectMessage(color_red, string);
	publicoff[playerid] = false; 

	new existCheck[248];	
	mysql_format(ourConnection, existCheck, sizeof(existCheck), "SELECT * FROM accounts WHERE acc_name = '%s'", ReturnName(playerid));
	mysql_tquery(ourConnection, existCheck, "LogPlayerIn", "i", playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerInfo[playerid][pLoggedin] == true)
	{
		SetPlayerName(playerid, PlayerInfo[playerid][pAccName]);
		return 1;
	}

    new string[128];
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(string, sizeof(string), "[Server]{FFFFFF}: %s {FFFFFF}has left the server. ",name);
    SendConnectMessage(color_red, string);
	ResetStatus(playerid);
    RemovePlayerAttachedObject(playerid, 8);
    RemovePlayerAttachedObject(playerid, 9);

	if(PLAYERCAP[playerid]){

		new shit[128];
		GetPlayerName(playerid, name, sizeof(name));
        format(shit, sizeof(shit), "[Gang War]{FFFFFF}: %s Failed to Capture the turf. (Logged off)", name);
        SendGwarMessage(color_orange, shit);
		KillTimer(turftime);
		GangZoneStopFlashForAll(turf);
	    PLAYERCAP [playerid] = 0;
     	caping = 0;
        gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
//		groupvariables[playerid][0] = -1;
 //   	groupvariables[playerid][1] = 0;
	    return 1;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(INCOP[playerid]){
		SetTimerEx("UnfreezeTimer", 3000, false, "i", playerid);
		TogglePlayerControllable(playerid, 0);
		SetPlayerPos(playerid, 1565.2571,-1685.1045,62.1910);
		SetPlayerWantedLevel(playerid, 0);
		INL [playerid] = 1;
		GSF [playerid] = 0;
		NBA [playerid] = 0;
		LSV [playerid] = 0;
		INGWR [playerid] = 0;
		VAR [playerid] = 0;
		LVPD [playerid] = 0;
		WDM [playerid] = 0;
		INDM [playerid] = 0;
		INRCDM [playerid] = 0;
		PDM [playerid] = 0;
		SDM [playerid] = 0;
		GDM [playerid] = 0;
		COPPOLICE [playerid] = 0;
		COPLEO [playerid] = 0;
		COPFBI [playerid] = 0;
		COPHRT [playerid] = 0;
		COPCRIM [playerid] = 0;
		INCOP [playerid] = 0;
	}

	if(GSF[playerid]){
		SetPlayerSkin(playerid, PlayerInfo[playerid][gSkin]);
		new g_loc = random(3);
        SetPlayerPos(playerid, GsfLocations[g_loc][0], GsfLocations[g_loc][1], GsfLocations[g_loc][2]);
        cmd_gangwarweapontable(playerid, "");
	}

	if(NBA[playerid]){
		SetPlayerSkin(playerid, PlayerInfo[playerid][nSkin]);
		new n_loc = random(3);
        SetPlayerPos(playerid, NbaLocations[n_loc][0], NbaLocations[n_loc][1], NbaLocations[n_loc][2]);
        cmd_gangwarweapontable(playerid, "");

	}

	if(LSV[playerid]){
		SetPlayerSkin(playerid, PlayerInfo[playerid][lSkin]);
		new l_loc = random(2);
		SetPlayerPos(playerid, LsvLocations[l_loc][0], LsvLocations[l_loc][1], LsvLocations[l_loc][2]);
		cmd_gangwarweapontable(playerid, "");

	}

	if(VAR[playerid]){
		SetPlayerSkin(playerid, PlayerInfo[playerid][vSkin]);
		new v_loc = random(3);
		SetPlayerPos(playerid, VarLocations[v_loc][0], VarLocations[v_loc][1], VarLocations[v_loc][2]);
		cmd_gangwarweapontable(playerid, "");

	}

	if(SDM[playerid]){
		new s_loc = random(4);
        SetPlayerPos(playerid, SdmLocations[s_loc][0], SdmLocations[s_loc][1], SdmLocations[s_loc][2]);
	    SetPlayerInterior(playerid, 15);
	    ResetPlayerWeapons(playerid);
	    SetPlayerHealth(playerid, 100);
	    SetPlayerArmour(playerid, 100);
	    GivePlayerWeapon(playerid, 34, 999);
	}

	if(GDM[playerid]){
		new g_loc = random(5);
        SetPlayerPos(playerid, GdmLocations[g_loc][0], GdmLocations[g_loc][1], GdmLocations[g_loc][2]);
        ResetPlayerWeapons(playerid);
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 100);
        GivePlayerWeapon(playerid, 24, 999);
        GivePlayerWeapon(playerid, 33, 999);
        GivePlayerWeapon(playerid, 25, 999);
	}

	if(PDM[playerid]){
		new p_loc = random(5);
        SetPlayerPos(playerid, PdmLocations[p_loc][0], PdmLocations[p_loc][1], PdmLocations[p_loc][2]);
		SetPlayerInterior(playerid, 3);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 30, 10000);
		GivePlayerWeapon(playerid, 24, 999);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
	}

	if(INRCDM[playerid]){
	new r_loc = random(6);
    SetPlayerPos(playerid, RandomLocations[r_loc][0], RandomLocations[r_loc][1], RandomLocations[r_loc][2]);
	SetPlayerInterior(playerid, 10);
	ResetPlayerWeapons(playerid);
	SetPlayerArmour(playerid, 100);
	SetPlayerHealth(playerid, 100);
	GivePlayerWeapon(playerid, 24, 999);
	GivePlayerWeapon(playerid, 27, 999);
	GivePlayerWeapon(playerid, 34, 999);
	GivePlayerWeapon(playerid, 31, 999);
	}
	
    if(LVPD[playerid]){
        new d_loc = random(5);
        SetPlayerPos(playerid, LvpdLocations[d_loc][0], LvpdLocations[d_loc][1], LvpdLocations[d_loc][2]);
    	SetPlayerInterior(playerid, 3);
	    GivePlayerWeapon(playerid, 24, 1000);
	    SetPlayerHealth(playerid, 100);
	    SetPlayerArmour(playerid, 100);

    }
    
	if(WDM[playerid]){
        new w_loc = random(4);
        SetPlayerPos(playerid, WdmLocations[w_loc][0], WdmLocations[w_loc][1], WdmLocations[w_loc][2]);
 		SetPlayerInterior(playerid, 1);
   		ResetPlayerWeapons(playerid);
   		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
		GivePlayerWeapon(playerid, 24, 1000);
		GivePlayerWeapon(playerid, 25, 100000);
    }
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	KILLSPREE [playerid] = 0;
	KILLSPREE [killerid] += 1;
	if(KILLSPREE[killerid] == 2){
		GameTextForPlayer(killerid, "~b~Double Kill", 2000, 6);
		return 1;
	}
	if(KILLSPREE[killerid] == 3){
        GameTextForPlayer(killerid, "~y~Triple Kill", 2000, 6);
		new message[120];
		format(message, sizeof(message), "%s is on {FFFFFF}Three Killing Spree!", ReturnName(killerid));
		SendClientMessageToAll(color_yellow, message);
		return 1;
	}
	if(KILLSPREE[killerid] == 4){
        GameTextForPlayer(killerid, "~r~Quadra Kill", 2000, 6);
		new message[120];
		format(message, sizeof(message), "%s is on {FFFFFF}Four Killing Spree!", ReturnName(killerid));
		SendClientMessageToAll(color_yellow, message);
		return 1;
	}
    SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
    GivePlayerMoney(killerid, 500);
	PlayerInfo[killerid][pKills] += 1;
	PlayerInfo[playerid][pDeaths] += 1;
    new insert[200];
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE `accounts` SET `acc_score`='%d', `acc_money`='%d', `acc_kills`='%d' WHERE `acc_dbid`='%d'", GetPlayerScore(killerid), GetPlayerMoney(killerid), PlayerInfo[killerid][pKills],PlayerInfo[killerid][pDBID]); 
	mysql_tquery(ourConnection, insert);
    mysql_format(ourConnection, insert, sizeof(insert), "UPDATE `accounts` SET `acc_deaths`='%d' WHERE `acc_dbid`='%d'", PlayerInfo[playerid][pDeaths], PlayerInfo[playerid][pDBID]);
	mysql_tquery(ourConnection, insert);


    RemovePlayerAttachedObject(playerid, 8);
    RemovePlayerAttachedObject(playerid, 9);
	SendClientMessage(playerid, color_pink,"[Death]{FFFFFF}: you are being respawned.");
	SendDeathMessage(killerid, playerid, reason);
	if(PLAYERCAP[playerid])
	{
		GangZoneStopFlashForAll(turf);
		SendGwarMessage(color_orange, "[Gang War]{FFFFFF}: Turf Capturer has been killed, Failed to Capture the turf.");
		KillTimer(turftime);
		caping = 0;
		PLAYERCAP [playerid] = 0;
        gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
	    
	}
	
	if(InvitedDuel[playerid] == true || InvitedDuel[killerid] == true )
    {
        new Float:healthkiller;
        new namekiller[24],string[44];
        GetPlayerName(killerid, namekiller, 24);
        GetPlayerHealth(killerid,healthkiller);
        format(string, sizeof(string), "[Duel]{FFFFFF}: %s has won the duel",namekiller);
        SendClientMessage(playerid,0xF600F6AA, string);
        SendClientMessage(killerid,0xF600F6AA, string);
		RemovePlayerAttachedObject(playerid, 8);
    	RemovePlayerAttachedObject(playerid, 9);
		cmd_lobby(playerid, "");
        InvitedDuel[killerid] = false;
        InvitedDuel[playerid] = false;
        IdDuel[playerid] = false;
        IdDuel[killerid] = false;
        UsingArena = false;
        healthkiller = 0;
		return cmd_lobby(killerid, "");
    }
 	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{

    if(PlayerInfo[playerid][pMute] > 0){
        SendClientMessage(playerid, color_red, "You're Muted.");
        return 0;
    }
    if(PlayerInfo[playerid][pLoggedin] == false)
    {
        SendClientMessage(playerid, color_red, "[Retart Alert]{FFFFFF}: bruv, try logging in first");
        return 0;
    }
	if(publicoff[playerid] == 1)
	{
		SendClientMessage(playerid, color_error, "You have toggled Public Chat, use /settings to turn it back on.");
	}
	if(PlayerInfo[playerid][pDonator] >= 1)
    {
        new vipstring[128];
        format(vipstring, sizeof(vipstring), "[VIP] {%06x}%s (%d){FFFFFF}: %s", GetPlayerColor(playerid) >>> 8 ,ReturnName(playerid), playerid, text);
        SendPublicMessage(color_ask, vipstring);
        return 0;
    }
	else
	{
		new pstring[128];
        format(pstring, sizeof(pstring), "{%06x}%s (%d){FFFFFF}: %s",GetPlayerColor(playerid) >>> 8, ReturnName(playerid), playerid, text);
        SendPublicMessage(color_white, pstring);
	}
    return 0;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
    if(issuerid != INVALID_PLAYER_ID) PlayerPlaySound(issuerid,17802,0.0,0.0,0.0), PlayerPlaySound(playerid,1130,0.0,0.0,0.0);
	if(showhitmarker[issuerid] == 1)
    {
        TextDrawShowForPlayer(issuerid, HitMarker);
        hittimer = SetTimerEx("HITTD", 250, true, "%d", issuerid);
//        PlayerPlaySound(issuerid,1057,0,0,0);
    }
    return 1;
}


public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(vehicleid >= gwar_ballas[0] && vehicleid <= gwar_ballas[9])
	{
	    if(NBA[playerid])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_pink,"[Vehicle]{FFFFFF}: This vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= gwar_grove[0] && vehicleid <= gwar_grove[9])
	{
	    if(GSF[playerid])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_pink,"[Vehicle]{FFFFFF}: This vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}

	}
	if(vehicleid >= gwar_azceta[0] && vehicleid <= gwar_azceta[9])
	{
	    if(VAR[playerid])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_pink,"[Vehicle]{FFFFFF}: This vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= copchase_police[0] && vehicleid <= copchase_police[12])
	{
	    if(COPLEO[playerid])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_blue,"[Vehicle]{FFFFFF}: This vehicle is for Law Enforcment");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= copchase_criminal[0] && vehicleid <= copchase_criminal[12])
	{
	    if(COPCRIM[playerid])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_criminal,"[Vehicle]{FFFFFF}: This vehicle is for Criminals");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= gwar_vagos[0] && vehicleid <= gwar_vagos[10])
	{
	    if(LSV[playerid])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_pink,"[Vehicle]{FFFFFF}: This vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= gwar_grovevip[0] && vehicleid <= gwar_grovevip[0])
	{
	    if(GSF[playerid] && PlayerInfo[playerid][pDonator])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_ask,"[Donator]{FFFFFF}: You are not a Donator, or this vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= gwar_ballasvip[0] && vehicleid <= gwar_ballasvip[0])
	{
	    if(NBA[playerid] && PlayerInfo[playerid][pDonator])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_ask,"[Donator]{FFFFFF}: You are not a Donator, or this vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= gwar_azcetavip[0] && vehicleid <= gwar_azcetavip[0])
	{
	    if(VAR[playerid] && PlayerInfo[playerid][pDonator])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_ask,"[Donator]{FFFFFF}: You are not a Donator, or this vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}
	if(vehicleid >= gwar_vagosvip[0] && vehicleid <= gwar_vagosvip[0])
	{
	    if(LSV[playerid] && PlayerInfo[playerid][pDonator])
	{
	return 1;
	}
	    {
	    	SendClientMessage(playerid, color_ask,"[Donator]{FFFFFF}: You are not a Donator, or this vehicle is not for your gang");
	    	ClearAnimations(playerid);
		}
	}


	return 1;

}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == CopChasePickup)
	{
	SetPlayerPos(playerid, 1565.3887,-1691.4082,62.1910);	
	ShowPlayerDialog(playerid, 6, DIALOG_STYLE_LIST, "Cop Chase", "Criminal\nSAPD\nFBI", "Select", "Close");
	}
	if(pickupid >= GwarSprunkPickup[0] && pickupid <= GwarSprunkPickup[4])
	{
	SetTimerEx("RemoveInfoTD", 2500, false, "i", playerid);
	TextDrawShowForPlayer(playerid, sprunkbk);
	TextDrawShowForPlayer(playerid, sprunkred);
	TextDrawShowForPlayer(playerid, sprunktype);
	TextDrawShowForPlayer(playerid, sprunkh);
	TextDrawShowForPlayer(playerid, sprunknme);
	TextDrawShowForPlayer(playerid, sprunkown);
	TextDrawShowForPlayer(playerid, sprunkval);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
		if(newkeys & KEY_CTRL_BACK)
		{
			cmd_sprunk(playerid, "\1");
			pLastUsed[playerid] = gettime(); // Prevents spamming. Sometimes keys get messed up and register twice.
		}
		return 1;
}

forward DetectModeFromPlayer(playerid);
public DetectModeFromPlayer(playerid)
{
	if(INL[playerid])//1
	{
		ModeDetectionResults [playerid] = 1;
		return 1;
	}
	if(INGWR[playerid])//2
	{
		ModeDetectionResults [playerid] = 2;
		return 1;
	}
	if(LVPD[playerid])//3
	{
		ModeDetectionResults [playerid] = 3;
		return 1;
	}
	if(WDM[playerid])//4
	{
		ModeDetectionResults [playerid] = 4;
		return 1;
	}
	if(INRCDM[playerid])//5 | in rc ground dm status
	{
		ModeDetectionResults [playerid] = 5;
		return 1;
	}
	if(PDM[playerid])//6
	{
		ModeDetectionResults [playerid] = 6;
		return 1;
	}
	if(SDM[playerid])//7
	{
		ModeDetectionResults [playerid] = 7;
		return 1;
	}
	if(GDM[playerid])//8
	{
		ModeDetectionResults [playerid] = 8;
		return 1;
	}
	if(INCOP[playerid])//9
	{
		ModeDetectionResults [playerid] = 9;
		return 1;
	}
	return 1;
}


forward LoadModeColor(playerid);
public LoadModeColor(playerid)
{
	if(INL[playerid] || SDM[playerid] || PDM[playerid] || LVPD[playerid] || WDM[playerid] || INRCDM[playerid] || GDM[playerid])//1
	{
		SetPlayerColor(playerid, color_white);
		return 1;
	}
	if(COPPOLICE[playerid] || COPFBI[playerid] || COPHRT[playerid])//2
	{
		SetPlayerColor(playerid, color_blue);
		return 1;
	}
	if(COPVOL[playerid])//3
	{
		SetPlayerColor(playerid, COLOR_VOL);
		return 1;
	}
	if(COPCRIM[playerid])//4
	{
		SetPlayerColor(playerid, color_criminal);
		return 1;
	}
	if(GSF[playerid])//4
	{
		SetPlayerColor(playerid, COLOR_GROVE);
		return 1;
	}
	if(NBA[playerid])//9
	{
		SetPlayerColor(playerid, COLOR_BALLAS);
		return 1;
	}
	if(LSV[playerid])//9
	{
		SetPlayerColor(playerid, COLOR_VAGOS);
		return 1;
	}
	if(VAR[playerid])//9
	{
		SetPlayerColor(playerid, COLOR_AZCETAS);
		return 1;
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	DetectModeFromPlayer(playerid);
	UpdateStatsTD(playerid);
//	if(showlocation[playerid] == 1)
//	{
//		new locstring[255];
//		format(locstring, sizeof(locstring), "%s",GetZoneName(playerid));
//		PlayerTextDrawSetString(playerid,LocationTD[playerid], locstring);
//	}
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

forward RemoveInfoTD(playerid); 
public RemoveInfoTD(playerid)
{
	TextDrawHideForPlayer(playerid, Textdraw0);
	TextDrawHideForPlayer(playerid, Textdraw1);
	TextDrawHideForPlayer(playerid, Textdraw2);
	TextDrawHideForPlayer(playerid, Textdraw3);
	TextDrawHideForPlayer(playerid, Textdraw4);

    //cop chase cop
	TextDrawHideForPlayer(playerid, ccc_Textdraw5);
	TextDrawHideForPlayer(playerid, ccc_Textdraw6);
	TextDrawHideForPlayer(playerid, ccc_Textdraw7);
	TextDrawHideForPlayer(playerid, ccc_Textdraw8);

    //cop chase crim

    //gang war sprunk
	TextDrawHideForPlayer(playerid, sprunkbk);
	TextDrawHideForPlayer(playerid, sprunkred);
	TextDrawHideForPlayer(playerid, sprunkh);
	TextDrawHideForPlayer(playerid, sprunkval);
	TextDrawHideForPlayer(playerid, sprunkown);
	TextDrawHideForPlayer(playerid, sprunknme);
	TextDrawHideForPlayer(playerid, sprunktype);
    return 1;
}

forward ExpireDuel(playerid,pid);
public ExpireDuel(playerid,pid)
{
    if(UsingArena == false)
    {
        SendClientMessage(pid,0x1DF6F6AA,"[Duel]{FFFFFF}: Duel Offer expired");
        SendClientMessage(playerid,0x1DF6F6AA,"[Duel]{FFFFFF}: You did not respond in time, Duel offer was expired");
        InvitedDuel[pid] = false;
        InvitedDuel[playerid] = false;
        IdDuel[playerid] = playerid;
        IdDuel[pid] = pid;
    }
    return 1;
}

forward UnfreezeTimer(playerid);
public UnfreezeTimer(playerid)
{
	TogglePlayerControllable(playerid, 1);
    return 1;
}

forward GoDuel(playerid,pid);
public GoDuel(playerid,pid)
{
    //SetPlayerArmor
    //SetPlayerHealth

    //-> Functions for Count x1<-//
	SetPlayerPos(playerid, 1413.1495,-15.9198,1000.9246);
	SetPlayerPos(pid, 1367.6084,-17.7317,1000.9219);
	SetPlayerHealth(playerid, 100);
	SetPlayerHealth(pid, 100);
	SetPlayerArmour(playerid, 100);
	SetPlayerArmour(pid, 100);
	SetPlayerTeam(playerid, NO_TEAM);
	SetPlayerTeam(pid, NO_TEAM);
	SetPlayerInterior(playerid, 1);
	SetPlayerInterior(pid, 1);
    TogglePlayerControllable(playerid,false);
    TogglePlayerControllable(pid,false);
    ExecuteCount(playerid,pid);
    return 1;
}

forward ExecuteCount(playerid,pid);
public ExecuteCount(playerid,pid)
{
    if (Counting > 0)
    {
        GameTextForPlayer(playerid,CountDueling[Counting-1], 2500, 3);
        GameTextForPlayer(pid,CountDueling[Counting-1], 1000, 3);
        Counting--;
        SetTimerEx("GoDuel",1000,false,"ii",playerid,pid);
    }
    else
    {
        GameTextForPlayer(playerid,"~>~~g~Go~w~Go~r~Go~b~Go~<~", 2500, 3);
        GameTextForPlayer(pid,"~>~~g~Go~w~Go~r~Go~b~Go~<~", 2500, 3);
        Counting = 5;
        TogglePlayerControllable(playerid,true);
        TogglePlayerControllable(pid,true);
    }
    return 1;
}

forward SetToGmx();
public SetToGmx()
{
	SendRconCommand("gmx");
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
	{
		case DIALOG_REGISTER:
		{
			if(!response)
			{
				SendClientMessage(playerid, color_red, "You were kicked for not registering.");
				KickEx(playerid);
				return 1;
			}

			new insert[200];
			if(strlen(inputtext) > 128 || strlen(inputtext) < 3)
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{FFFFFF}Welcome to {AF11ED}Florida DM", "{FFFFFF}You have can now register!\n\n{FFFFFF}Your password needs to be greater than 3 and less than 128 characters.\n{FD0000}[?]{FFFFFF}TIP: Please report all bugs that you\nmay have found to development.\n\n           Enter Your Password:", "Login", "Cancel");

			mysql_format(ourConnection, insert, sizeof(insert), "INSERT INTO accounts (acc_name, acc_pass, register_ip, register_date) VALUES('%e', sha1('%e'), '%e', '%e')", ReturnName(playerid), inputtext, ReturnIP(playerid), ReturnDate());
			mysql_tquery(ourConnection, insert, "OnPlayerRegister", "i", playerid);
		}
		case DIALOG_LOGIN:
		{
			if (!response)
			{
				SendClientMessage(playerid, color_red, "[!] {FFFFFF}Make sure you login {FD0000}({FFFFFF}kicked{FD0000})");
				return KickEx(playerid);
			}

			new continueCheck[211];

			mysql_format(ourConnection, continueCheck, sizeof(continueCheck), "SELECT acc_dbid FROM accounts WHERE acc_name = '%e' AND acc_pass = sha1('%e') LIMIT 1",
				ReturnName(playerid), inputtext);

			mysql_tquery(ourConnection, continueCheck, "LoggingIn", "i", playerid);
			return 1;
		}
		case DIALOG_DM:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0: return cmd_lvpd(playerid, "");
					case 1: return cmd_wdm(playerid, "");
					case 2: return cmd_rcdm(playerid, "");
					case 3: return cmd_pdm(playerid, "");
					case 4: return cmd_sdm(playerid, "");
					case 5: return cmd_gdm(playerid, "");
					
				}
			}
		}
		case DIALOG_SETTINGS:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
					SendClientMessage(playerid,color_error,"Changing passwords is currently being worked on");
					}
					case 1: 
					{
					if(showconnect[playerid] == 1)
						{
						showconnect[playerid] = false;
						return cmd_settings(playerid, "");
						}
						else
						{
						showconnect[playerid] = true;
						return cmd_settings(playerid, "");
						}
					}
					case 2:
					{
					if(publicoff[playerid] == 0)
						{
						publicoff[playerid] = true;
						return cmd_settings(playerid, "");
						}
						else
						{
						publicoff[playerid] = false;
						return cmd_settings(playerid, "");
						}
					}
					case 3:
					{
					if(togpm[playerid] == 0)
						{
						togpm[playerid] = true;
						return cmd_settings(playerid, "");
						}
						else
						{
						togpm[playerid] = false;
						return cmd_settings(playerid, "");
						}
					}
					case 4:
					{
					if(showlocation[playerid] == 0)
						{
						showlocation[playerid] = true;
						PlayerTextDrawShow(playerid, LocationTD[playerid]);
						return cmd_settings(playerid, "");
						}
						else
						{
						PlayerTextDrawHide(playerid, LocationTD[playerid]);
						showlocation[playerid] = false;
						return cmd_settings(playerid, "");
						}
					}
					case 5:
					{
					if(showhitmarker[playerid] == 0)
						{
						showhitmarker[playerid] = true;
						return cmd_settings(playerid, "");
						}
						else
						{
						showhitmarker[playerid] = false;
						return cmd_settings(playerid, "");
						}
					}
					case 6:
					{

					}
					
				}
			}
		}
		case DIALOG_WPN:
		{
			if(!response)
				return ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "{FAFAFA}Choose Your Weapons", "Deagle\tShotgun\nDeagle\tAk47\nDeagle\tSniper", "Select", "Cancel");

			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
						ResetPlayerWeapons(playerid);
						SetPlayerHealth(playerid, 100);
						SetPlayerArmour(playerid, 100);
						GivePlayerWeapon(playerid, 24, 999);
						GivePlayerWeapon(playerid, 25, 999);
					}
					case 1:
					{
						ResetPlayerWeapons(playerid);
						SetPlayerHealth(playerid, 100);
						SetPlayerArmour(playerid, 100);
						GivePlayerWeapon(playerid, 24, 999);
						GivePlayerWeapon(playerid, 30, 2000);
					}
					case 2:
					{
						ResetPlayerWeapons(playerid);
						SetPlayerHealth(playerid, 100);
						SetPlayerArmour(playerid, 100);
						GivePlayerWeapon(playerid, 24, 999);
						GivePlayerWeapon(playerid, 34, 200);
					}
				}
			}

		}

		case DIALOG_GWR:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
						ShowModelSelectionMenu(playerid, gsfskin, "Pick your skin!"); 
						
					} 

					case 1:
					{
						ShowModelSelectionMenu(playerid, nbaskin, "Pick your skin!");
					
					}

					case 2: 
					{
						ShowModelSelectionMenu(playerid, varskin, "Pick Your Skin!");
						
					}

					case 3:
					{
						ShowModelSelectionMenu(playerid, lsvskin, "Pick Your Skin!");

					}
					
				}

			}	
		}

		case DIALOG_COP_CHASE:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
						SetPlayerColor(playerid, color_criminal);
						SetPlayerPos(playerid, -1490.0017,835.0854,7.1875);
						SetPlayerTeam(playerid, 11);
						SendClientMessage(playerid, color_blue, "[Info]{FFFFFF}: Your goal is to kill all the cops before the timer ends.");
						INCOP [playerid] = 1;
						COPCRIM [playerid] = 1;
						INL [playerid] = 0;
		
					} 
					case 1:
					{
						ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "Cop Chase: SAPD Duty", "SAPD Volunteer\nSAPD Officer", "Select", "Cancel");
					
					}
					case 2: 
					{
						ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Cop Chase: FBI Duty", "FBI Agent\nHRT Duty", "Select", "Cancel");
						
					}
					
				}

			}	
		}
		
		case DIALOG_COP_CHASE_SAPD:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
						SetPlayerColor(playerid, COLOR_VOL);
						SetPlayerSkin(playerid, 71);
						SetPlayerTeam(playerid, 10);
						SetPlayerPos(playerid, -1576.8077,678.3936,7.1875);
						TextDrawShowForPlayer(playerid, Textdraw0);
						TextDrawShowForPlayer(playerid, Textdraw1);
						TextDrawShowForPlayer(playerid, Textdraw2);
						TextDrawShowForPlayer(playerid, Textdraw3);
						TextDrawShowForPlayer(playerid, Textdraw4);
						TextDrawShowForPlayer(playerid, ccc_Textdraw5);
						TextDrawShowForPlayer(playerid, ccc_Textdraw6);
						TextDrawShowForPlayer(playerid, ccc_Textdraw7);
						TextDrawShowForPlayer(playerid, ccc_Textdraw8);
						SetTimerEx("RemoveInfoTD", 6000, false, "i", playerid);
						PlayerPlaySound(playerid,1150,0.0,0.0,0.0);
						COPLEO [playerid] = 1;
						COPVOL [playerid] = 1;
						INCOP [playerid] = 1;
						INDM [playerid] = 1;
						INL [playerid] = 0;
					}
					case 1:
					{
//						if(PlayerInfo[playerid][pScore] < 30)
//							{
//								return SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: You must be level 30 to use this");
//							}
						ShowModelSelectionMenu(playerid, policeskin, "SAPD Duty"); 

					}
					
				}

			}	
		}

		case DIALOG_COP_CHASE_FBI:
		{
			if (response)
			{
				switch(listitem)
				{
					case 0:
					{
//						if(PlayerInfo[playerid][pScore] < 50)
//							{
//								return SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: You must be level 50 to use this");
//							}
						ShowModelSelectionMenu(playerid, fbiskin, "FBI Duty"); 
					}
					case 1:
					{
	//					if(PlayerInfo[playerid][pScore] < 75)
	//						{
	//							return SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: You must be level 75 to use this");
	//						}
						SetPlayerColor(playerid, color_blue);
						SetPlayerSkin(playerid, 287);
						SetPlayerTeam(playerid, 10);
						SetPlayerPos(playerid, -1638.1818,656.6777,7.1875);
						SetPlayerAttachedObject(playerid, 8, 19777, 1, 0.1678, -0.1677, 0.0000, 93.0998, 10.8999, -86.6997, 0.6610, 0.5730, 0.6980, 0xFFFFFFFF, 0xFFFFFFFF); // FBILogo attached to the Army Skin
				        SetPlayerAttachedObject(playerid, 9, 19777, 1, 0.0348, 0.2160, 0.0000, -91.9000, 18.6000, -91.8000, 0.7929, 0.7059, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF); // FBILogo attached to the Army Skin
					
						TextDrawShowForPlayer(playerid, Textdraw0);
						TextDrawShowForPlayer(playerid, Textdraw1);
						TextDrawShowForPlayer(playerid, Textdraw2);
						TextDrawShowForPlayer(playerid, Textdraw3);
						TextDrawShowForPlayer(playerid, Textdraw4);
						TextDrawShowForPlayer(playerid, ccc_Textdraw5);
						TextDrawShowForPlayer(playerid, ccc_Textdraw6);
						TextDrawShowForPlayer(playerid, ccc_Textdraw7);
						TextDrawShowForPlayer(playerid, ccc_Textdraw8);

						SetTimerEx("RemoveMainTD", 8000, false, "i", playerid);
						PlayerPlaySound(playerid,1150,0.0,0.0,0.0);	
						COPLEO [playerid] = 1;
						COPHRT [playerid] = 1;
						INCOP [playerid] = 1;
						INL [playerid] = 0;

					}
					
				}

			}	
		}

		case DIALOG_DUEL:
		{
		    if (response){
					UsingArena = true;
					new name[MAX_PLAYER_NAME], string[500];
					GetPlayerName(playerid, name, sizeof(name));
					format(string, sizeof(string), "[Duel]{FFFFFF}: %s accepted the duel, starting in 3 seconds.",name);
					SendClientMessage(IdDuel[playerid],0xF6F600AA,string);
					SendClientMessage(playerid,0xF6F600AA,"[Duel]{FFFFFF}: You accepted the duel. Starting in 3 seconds.");
					SetTimerEx("GoDuel",3000,false,"ii",playerid,IdDuel[playerid]);

				}
				else
				{
					ExpireDuel(playerid,IdDuel[playerid]);
		    }
		}	
		case DIALOG_GROUP_INVITE:
		{
	    new str[128];
	    if(!response)
	    {
	        format(str,sizeof(str),"%s has declined your invite.",ReturnName(playerid));
//	        SendClientMessage(groupvariables[playerid][0],color_red,str);
			SendClientMessage(playerid,color_red," You have declined the invite.");
//			groupvariables[playerid][0] = -1;
//			groupvariables[playerid][1] = 0;
	    }
	    if(response)
	    {
	        format(str,sizeof(str),"%s has accepted your invite.",ReturnName(playerid));
//	        SendClientMessage(groupvariables[playerid][0],color_wt,str);
//			SendClientMessage(playerid,color_red,"You have accepted the invite.");
//			PlayerInfo[playerid][grouppid] = PlayerInfo[groupvariables[playerid][0]][grouppid];
//			groupvariables[playerid][0] = -1;
//			groupvariables[playerid][1] = 0;
	    }
		}
	}

	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(areaid == turflimit && PLAYERCAP[playerid]){
		SendGwarMessage(color_orange, "[Gang War]{FFFFFF} The Turf Capturer has left the turf and failed to capture it.");
		KillTimer(turftime);
		GangZoneStopFlashForAll(turf);
	    PLAYERCAP [playerid] = 0;
     	caping = 0;
        gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
		return 1;
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == joinskin)
	{
	    if(!response)
		    return ShowModelSelectionMenu(playerid, joinskin, "Pick A Skin");

        SetCameraBehindPlayer(playerid);
        SetPlayerSkin(playerid, modelid);
		PlayerInfo[playerid][pSkin] = modelid;
        new locVector = random(8);
        SetSpawnInfo(playerid, 0, modelid, locations[locVector][x], locations[locVector][y], locations[locVector][Z],182.5525,24,100000,0,0,0,0 );
        SpawnPlayer(playerid);
		SetPlayerTeam(playerid, 1);
		ResetStatus(playerid);
		publicoff[playerid] = false; // just in case
		// show stats td

//		PlayerTextDrawShow(playerid, StatsSkinTD[playerid]);
		PlayerTextDrawShow(playerid, StatsNameTD[playerid]);
//		PlayerTextDrawShow(playerid, StatsScoreTD[playerid]);
		PlayerTextDrawShow(playerid, StatsKDTD[playerid]);
		PlayerTextDrawShow(playerid, StatsModeTD[playerid]);

		//end of shot td
		if(ServerIsAnnoucing == 1){
			TextDrawShowForPlayer(playerid, annoucegreen);
			TextDrawShowForPlayer(playerid, annoucetext);
			return 1;
		}

		INL [playerid] = 1;
		SetPlayerColor(playerid, color_white);
	    if(capedbygsf == 1){
		GangZoneShowForPlayer(playerid, turf, COLOR_GROVE);
		return 1;
	    }
	    if(capedbylsv == 1){
		GangZoneShowForPlayer(playerid, turf, COLOR_VAGOS);
		return 1;
	    }
	    if(capedbyvar == 1){
		GangZoneShowForPlayer(playerid, turf, COLOR_AZCETAS);
		return 1;
	    }
	    if(capedbynba == 1){
		GangZoneShowForPlayer(playerid, turf, COLOR_BALLAS);
		return 1;
	    }
		if(caped == 0){
		GangZoneShowForPlayer(playerid, turf, color_white);
		return 1;
		}
	
	}

	if(listid == policeskin){
		if(!response)
		    return ShowModelSelectionMenu(playerid, policeskin, "SAPD Duty");
		SetPlayerColor(playerid, color_blue);
		SetPlayerSkin(playerid, modelid);
		SetPlayerTeam(playerid, 10);
 		SetPlayerPos(playerid, -1576.8077,678.3936,7.1875);

		TextDrawShowForPlayer(playerid, Textdraw0);
		TextDrawShowForPlayer(playerid, Textdraw1);
		TextDrawShowForPlayer(playerid, Textdraw2);
		TextDrawShowForPlayer(playerid, Textdraw3);
		TextDrawShowForPlayer(playerid, Textdraw4);
		TextDrawShowForPlayer(playerid, ccc_Textdraw5);
		TextDrawShowForPlayer(playerid, ccc_Textdraw6);
		TextDrawShowForPlayer(playerid, ccc_Textdraw7);
		TextDrawShowForPlayer(playerid, ccc_Textdraw8);
		SetTimerEx("RemoveMainTD", 8000, false, "i", playerid);
		PlayerPlaySound(playerid,1150,0.0,0.0,0.0);

		COPPOLICE [playerid] = 1;
		COPLEO [playerid] = 1;
		INCOP [playerid] = 1;
        INL [playerid] = 0;
	}

	if(listid == fbiskin){
		if(!response)
			return ShowModelSelectionMenu(playerid, fbiskin, "FBI Duty");
		SetPlayerColor(playerid, color_blue);
		SetPlayerSkin(playerid, modelid);
		SetPlayerTeam(playerid, 10);
		SetPlayerPos(playerid, -1578.0310,655.3882,7.1875);

		TextDrawShowForPlayer(playerid, Textdraw0);
		TextDrawShowForPlayer(playerid, Textdraw1);
		TextDrawShowForPlayer(playerid, Textdraw2);
		TextDrawShowForPlayer(playerid, Textdraw3);
		TextDrawShowForPlayer(playerid, Textdraw4);
		TextDrawShowForPlayer(playerid, ccc_Textdraw5);
		TextDrawShowForPlayer(playerid, ccc_Textdraw6);
		TextDrawShowForPlayer(playerid, ccc_Textdraw7);
		TextDrawShowForPlayer(playerid, ccc_Textdraw8);
		SetTimerEx("RemoveMainTD", 8000, false, "i", playerid);
		PlayerPlaySound(playerid,1150,0.0,0.0,0.0);

		COPFBI [playerid] = 1;
		COPLEO [playerid] = 1;
		INCOP [playerid] = 1;
        INL [playerid] = 0;

	}

	if(listid == gsfskin){
		if(!response)
		    return ShowModelSelectionMenu(playerid, gsfskin, "Pick A Skin");
		SetPlayerColor(playerid, COLOR_GROVE);
		SetPlayerSkin(playerid, modelid);
		new message[230];
		format(message, sizeof(message), "[Gang War] {FFFFFF}%s has joined Gang War mode [Grove Street]", ReturnName(playerid));
		SendGwarMessage(color_orange, message);
		new name_string[128];
        new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof(name));
        format(name_string, sizeof(name_string), "[GSF]%s", name);
		SetPlayerName(playerid, name_string);
		PlayerInfo[playerid][gSkin] = modelid;
		new g_loc = random(3);
        SetPlayerPos(playerid, GsfLocations[g_loc][0], GsfLocations[g_loc][1], GsfLocations[g_loc][2]);
        cmd_gangwarweapontable(playerid, "");
		SetPlayerTeam(playerid, 1);
        
		GSF [playerid] = 1;
		INGWR [playerid] = 1;
		INL [playerid] = 0;
	    INDM [playerid] = 1;
	    WDM [playerid] = 0;
	    LVPD [playerid] = 0;
	    INRCDM [playerid] = 0;
	    SDM [playerid] = 0;
	    PDM [playerid] = 0;
	    GDM [playerid] = 0;
	}

	if(listid == nbaskin){
	    if(!response)
		    return ShowModelSelectionMenu(playerid, nbaskin, "Pick A Skin");
		SetPlayerColor(playerid, COLOR_BALLAS);
		new message[230];
		format(message, sizeof(message), "[Gang War] {FFFFFF}%s has joined Gang War mode [Kilo Tray Ballas]", ReturnName(playerid));
		SendGwarMessage(color_orange, message);
		new name_string[128];
        new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof(name));
        format(name_string, sizeof(name_string), "[KTB]%s", name);
		SetPlayerName(playerid, name_string);
		SetPlayerSkin(playerid, modelid);
		PlayerInfo[playerid][nSkin] = modelid;
		new n_loc = random(3);
        SetPlayerPos(playerid, NbaLocations[n_loc][0], NbaLocations[n_loc][1], NbaLocations[n_loc][2]);
        cmd_gangwarweapontable(playerid, "");
		SetPlayerTeam(playerid, 2);
        NBA [playerid] = 1;
        INGWR [playerid] = 1;
		INL [playerid] = 0;
	    INDM [playerid] = 1;
	    WDM [playerid] = 0;
	    LVPD [playerid] = 0;
	    INRCDM [playerid] = 0;
	    SDM [playerid] = 0;
	    PDM [playerid] = 0;
	    GDM [playerid] = 0;
	}

	if(listid == varskin){
		if(!response)
		    return ShowModelSelectionMenu(playerid, varskin, "Pick A Skin");
		SetPlayerColor(playerid, COLOR_AZCETAS);
	    SetPlayerSkin(playerid, modelid);
		new message[230];
		format(message, sizeof(message), "[Gang War] {FFFFFF}%s has joined Gang War mode [Los Varios Aztecas]", ReturnName(playerid));
		SendGwarMessage(color_orange, message);
		new name_string[128];
        new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof(name));
        format(name_string, sizeof(name_string), "[VAR]%s", name);
		SetPlayerName(playerid, name_string);
		PlayerInfo[playerid][vSkin] = modelid;
		new v_loc = random(3);
		SetPlayerPos(playerid, VarLocations[v_loc][0], VarLocations[v_loc][1], VarLocations[v_loc][2]);
		cmd_gangwarweapontable(playerid, "");
		SetPlayerTeam(playerid, 3);
		VAR [playerid] = 1;
		INGWR [playerid] = 1;
		INL [playerid] = 0;
	    INDM [playerid] = 1;
	    WDM [playerid] = 0;
	    LVPD [playerid] = 0;
	    INRCDM [playerid] = 0;
	    SDM [playerid] = 0;
	    PDM [playerid] = 0;
	    GDM [playerid] = 0;

	}

	if(listid == lsvskin){
		if(!response)
		    return ShowModelSelectionMenu(playerid, lsvskin, "Pick A Skin");
		SetPlayerColor(playerid, COLOR_VAGOS);
		SetPlayerSkin(playerid, modelid);
		new message[230];
		format(message, sizeof(message), "[Gang War] {FFFFFF}%s has joined Gang War mode [Los Santos Vagos]", ReturnName(playerid));
		SendGwarMessage(color_orange, message);
		new name_string[128];
        new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof(name));
        format(name_string, sizeof(name_string), "[LSV]%s", name);
		SetPlayerName(playerid, name_string);
		PlayerInfo[playerid][lSkin] = modelid;
		new l_loc = random(2);
		SetPlayerPos(playerid, LsvLocations[l_loc][0], LsvLocations[l_loc][1], LsvLocations[l_loc][2]);
		cmd_gangwarweapontable(playerid, "");
		SetPlayerTeam(playerid, 4);
		LSV [playerid] = 1;
		INGWR [playerid] = 1;
		INL [playerid] = 0;
	    INDM [playerid] = 1;
	    WDM [playerid] = 0;
	    LVPD [playerid] = 0;
	    INRCDM [playerid] = 0;
	    SDM [playerid] = 0;
	    PDM [playerid] = 0;
	    GDM [playerid] = 0;

	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}


forward ClearChatbox(playerid, lines);
public ClearChatbox(playerid, lines)
{
	if (IsPlayerConnected(playerid))
	{
		for(new i=0; i<lines; i++)
		{
			SendClientMessage(playerid, color_banned, " ");
		}
	}
	return 1;
}

forward UpdateStatsTD(playerid);
public UpdateStatsTD(playerid)
{
//		new string[255];
//		format(string, sizeof(string), "~b~~h~Score:~w~ %s~n~~b~~h~Kills:~w~ %s~n~~b~~h~Deaths:~w~ %s~n~~b~~h~Mode:~w~ %s", 
//		PlayerInfo[playerid][pScore],PlayerInfo[playerid][pKills],PlayerInfo[playerid][pDeaths],GetPlayerMode(playerid));
		//PlayerTextDrawSetString(playerid,StatsTD2, string);

		//TD Name:
		new stringName[255];
		format(stringName, sizeof(stringName), "%s",PlayerInfo[playerid][pAccName]);
		PlayerTextDrawSetString(playerid,StatsNameTD[playerid], stringName);
/*
		//TD Score:
		new stringScore[255];
		format(stringScore, sizeof(stringScore), "~b~Score: ~w~%s",PlayerInfo[playerid][pScore]);
		PlayerTextDrawSetString(playerid,StatsScoreTD[playerid], stringScore);
*/

		//TD K/D:
		new stringKD[255];              
		format(stringKD, sizeof(stringKD), "~r~K:D ~w~%s/%s",PlayerInfo[playerid][pKills],PlayerInfo[playerid][pDeaths]);
		PlayerTextDrawSetString(playerid,StatsKDTD[playerid], stringKD);

		//TD Mode:
		new stringMode[255];
		format(stringMode, sizeof(stringMode), "~p~Mode: ~w~%s",GetPlayerMode(playerid));
		PlayerTextDrawSetString(playerid,StatsModeTD[playerid], stringMode);


		return 1;
}

/*
forward MYSQL_SaveGroups(b);
public MYSQL_SaveGroups(b)
{
	new query[128];
	mysql_format(ourConnection,query, sizeof(query), "UPDATE `groups` SET `gchat` = %d, `gTAG` = %d,`gName` = '%e', `gOwnerName` = '%e' WHERE `gID` = %d",
	GroupInfo[b][gchat],GroupInfo[b][gTAG],GroupInfo[b][gName],GroupInfo[b][gOwnerName],GroupInfo[b][gID]);
	mysql_tquery(ourConnection, query, "", "");
	return 1;
}*/

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, weaponid, bodypart)
{
	if(damaged_actorid == Actordm)
	{
		new string1[225];
		new string2[225];
		new string3[225];
		new string4[225];
		new string5[350];
		new string6[350];

	    new string[225]; string =  "{FFFFFF}Arena\t{FFFFFF}Current Players\n";//1
        format(string1, sizeof(string1), "%s{FFFFFF}{3DF6F4}LVPD\t{29953d}%i/10\n", string, GetLvpdPlayers());//2
        format(string2, sizeof(string2), "%s{FFFFFF}{3DF6F4}WareHouse Deathmatch\t{29953d}%i/10\n", string1, GetWarehousePlayers());//3
        format(string3, sizeof(string3), "%s{FFFFFF}{3DF6F4}RC Grounds\t{29953d}%i/10\n", string2, GetRcgPlayers());//4
        format(string4, sizeof(string4), "%s{FFFFFF}{3DF6F4}Pleasure Domes\t{29953d}%i/10\n", string3, GetPleasurePlayers());//5
		format(string5, sizeof(string5), "%s{FFFFFF}{3DF6F4}Sniper Deathmatch\t{29953d}%i/10\n", string4, GetSniperPlayers());//6
		format(string6, sizeof(string6), "%s{FFFFFF}{3DF6F4}Ghost Town\t{29953d}%i/10\n", string5, GetGhostPlayers());//7
        ShowPlayerDialog(playerid, 2, DIALOG_STYLE_TABLIST_HEADERS, "{EE28EB}[F:DM] {FFFFFF}Arena List", string6, "Select", "Cancel");
//		ShowPlayerDialog(playerid, 2, DIALOG_STYLE_TABLIST, "{EE28EB}[F:DM] {FFFFFF}Arena List", "{3DF6F4}LVPD\n{3DF6F4}WareHouse DM\n{3DF6F4}RC Grounds\n{3DF6F4}Pleasure Domes\n{3DF6F4}Sniper DM\n{3DF6F4}Ghost town", "Select", "Close");
    }
    if(damaged_actorid == Actorgwr)
    {
         return cmd_gwar(playerid, "");
    }
    if(damaged_actorid == Actorcopchase)
    {
		SendClientMessage(playerid,color_blue,"[In Progress]{FFFFFF}: While testing Cop Chase, we have encountered many bugs.");
		SendClientMessage(playerid,color_blue,"[In Progress]{FFFFFF}: Our devs are trying their hardest to get it fixed.");
///		SetTimerEx("UnfreezeTimer", 3000, false, "i", playerid);
///		TogglePlayerControllable(playerid, 0);
///		SetPlayerPos(playerid, 1565.2571,-1685.1045,62.1910);
///		SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: Welcome to Cop Chase! (use /lobby to go back)");
///		SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: Walk over the Cop icon to get started."); // I think Players prefer LS 
    }
	if(damaged_actorid == Actorvs)
	{
		SendClientMessage(playerid,color_pink,"[Under Development]{FFFFFF}: Our Dev Team is working on the ''Versus'' Mode.");
		SendClientMessage(playerid,color_pink,"[Under Development]{FFFFFF}: they are trying their hardest to get finished.");		
	}
	return 1;
}

forward HITTD(issuerid);
public HITTD(issuerid)
{
    TextDrawHideForPlayer(issuerid, HitMarker);
    KillTimer(hittimer);
    return 1;
}

forward TurfTime(playerid);
public TurfTime(playerid)
{
	if(gsfcaping == 1){
		GangZoneStopFlashForPlayer(playerid, turf);
		GangZoneShowForAll(turf, color_green);
		SendGwarMessage(COLOR_GROVE, "[Gang War]{FFFFFF}: Turf has been captured by Grove Street Team.");
		SendClientMessage(playerid, color_purple, "[Info]{FFFFFF}: You successfully captured the turf. You gained a level.");

		new ownerstring[80];
    	format(ownerstring, sizeof(ownerstring), "~b~Owner: ~w~Grove Street");
    	TextDrawSetString(sprunkown, ownerstring);

		new namestring[80];
    	format(namestring, sizeof(namestring), "~g~Grove's Sprunk ~w~-~y~ GSF");
    	TextDrawSetString(sprunknme, namestring);

		if(GSF[playerid]){
		SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
		capedbygsf = 1;
		capedbyvar = 0;
		capedbylsv = 0;
		capedbynba = 0;
		PLAYERCAP [playerid] = 0;
		caping = 0;
		gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
		caped = 1;
		}	
	}

	if(nbacaping == 1){
		GangZoneStopFlashForPlayer(playerid, turf);
		GangZoneShowForAll(turf, color_purple);
		SendGwarMessage(COLOR_BALLAS, "[Gang War]{FFFFFF}: Turf has been captured by Kilo Tray Ballas.");
		SendClientMessage(playerid, color_purple, "[Info]{FFFFFF}: You successfully captured the turf. You gained a level.");

		new ownerstring[80];
    	format(ownerstring, sizeof(ownerstring), "~b~Owner: ~w~KT Ballas");
    	TextDrawSetString(sprunkown, ownerstring);

		new namestring[80];
    	format(namestring, sizeof(namestring), "~p~Ballas' Sprunk ~w~-~r~ We finna own this");
    	TextDrawSetString(sprunknme, namestring);

		if(NBA[playerid]){
		SetPlayerScore(playerid, PlayerInfo[playerid][pScore] + 1);
		capedbygsf = 0;
		capedbyvar = 0;
		capedbylsv = 0;
		capedbynba = 1;
		PLAYERCAP [playerid] = 0;
		caping = 0;
		gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
		caped = 1;
		}			
	}
	if(varcaping == 1){
		GangZoneStopFlashForPlayer(playerid, turf);
		GangZoneShowForAll(turf, color_cyan);
		SendGwarMessage(COLOR_AZCETAS, "[Gang War]{FFFFFF}: Turf has been captured by Los Varrios Azcetas.");
		SendClientMessage(playerid, color_purple, "[Info]{FFFFFF}: You successfully captured the turf. You gained a level.");

		new ownerstring[80];
    	format(ownerstring, sizeof(ownerstring), "~b~Owner: ~w~Las Aztecas");
    	TextDrawSetString(sprunkown, ownerstring);

		new namestring[80];
    	format(namestring, sizeof(namestring), "~b~Los Sprunks ~w~- Good Tasting Sprunk");
    	TextDrawSetString(sprunknme, namestring);

		if(VAR[playerid]){
		SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
		PLAYERCAP [playerid] = 0;
		caping = 0;
		gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
		caped = 1;
		}			
	}
	if(lsvcaping == 1){
		GangZoneStopFlashForPlayer(playerid, turf);
		GangZoneShowForAll(turf, color_yellow);
		SendGwarMessage(COLOR_VAGOS, "[Gang War]{FFFFFF}: Turf has been captured by Los Santos Vagos.");
		SendClientMessage(playerid, color_purple, "[Info]{FFFFFF}: You successfully captured the turf. You gained a level.");

		new ownerstring[80];
    	format(ownerstring, sizeof(ownerstring), "~b~Owner: ~w~Los Vagos");
    	TextDrawSetString(sprunkown, ownerstring);

		new namestring[80];
    	format(namestring, sizeof(namestring), "~y~El Sprunk ~w~- LSV Owned");
    	TextDrawSetString(sprunknme, namestring);

		if(LSV[playerid]){
		SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
		capedbygsf = 0;
		capedbyvar = 0;
		capedbylsv = 1;
		capedbynba = 0;
		PLAYERCAP [playerid] = 0;
		caping = 0;
		gsfcaping = 0;
        nbacaping = 0;
        lsvcaping = 0;
        varcaping = 0;
		caped = 1;

		}			
	}
    return 1;
}


//-------------------- Commands------------------------------//

//modular
#include "./modu/admin-cmds.pwn"
#include "./modu/discord.pwn"
#include "./modu/anims.pwn"
//#include "./modu/groups/cmds.pwn"
//#include "./modu/groups/functions.pwn"
//------------------------------GANG WAR MODE -------------------------------------------////
CMD:capture(playerid, params[])
{
	if(!IsPlayerInDynamicArea(playerid, turflimit, 0)){
		SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: You have to be in the zone in order to capture it");
		return 1;
	}

	if(caping == 1){
		SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: This turf is already being Captured");
		return 1;
	}

    if(GSF[playerid] && IsPlayerInDynamicArea(playerid, turflimit, 0))
	{
		if(capedbygsf == 1){
			SendClientMessage(playerid, color_red, "[Error]{FFFFFF} This Turf is already Captured by your Team.");
			return 1;
		}

		new string[128];
		new name[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, name, sizeof(name));
		GangZoneFlashForAll(turf, color_green);
		format(string, sizeof(string), "[Gang Wars]{FFFFFF}: GS9 is being captured by {2B8A11}%s for Grove Street",name);
	    SendGwarMessage(COLOR_GROVE, string);
		turftime = SetTimerEx("TurfTime", 120000, false, "i", playerid);
		PLAYERCAP [playerid] = 1;
		caping = 1;
		gsfcaping = 1;
		return 1;
	}
	
	if(LSV[playerid] && IsPlayerInDynamicArea(playerid, turflimit, 0))
	{
        if(capedbylsv == 1){
			SendClientMessage(playerid, color_red, "[Error]{FFFFFF} This Turf is already Captured by your Team.");
			return 1;
		}
		new string[128];
		new name[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, name, sizeof(name));
		GangZoneFlashForAll(turf, color_yellow);
		format(string, sizeof(string), "[Gang Wars]{FFFFFF}: GS9 is being captured by {F7D60A}%s for Los Santos Vagos",name);
	    SendGwarMessage(COLOR_VAGOS, string);
		turftime = SetTimerEx("TurfTime", 120000, false, "i", playerid);
		PLAYERCAP [playerid] = 1;
		caping = 1;
		lsvcaping = 1;
		return 1;
	}

	if(NBA[playerid] && IsPlayerInDynamicArea(playerid, turflimit, 0))
	{
        if(capedbynba == 1){
			SendClientMessage(playerid, color_red, "[Error]{FFFFFF} This Turf is already Captured by your Team.");
			return 1;
		}
		new string[128];
		new name[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, name, sizeof(name));
		GangZoneFlashForAll(turf, COLOR_BALLAS);
		format(string, sizeof(string), "[Gang Wars]{FFFFFF}: GS9 is being captured by {e803fc}%s for Kilo Tray Ballas",name);
	    SendGwarMessage(COLOR_BALLAS, string);
		turftime = SetTimerEx("TurfTime", 120000, false, "i", playerid);
		PLAYERCAP [playerid] = 1;
		caping = 1;
		nbacaping = 1;
		return 1;
	}
	if(VAR[playerid] && IsPlayerInDynamicArea(playerid, turflimit, 0))
	{
        if(capedbyvar == 1){
			SendClientMessage(playerid, color_red, "[Error]{FFFFFF} This Turf is already Captured by your Team.");
			return 1;
		}

		new string[128];
		new name[MAX_PLAYER_NAME];
    	GetPlayerName(playerid, name, sizeof(name));
		GangZoneFlashForAll(turf, color_cyan);
		format(string, sizeof(string), "[Gang Wars]{FFFFFF}: GS9 is being captured by {0bc3d4}%s for Los Varrios Azcetas",name);
	    SendGwarMessage(COLOR_AZCETAS, string);
		turftime = SetTimerEx("TurfTime", 120000, false, "i", playerid);
		PLAYERCAP [playerid] = 1;
		caping = 1;
		varcaping = 1;
		return 1;
	}

	return 1;
}

CMD:gwar(playerid, params[])
{
	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby)");
	return 1;
	}
	
	ShowPlayerDialog(playerid, 3, DIALOG_STYLE_LIST, "{EE28EB}[F:DM] {FFFFFF}Gang Wars", "{37EE28}Grove Street Families\n{EE28EE}Kilo Tray Ballas\n{28EEED}Los Varrios Azcetas\n{DDEE28}Los Santos Vagos", "Select", "Cancel");	
	return 1;
}
//=====================Lobby==================================//

CMD:lobby(playerid, params[])
{
	if(PlayerInfo[playerid][pLoggedin] == false)
	{
		SendClientMessage(playerid, color_red, "[Retart Alert!]{FFFFFF}: What the fuck are you trying to do? Log in first.");
		return 0;
	}
    
	if(PLAYERCAP[playerid]){
		SendClientMessage(playerid, color_red, "[Error]{FFFFFF}:You Can't use This Command while you're capturing.");
		return 1;
	}

	new playerState = GetPlayerState(playerid);
	if(playerState == PLAYER_STATE_WASTED && IdDuel[playerid] != 0)
	{
	SendClientMessage(playerid, color_purple, "[Error] {FFFFFF}Can't use this command while you are dead");
	return 1;
    } 

    SetPlayerName(playerid, PlayerInfo[playerid][pAccName]);

	new rand = random(9);

	switch(rand)
	{
		case 0:
		{
		SetPlayerPos(playerid, 376.1006,2469.7708,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 1:
	    {
		SetPlayerPos(playerid, 370.5598,2469.9504,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 2:
	    {
		SetPlayerPos(playerid, 365.4152,2470.1277,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 3:
	    {
		SetPlayerPos(playerid, 365.7121,2475.5298,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 4:
	    {
		SetPlayerPos(playerid, 370.2319,2475.3789,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 5:
	    {
		SetPlayerPos(playerid, 375.3858,2474.9541,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 6:
	    {
		SetPlayerPos(playerid, 372.9134,2467.5376,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 7:
	    {
		SetPlayerPos(playerid, 368.3280,2462.5168,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white);
	    }
	    case 8:
	    {
		SetPlayerPos(playerid, 376.0320,2461.6362,16.5846);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 10000);
		SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		SetPlayerColor(playerid, color_white); 
	    }
	    
	}

	INL [playerid] = 1;
    GSF [playerid] = 0;
    NBA [playerid] = 0;
    LSV [playerid] = 0;
    INGWR [playerid] = 0;
    VAR [playerid] = 0;
    LVPD [playerid] = 0;
    WDM [playerid] = 0;
    INDM [playerid] = 0;
    INRCDM [playerid] = 0;
    PDM [playerid] = 0;
    SDM [playerid] = 0;
    GDM [playerid] = 0;
	COPPOLICE [playerid] = 0;
	COPLEO [playerid] = 0;
	COPFBI [playerid] = 0;
	COPHRT [playerid] = 0;
	COPCRIM [playerid] = 0;
	INCOP [playerid] = 0;
	COPVOL [playerid] = 0;
	IdDuel [playerid] = false;
	InvitedDuel [playerid] = false;

	


	
	SetPlayerTeam(playerid, 1);
    RemovePlayerAttachedObject(playerid, 8);
    RemovePlayerAttachedObject(playerid, 9);
	SetPlayerInterior(playerid, 0);
	SendClientMessage(playerid, color_pink, "[Lobby]{FFFFFF}: You have been sent to the lobby.");
	return 1;
}
//===============================LVPD============================================================================================//
CMD:lvpd(playerid, params[])
{

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby)");
	return 1;
	}

	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "[Error] {FFFFFF}Can't use this command while you are dead");
	return 1;
    }


    new d_loc = random(5);
    SetPlayerPos(playerid, LvpdLocations[d_loc][0], LvpdLocations[d_loc][1], LvpdLocations[d_loc][2]);
	SetPlayerInterior(playerid, 3);
	GivePlayerWeapon(playerid, 24, 1000);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	SetPlayerTeam(playerid, NO_TEAM); 
	
	SendClientMessage(playerid, color_purple, "Welcome to LVPD DM, to go back use {FFFFFF}(/lobby)");

	LVPD [playerid] = 1;
	INDM [playerid] = 1;
	WDM [playerid] = 0;
	INRCDM [playerid] = 0;
	SDM [playerid] = 0;
    PDM [playerid] = 0;
    GDM [playerid] = 0;
	INL [playerid] = 0;

    return 1;
}

//=========================[WARE HOUSE DM]===================================================//
//=========================[WARE HOUSE DM]===================================================//

CMD:wdm(playerid, params[])
{

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby)");
	return 1;
	}
    

	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

    new w_loc = random(4);
    SetPlayerPos(playerid, WdmLocations[w_loc][0], WdmLocations[w_loc][1], WdmLocations[w_loc][2]);
    SetPlayerInterior(playerid, 1);
   	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
   	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 1000);
	GivePlayerWeapon(playerid, 25, 100000);
	SetPlayerTeam(playerid, NO_TEAM); 
    

	SendClientMessage(playerid, color_purple, "Welcome to Warehouse DM, to go back use {FFFFFF}(/lobby)");
	WDM [playerid] = 1;
	GDM [playerid] = 0;
    INDM [playerid] = 1;
	LVPD [playerid] = 0;
	INRCDM [playerid] = 0;
	INL [playerid] = 0;
    return 1;
}

//=========================[RC GROUNDS DM]===================================================//
//=========================[RC GROUNDS DM]===================================================//

CMD:rcdm(playerid, params[])
{
	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby)");
	return 1;
	}

	new r_loc = random(6);
    SetPlayerPos(playerid, RandomLocations[r_loc][0], RandomLocations[r_loc][1], RandomLocations[r_loc][2]);
	SetPlayerInterior(playerid, 10);
	ResetPlayerWeapons(playerid);
	SetPlayerArmour(playerid, 100);
	SetPlayerHealth(playerid, 100);
	GivePlayerWeapon(playerid, 24, 999);
	GivePlayerWeapon(playerid, 27, 999);
	GivePlayerWeapon(playerid, 34, 999);
	GivePlayerWeapon(playerid, 31, 999);
	SendClientMessage(playerid, color_purple, "Welcome to RC Grounds, to go back use {FFFFFF}(/lobby)");
	SetPlayerTeam(playerid, NO_TEAM); 

	INRCDM [playerid] = 1;
	INDM [playerid] = 1;
	GDM [playerid] = 0;
	WDM [playerid] = 0;
	LVPD [playerid] = 0;
	PDM [playerid] = 0;
	SDM [playerid] = 0;
	INL [playerid] = 0;
	return 1;
}

//=========================[Pleasure DM]===================================================//
//=========================[Pleasure DM]===================================================//

CMD:pdm(playerid, params[])
{
	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby)");
	return 1;
	}

    new p_loc = random(5);
    SetPlayerPos(playerid, PdmLocations[p_loc][0], PdmLocations[p_loc][1], PdmLocations[p_loc][2]);
	SetPlayerInterior(playerid, 3);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 30, 10000);
	GivePlayerWeapon(playerid, 24, 999);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	SendClientMessage(playerid, color_purple, "Welcome to Pleasure Domes DM, to go back use {FFFFFF}(/lobby)");
	SetPlayerTeam(playerid, NO_TEAM); 

    SDM [playerid] = 0;
	PDM [playerid] = 1;
	INL [playerid] = 0;
	INRCDM [playerid] = 0;
	INDM [playerid] = 1;
	WDM [playerid] = 0;
	LVPD [playerid] = 0;
	GDM [playerid] = 0;
	INL [playerid] = 0;
	return 1;
}
//=========================[ SNIPER DM]===================================================//
//=========================[ SNIPER DM]===================================================//

CMD:sdm(playerid, params[])
{


	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby)");
	return 1;
	}
	
	new s_loc = random(4);
    SetPlayerPos(playerid, SdmLocations[s_loc][0], SdmLocations[s_loc][1], SdmLocations[s_loc][2]);
	SetPlayerInterior(playerid, 15);
	ResetPlayerWeapons(playerid);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 100);
	GivePlayerWeapon(playerid, 34, 999);
	SendClientMessage(playerid, color_purple, "Welcome to Sniper DM, to go back use {FFFFFF}(/lobby)");
    SetPlayerTeam(playerid, NO_TEAM); 
    SDM [playerid] = 1;
	PDM [playerid] = 0;
	INL [playerid] = 0;
	INRCDM [playerid] = 0;
	INDM [playerid] = 1;
	WDM [playerid] = 0;
	GDM [playerid] = 0;
	LVPD [playerid] = 0;
	return 1;
}

//=========================[GHOST TOWN DM]===================================================//
//=========================[GHOST TOWN DM]===================================================//

CMD:gdm(playerid, params[])
{
	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby).");
	return 1;
	}

	new g_loc = random(5);
    SetPlayerPos(playerid, GdmLocations[g_loc][0], GdmLocations[g_loc][1], GdmLocations[g_loc][2]);
    ResetPlayerWeapons(playerid);
    SetPlayerHealth(playerid, 100);
    SetPlayerArmour(playerid, 100);
    GivePlayerWeapon(playerid, 24, 999);
    GivePlayerWeapon(playerid, 33, 999);
    GivePlayerWeapon(playerid, 25, 999);
    SendClientMessage(playerid, color_purple, "Welcome to Ghost Town DM, to go back use {FFFFFF}(/lobby)");
	SetPlayerTeam(playerid, NO_TEAM); 

    SDM [playerid] = 0;
	PDM [playerid] = 0;
	INL [playerid] = 0;
	INRCDM [playerid] = 0;
	INDM [playerid] = 1;
	WDM [playerid] = 0;
	LVPD [playerid] = 0;
	GDM [playerid] = 1;
	return 1;
}

CMD:gangwarweapontable(playerid, params[])
{
	ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, "{FAFAFA}Choose Your Weapons", "Deagle\tShotgun\nDeagle\tAk47\nDeagle\tSniper", "Select", "Cancel");
    return 1;
}

CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid,0);
    return 1;
}

CMD:discord(playerid, params[])
{
	SendClientMessage(playerid, color_lime, "{019CA2}[Discord] {F20E94}Join our discord server: {FFFFFF}https://discord.gg/CgqB6wVmF6");
	return 1;
}

CMD:skin(playerid, params[])
{
	new playerState = GetPlayerState(playerid);
	if (playerState == PLAYER_STATE_WASTED)
	{
	SendClientMessage(playerid, color_purple, "Can't use this Cmd while you are dead");
	return 1;
    }

	if(INDM[playerid]){
	SendClientMessage(playerid, color_purple, "You have to be in lobby to use this command {FFFFFF}(/lobby).");
	return 1;
	}

	ShowModelSelectionMenu(playerid, joinskin, "Pick A Skin");
	return 1;
}


CMD:duel(playerid, params[])
{

    new id;
    new string[128];
	if(INL[playerid] != 1){
		SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: What? Are you trying to send a duel while you're not in the lobby?");
		return 1;
	}
    if(InvitedDuel[playerid] == true) return SendClientMessage(playerid,0xF41917AA,"[Duel]{FFFFFF}: You already offered someone to duel");

    if(UsingArena == true) return SendClientMessage(playerid,0xF41917AA,"[Duel]{FFFFFF}: The dueling area is full");

	if(sscanf(params, "u", id))
	return SendClientMessage(playerid,0xF41917AA,"[Duel]{FFFFFF}: You must enter the ID of the player (/duel [playerid])");

	if(INL[playerid] != 1){
		SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: This player is not in the lobby.");
		return 1;
	}

    if(id == playerid) return SendClientMessage(playerid,0xF41917AA,"[Duel]{FFFFFF}: You can't invite yourself to a duel");

    if(InvitedDuel[id] == true) return SendClientMessage(playerid,0xF41917AA,"[Duel]{FFFFFF}: That player is aready dueling");
	
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
	SendClientMessage(playerid,color_yellow,"[Duel]{FFFFFF}: You invited them to a Duel, wait for that player to respond."); 
    format(string, sizeof(string), "%s is inviting you to a Duel\n Duel offer will expire in 15 seconds.",name);
    ShowPlayerDialog(id,DIALOG_DUEL,DIALOG_STYLE_MSGBOX,"{EE28EB}[F:DM] {FFFFFF}Duel",string,"Accept", "Deny");
    GameTextForPlayer(id,"~r~DUEL!", 2500, 3);
    InvitedDuel[id] = true;
    IdDuel[id] = playerid;
    SetTimerEx("ExpireDuel",30000,false,"ii",id,playerid);
    return 1;
}

CMD:t(playerid, params[])
{
	if(PlayerInfo[playerid][pMute] > 0){
		SendClientMessage(playerid, color_red, "You're Muted.");
		return 0;
	}
	if(!INGWR[playerid]){
		SendClientMessage(playerid, color_red, "You're not in Gang war Mode.");
		return 1;
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /t [text]");
	}
	if(NBA[playerid])	
	{
		new string[128];
		format(string, sizeof(string), "{EE28EE}[Team Radio] {FFFFFF}%s: %s", PlayerInfo[playerid][pAccName], params);
		SendBallasMessage(COLOR_BALLAS, string);
		return 1;
	}
	if(GSF[playerid])	
	{
		new string[128];
		format(string, sizeof(string), "{2B8A11}[Team Radio] {FFFFFF}%s: %s", PlayerInfo[playerid][pAccName], params);
		SendGroveMessage(COLOR_GROVE, string);
		return 1;
	}
	if(LSV[playerid])	
	{
		new string[128];
		format(string, sizeof(string), "{F7D60A}[Team Radio] {FFFFFF}%s: %s", ReturnName(playerid), params);
		SendVagosMessage(COLOR_VAGOS, string);
		return 1;
	}
	if(VAR[playerid])	
	{
		new string[128];
		format(string, sizeof(string), "{0bc3d4}[Team Radio] {FFFFFF}%s: %s", PlayerInfo[playerid][pAccName], params);
		SendVariosMessage(COLOR_VAGOS, string);
		return 1;
	}
	return 1;
}

CMD:r(playerid, params[])
{
	if(PlayerInfo[playerid][pMute] > 0){
		SendClientMessage(playerid, color_red, "You're Muted.");
		return 0;
	}
	if(isnull(params))
	{
	    return SendClientMessage(playerid, color_blue, "[Usage]{FFFFFF}: /r [text]");
	}
	if(!COPLEO[playerid])
    {
        return SendClientMessage(playerid, color_blue, "[Error]{FFFFFF}:You are not a cop");
	}
	if(COPVOL[playerid])
	{
		new string[128];
		format(string, sizeof(string), "{3D59CC}[Radio]{8FA5FF} SAPD Volunteer %s: %s", ReturnName(playerid), params);
		SendLEOMessage(color_blue, string);
		return 1;
	}
	if(COPPOLICE[playerid])
	{
		new string[128];
		format(string, sizeof(string), "{3D59CC}[Radio]{8FA5FF} SAPD Officer %s: %s", ReturnName(playerid), params);
		SendLEOMessage(color_blue, string);
		return 1;
	}
	if(COPFBI[playerid])
	{
		new string[128];
		format(string, sizeof(string), "{3D59CC}[Radio]{8FA5FF} FBI Agent %s: %s", ReturnName(playerid), params);
		SendLEOMessage(color_blue, string);
		return 1;
	}
	if(COPHRT[playerid])
	{
		new string[128];
		format(string, sizeof(string), "{3D59CC}[Radio]{8FA5FF} HRT Agent %s: %s", ReturnName(playerid), params);
		SendLEOMessage(color_blue, string);
		return 1;
	}
	return 1;
}


CMD:mode(playerid, params[])
{
	new string[42];
	format(string, sizeof(string), "%s is in %s",ReturnName(playerid), GetPlayerMode(playerid));
	SendClientMessage(playerid ,color_cyan, string);
	return 1;
}

// BIND COMMANDS

CMD:b(playerid, params[])
{
	if(!COPLEO[playerid])
    {
        return SendClientMessage(playerid, color_blue, "[Error]{FFFFFF}: You are not a cop");
	}
	if(COPLEO[playerid])
	{
		SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: /b(1-3)");
		SendClientMessage(playerid, color_blue, "[Cop Chase]{FFFFFF}: Example: /b2");
		return 1;
	}
	return 1;
}

CMD:b1(playerid, params[])
{
	if(!COPLEO[playerid])
    {
        return SendClientMessage(playerid, color_blue, "[Error]{FFFFFF}: You are not a cop");
	}
	if(COPVOL[playerid] || COPPOLICE[playerid])
	{
		SetPlayerChatBubble(playerid,"o<: This is the POLICE DEPARTMENT - DO NOT MOVE and PUT YOUR HANDS UP!", 0xE65C00FF, 100.0, 8000);
		SendClientMessage(playerid, color_blue, "{E65C00}[Server]{FFFFFF}: The message ''PULL OVER to the SIDE of the ROAD!'' has appeared above your head");
	}
	if(COPFBI[playerid] || COPHRT[playerid])
	{
		SetPlayerChatBubble(playerid, "o<: This is the FBI - PULL OVER to the SIDE of the ROAD!", 0xE65C00FF, 100.0, 8000);
		SendClientMessage(playerid, color_blue, "{E65C00}[Server]{FFFFFF}: The message ''PULL OVER to the SIDE of the ROAD!'' has appeared above your head");
	}
	return 1;
}

CMD:b2(playerid, params[])
{
	if(!COPLEO[playerid])
    {
        return SendClientMessage(playerid, color_blue, "[Error]{FFFFFF}: You are not a cop");
	}
	if(COPVOL[playerid] || COPPOLICE[playerid])
	{
		SetPlayerChatBubble(playerid, "o<: This is the POLICE DEPARTMENT - DO NOT MOVE and PUT YOUR HANDS UP!", 0xE65C00FF, 100.0, 8000);
		SendClientMessage(playerid, color_blue, "{E65C00}[Server]{FFFFFF}: The message ''DO NOT MOVE and PUT YOUR HANDS UP!'' has appeared above your head");
	}
	else if(COPFBI[playerid] || COPHRT[playerid])
	{
		SetPlayerChatBubble(playerid, "o<: This is the FBI - DO NOT MOVE and PUT YOUR HANDS UP!", 0xE65C00FF, 100.0, 8000);
		SendClientMessage(playerid, color_blue, "{E65C00}[Server]{FFFFFF}: The message ''DO NOT MOVE and PUT YOUR HANDS UP!'' has appeared above your head");
	}
	return 1;
}

CMD:b3(playerid, params[])
{
	if(!COPLEO[playerid])
    {
        return SendClientMessage(playerid, color_blue, "[Error]{FFFFFF}: You are not a cop");
	}
	if(COPVOL[playerid] || COPPOLICE[playerid])
	{
		SetPlayerChatBubble(playerid, "o<: This is the POLICE DEPARTMENT - COMPLY or WE WILL USE FORCE!", 0xE65C00FF, 100.0, 8000);
		SendClientMessage(playerid, color_blue, "{E65C00}[Server]{FFFFFF}: The message ''COMPLY or WE WILL USE FORCE!'' has appeared above your head");
	}
	if(COPFBI[playerid] || COPHRT[playerid])
	{
		SetPlayerChatBubble(playerid, "o<: This is the FBI - COMPLY or WE WILL USE FORCE!", 0xE65C00FF, 100.0, 8000);
		SendClientMessage(playerid, color_blue, "{E65C00}[Server]{FFFFFF}: The message ''COMPLY or WE WILL USE FORCE!'' has appeared above your head");
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	new playerb, pmmsg[150], string[150], string1[150];
    if(sscanf(params, "us[150]", playerb, pmmsg))
        return SendClientMessage(playerid, color_cyan, "[Usage]{FFFFFF}: /pm [playerid] [message]");
	if(!IsPlayerConnected(playerb)) return SendClientMessage(playerid, color_red, "This player is not connected.");
	if(togpm[playerid] == 1) return SendClientMessage(playerid, color_error, "You have your PM toggled");
	if(togpm[playerb] == 1) return SendClientMessage(playerid, color_error, "That player has toggled their PMs");
	
	if(PlayerAFK[playerb])
	{
	format(string, sizeof(string), "{dce31b} PM from %s(%d): %s", ReturnName(playerid),playerid, pmmsg);
	format(string1, sizeof(string1), "{dce31b} PM Sent to %s(%d): %s", ReturnName(playerb),playerb, pmmsg);
	SendClientMessage(playerb, color_red, string);
	SendClientMessage(playerid, color_red, string1);
	SendClientMessage(playerid, color_error,"That player is afk, it may take awhile for them to respond.");	
	}
	format(string, sizeof(string), "{dce31b} PM from %s(%d): %s", ReturnName(playerid),playerid, pmmsg);
	format(string1, sizeof(string1), "{dce31b} PM Sent to %s(%d): %s", ReturnName(playerb),playerb, pmmsg);
	SendClientMessage(playerb, color_red, string);
	SendClientMessage(playerid, color_red, string1);
	return 1;
}

CMD:ask(playerid, params[])
{
	if(PlayerInfo[playerid][pMute] > 0){
		SendClientMessage(playerid, color_red, "You're Muted.");
		return 0;
	}

	if(isnull(params))
	{
	    return SendClientMessage(playerid, color_ask, "[Usage]{FFFFFF}: /ask [text]");
	}

	if(PlayerInfo[playerid][pAdmin] > 1)
	{
		new string[128];
		format(string, sizeof(string), "[Ask] %s %s (%d){FFFFFF}: %s", GetAdminRank(playerid),PlayerInfo[playerid][pAccName],playerid, params);
		SendClientMessageToAll(color_ask, string);
		return 1;
	}
	else
	{
		new string[128];
		format(string, sizeof(string), "[Ask] %s (%d){FFFFFF}: %s", PlayerInfo[playerid][pAccName],playerid, params);
		SendClientMessageToAll(color_ask, string);
		return 1;
	}
}

CMD:admins(playerid, params[])
{
	SendClientMessage(playerid, color_lime, "Online Administrators:");
    for(new i; i<MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(PlayerInfo[i][pAdmin] >= 1)
				{			
				new astatus[64];
				if(pAduty[i] == 1)
				{
					astatus = "{FD0000}Administrating";
				}
				else if(pAduty[i] == 0)
				{
					astatus = "{FFFFFF}Playing";
				}
			 	if(PlayerAFK[i] == true)
				{
					astatus = "{FFCC00}Paused";
				}
                new string[500];
				format(string, sizeof(string), "* Server %s: %s (%d), Status: %s", GetAdminRank(i), ReturnName(i), i, astatus);
				SendClientMessage(playerid, color_white, string);
				}
            }
        }
    return 1;
}


CMD:id(playerid, params[])
{
	new count, name[MAX_PLAYER_NAME], playerb = strval(params);

	if(isnull(params))
	{
	    return SendClientMessage(playerid, color_red, "[Usage]{FFFFFF}: /id [playerid/name]");
	}

	if(IsNumeric(params))
	{
		if(IsPlayerConnected(playerb))
		{
			SendClientMessageEx(playerid,color_lime, "Matching Players:");
		    GetPlayerName(playerb, name, sizeof(name));
		    SendClientMessageEx(playerid,color_white, "* %s (%d) - mode: %s",PlayerInfo[playerb][pAccName],playerb, GetPlayerMode(playerb));
		}
		else
		{
		    SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: No player with that {FD0000}ID{FFFFFF}.");
		}
	}
	else if(strlen(params) < 2)
	{
	    SendClientMessage(playerid, color_red, "[Error]{FFFFFF}: Please input at least two characters to search.");
	}
	else
	{
	    foreach(new i : Player)
	    {
	        GetPlayerName(i, name, sizeof(name));
			SendClientMessage(playerid, color_lime, "Matching Players:");
	        if(strfind(name, params, true) != -1)
	        {
				new string[180];
				format(string, sizeof(string), "* %s (%d) - Mode: %s", PlayerInfo[i][pAccName],i,GetPlayerMode(i));
	            count++;
			}
		}

		if(!count)
		{
		    SendClientMessageEx(playerid, color_red, "[Error]{FFFFFF}: No results found for \"%s\". Please narrow your search.", params);
		}
	}

	return 1;
}

CMD:afk(playerid, params[])
{
	new playerb;

	if(sscanf(params, "u", playerb))
	{
	    return SendClientMessage(playerid, color_red, "[Usage]{FFFFFF}: /afk [playerid/name]");
	}
	if(!IsPlayerConnected(playerb))
	{
	    return SendClientMessage(playerid, color_red, "The player specified is disconnected.");
	}

	if(PlayerAFK[playerb] == true)
	{
	    SendClientMessageEx(playerid, color_banned, "[AFK]{FFFFFF}: %s has been AFK for %i seconds.", ReturnName(playerb), gettime()-AFKTime[playerb]);
	}
	else
	{
	    SendClientMessageEx(playerid, color_banned, "[AFK]{FFFFFF}: %s is not afk", ReturnName(playerb));
	}

	return 1;
}


CMD:vc(playerid, params[])
{
	if(PlayerInfo[playerid][pDonator] == 1)
	{
	if(isnull(params))
    {
    return SendClientMessage(playerid, color_red, "[Donator]{FFFFFF}: /vc [message]");
    }
	new string[88];
	format(string, sizeof(string), "[VIP] Donator %s (%d){FFFFFF}: %s ",PlayerInfo[playerid][pAccName],playerid, params);
	SendDonatorMessage(color_purple, string);
	}
	else
	{
		SendClientMessage(playerid, color_red, "You are not authorized to use this command");
	}
	return 1;
}

CMD:report(playerid, params[])
{
    if(ActiveReport[playerid] == 1)
	{
        SendClientMessage(playerid, color_ticket, "You already submitted a report");
        return 1;
    }

    new playerb, reporttext[120];
    if(sscanf(params, "us[120]", playerb, reporttext))
        return SendClientMessage(playerid, color_red, "[Usage]{FFFFFF}: /report [id] [reason]");

    if(PlayerInfo[playerb][pAdmin] >= 1)
        return SendClientMessage(playerid, color_error, "You cannot report admins, report them on discord");

	new stringd[150];
	new stringr[150];
	if (_:g_ReportLogChannel == 0)
	g_ReportLogChannel = DCC_FindChannelById("827402805710028811");
	format(stringd, sizeof(stringd), "[Report #%d]: %s(%d) has reported %s(%d) for _%s_",playerid, ReturnName(playerid), playerid, ReturnName(playerb),playerb, reporttext);
	format(stringr, sizeof(stringr), "[Report #%d]: {FD0000}%s (%d) {FFFFFF}has reported {FD0000}%s(%d) {FFFFFF}for {FD0000}%s",playerid, ReturnName(playerid), playerid, ReturnName(playerb),playerb, reporttext);
	SendAdminMessage(color_error, stringr);
	SendClientMessageEx(playerid, color_ticket, "%s has been reported. The report is #%d in queue",ReturnName(playerb), playerid);
	DCC_SendChannelMessage(g_ReportLogChannel, stringd);
	ActiveReport [playerid] = 1;
    return 1;
}

CMD:support(playerid, params[])
{
    if(ActiveSupport[playerid] == 1)
	{
        SendClientMessage(playerid, color_ticket, "You already have a support ticket open. Be patient.");
        return 1;
    }

    new support[120];
    if(sscanf(params, "s[120]", support))
        return SendClientMessage(playerid, color_red, "[Usage]{FFFFFF}: /support [message]");

	new stringd[150];
	new stringr[150];
	if (_:g_SupportLogChannel == 0)
	g_SupportLogChannel = DCC_FindChannelById("827402863947939890");
	format(stringd, sizeof(stringd), "[Support #%d]: %s(%d) support ticket for: %s",playerid, ReturnName(playerid), playerid, support);
	format(stringr, sizeof(stringr), "[Support #%d]: {FD0000}%s (%d) {FFFFFF}has asked {FD0000}''%s''",playerid, ReturnName(playerid), playerid, support);
	SendAdminMessage(color_error, stringr);
	SendClientMessageEx(playerid, color_ticket, "You made a support ticket. There are currently %d tickets pending.",playerid);
	DCC_SendChannelMessage(g_SupportLogChannel, stringd);
	ActiveSupport[playerid] = 1;
    return 1;
}

CMD:sprunk(playerid, params[])
{
	if(PlayerNearSprunk(playerid))
	{
		if(NBA[playerid] == 1 && capedbynba == 1)
		{
			GivePlayerHealth(playerid, 25);
			SendClientMessage(playerid, color_ticket, "As per turf benifit, you get to use the Sprunk Machines");
		}
		if(GSF[playerid] == 1 && capedbygsf == 1)
		{
			GivePlayerHealth(playerid, 25);
			SendClientMessage(playerid, color_ticket, "As per turf benifit, you get to use the Sprunk Machines");
		}
		if(VAR[playerid] == 1 && capedbyvar == 1)
		{
			GivePlayerHealth(playerid, 25);
			SendClientMessage(playerid, color_ticket, "As per turf benifit, you get to use the Sprunk Machines");
		}
		if(LSV[playerid] == 1 && capedbylsv == 1)
		{
			GivePlayerHealth(playerid, 25);
			SendClientMessage(playerid, color_ticket, "As per turf benifit, you get to use the Sprunk Machines");
		}
		else
		{
			SendClientMessage(playerid, color_error, "You cannot use the sprunk as your gang does not own a turf");
		}
	}
	return 1;
}

/*
CMD:group(playerid, params[])
{
	SendClientMessageEx(playerid, color_lime, "Group ID: %s",PlayerInfo[playerid][grouppid]);
	SendClientMessageEx(playerid, color_lime, "Group Rank: %s",PlayerInfo[playerid][grouprank]);
	return 1;
}*/


CMD:settings(playerid, params[])
{
	new dis[64];
	if(showconnect[playerid] == 1)
	{
		dis = "{42D43D}YES";
	}
	else if(showconnect[playerid] == 0)
	{
		dis = "{FF2121}OFF";
	}
	new togpublic[64];
	if(publicoff[playerid] == 0)
	{
		togpublic = "{42D43D}YES";
	}
	else if(publicoff[playerid] == 1)
	{
		togpublic = "{FF2121}OFF";
	}
	new togpms[64];
	if(togpm[playerid] == 0)
	{
		togpms = "{42D43D}ON";
	}
	else if(togpm[playerid] == 1)
	{
		togpms = "{FF2121}OFF";
	}
	new lui[64];
	if(showlocation[playerid] == 1)
	{
		lui = "{42D43D}ON";
	}
	else if(showlocation[playerid] == 0)
	{
		lui = "{FF2121}OFF";
	}
	new hits[64];
	if(showhitmarker[playerid] == 1)
	{
		hits = "{42D43D}ON";
	}
	else if(showhitmarker[playerid] == 0)
	{
		hits = "{FF2121}OFF";
	}
	new string1[225];
	new string2[225];
	new string3[225];
	new string4[225];
	new string5[350];
	new string6[350];
	new string[225]; string =  "{FFFFFF}Option\t{FFFFFF}Status\n";//1
    format(string1, sizeof(string1), "%s{FFFFFF}Change Password\n", string);//2
    format(string2, sizeof(string2), "%s{FFFFFF}(Dis)connection Messages\t%s\n", string1, dis);//3
    format(string3, sizeof(string3), "%s{FFFFFF}Public Chat\t%s\n", string2, togpublic);//4
    format(string4, sizeof(string4), "%s{FFFFFF}Toggle PM\t%s\n", string3, togpms);//5
	format(string5, sizeof(string5), "%s{FFFFFF}Location UI\t%s\n", string4, lui);//6
	format(string6, sizeof(string6), "%s{FFFFFF}Hitmarker\t%s\n", string5, hits);//7
    ShowPlayerDialog(playerid, 10, DIALOG_STYLE_TABLIST_HEADERS, "{EE28EB}[F:DM] {FFFFFF}Settings", string6, "Select", "Close");
	return 1;
}

CMD:distest(playerid, params[])
{
	SendConnectMessage(color_red, "works, on");
	return 1;
}
//========================STOCK VALUES=====================================================//
//========================STOCK VALUES=====================================================//

stock GivePlayerHealth(playerid, Float:amount)
{
	new Float:health;
	GetPlayerHealth(playerid, health);
	SetPlayerHealth(playerid, (health + amount > 100.0) ? (100.0) : (health + amount));
}


stock PlayerNearSprunk(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 1, 2229.7592, -1457.9022, 23.8303)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 2145.0109, -1645.8503, 15.0804)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 1929.5269, -1773.1405, 13.4013)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 2496.6188, -1643.3398, 13.7771)) return 1;
	if(IsPlayerInRangeOfPoint(playerid, 1, 1869.3774, -2035.8093, 13.5413)) return 1;
	return 0;
}


stock GetPlayerMode(playerid)
{
	new string[24];

	switch(ModeDetectionResults[playerid])
	{
	    case 1: string = "Lobby";
	    case 2: string = "Gang Wars";
	    case 3: string = "LVPD DM";
	    case 4: string = "Warehouse DM";
		case 5: string = "RC Ground DM";
		case 6: string = "Jizzy DM";
		case 7: string = "Sniper DM";
		case 8: string = "Ghost DM";
		case 9: string = "Cop Chase";
	}

	return string;
}

stock GetAdminRank(playerid)
{
	new string[24];

	switch(PlayerInfo[playerid][pAdmin])
	{
	    case 1: string = "Administrator";
	    case 2: string = "Developer";
	    case 3: string = "Owner";
	}

	return string;
}


stock Bannedskins(skinid)
{
	if(skinid < 1 || skinid > 311) return 0;
	switch(skinid)
	{
	    case 267, 67, 0, 45: return 0;
	}
	return 1;
}


stock ReturnName(playerid)
{
    new playersName[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, playersName, sizeof(playersName));
    return playersName;
}

stock ReturnSkin(playerid)
{
    new playerSkin;
    playerSkin = GetPlayerSkin(playerid);
    return playerSkin;
}

stock ReturnIP(playerid)
{
	new
		ipAddress[20];

	GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
	return ipAddress;
}

stock ReturnDate()
{
	new sendString[90], MonthStr[40], month, day, year;
	new hour, minute, second;

	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "January";
	    case 2:  MonthStr = "February";
	    case 3:  MonthStr = "March";
	    case 4:  MonthStr = "April";
	    case 5:  MonthStr = "May";
	    case 6:  MonthStr = "June";
	    case 7:  MonthStr = "July";
	    case 8:  MonthStr = "August";
	    case 9:  MonthStr = "September";
	    case 10: MonthStr = "October";
	    case 11: MonthStr = "November";
	    case 12: MonthStr = "December";
	}

	format(sendString, 90, "%s %d, %d %02d:%02d:%02d", MonthStr, day, year, hour, minute, second);
	return sendString;
}

stock KickEx(playerid)
{
	return SetTimerEx("KickTimer", 100, false, "i", playerid);
}

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[200]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 200
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}

stock ReturnVehicleName(vehicleid)
{
	new
		model = GetVehicleModel(vehicleid),
		name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}

stock otherplayerids(const string[], &index)
{
    new length = strlen(string);
    while ((index < length) && (string[index] <= ' '))
    {
        index++;
    }
    new offset = index;
    new result[20];
    while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
    {
        result[index - offset] = string[index];
        index++;
    }
    result[index - offset] = EOS;
    return result;
}


//SendSpecialMessage
stock SendGwarMessage(color, message[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(INGWR[i])
         {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
} 

stock SendLEOMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(COPLEO[i] > 0)
         {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock GetLvpdPlayers()
{
    new players;
    foreach(new i : Player)
    {
        if( LVPD[i] /*== arena*/)
        {
            players++;
        }
    }
    return players;
}

stock GetWarehousePlayers()
{
    new players;
    foreach(new i : Player)
    {
        if( WDM[i] /*== arena*/)
        {
            players++;
        }
    }
    return players;
}

stock GetPleasurePlayers()
{
    new players;
    foreach(new i : Player)
    {
        if( PDM[i] /*== arena*/)
        {
            players++;
        }
    }
    return players;
}

stock GetSniperPlayers()
{
    new players;
    foreach(new i : Player)
    {
        if( SDM[i] /*== arena*/)
        {
            players++;
        }
    }
    return players;
}

stock GetGhostPlayers()
{
    new players;
    foreach(new i : Player)
    {
        if(GDM[i] /*== arena*/)
        {
            players++;
        }
    }
    return players;
}

stock GetRcgPlayers()
{
    new players;
    foreach(new i : Player)
    {
        if(INRCDM[i] /*== arena*/)
        {
            players++;
        }
    }
    return players;
}

stock SendGroveMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(GSF[i] > 0)
         {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendBallasMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(NBA[i] > 0)
         {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendVariosMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(VAR[i] > 0)
         {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendVagosMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(LSV[i] > 0)
        {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendAdminMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerInfo[i][pAdmin] > 0)
        {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendPublicMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(publicoff[i] == 0)
        {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendConnectMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(showconnect[i] == 1)
        {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock SendDonatorMessage(color, message[]) 
{ 
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerInfo[i][pDonator] > 0)
         {
            SendClientMessage(i, color, message);
        }
    }
	return 1;
}

stock IsNumeric(const string[])
{
	new
		len = strlen(string),
		i;

	if(string[0] == '-') i = 1;

	while(i < len)
	{
	    if(!('0' <= string[i++] <= '9'))
	        return 0;
	}

	return 1;
}

//============================FUNCTIONS===============================================//
//============================FUNCTIONS===============================================//

function:KickTimer(playerid) { return Kick(playerid); }

function:SetPlayerCamera(playerid)
{
	new rand = random(3);

	switch(rand)
	{
		case 0:
		{
		SetPlayerCameraPos(playerid, 2019.1145, 1202.9185, 42.3246);
		SetPlayerCameraLookAt(playerid, 2019.9889, 1202.4272, 42.2945);
		}
		case 1:
		{
   		SetPlayerCameraPos(playerid, 1701.8396, -1572.9250, 26.6298);
		SetPlayerCameraLookAt(playerid, 1701.2588, -1572.1072, 27.1848);
		}
		case 2:
		{
   		SetPlayerCameraPos(playerid, -2619.1006, 2202.6091, 49.9144);
		SetPlayerCameraLookAt(playerid, -2619.2512, 2201.6155, 50.1043);
		}
	}
	return 1;
}

function:ResetPlayer(playerid)
{ 
	playerLogin[playerid] = 0;
	PlayerInfo[playerid][pDBID] = 0;
	PlayerInfo[playerid][pLoggedin] = false;
	PlayerInfo[playerid][pSkin] = 0;
	return 1;
}


function:LogPlayerIn(playerid)
{
	new rows;
	cache_get_row_count(rows);
    if(!rows)
    {

		SendClientMessageEx(playerid, color_pink, "[Register]{FFFFFF}: The user ({FD0000}%s{FFFFFF}) you're connected with is not a registered.", ReturnName(playerid));
		SendClientMessage(playerid, color_pink, "[Register]{FFFFFF}: Please register to continue.");
		
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{EE28EB}[F:DM] {FFFFFF}Welcome to Florida DM", "You can now register!\nTIP: Don't use same password as other servers\nPlease.\n\n           Enter Your Password:", "Register", "Cancel");
		return 1;
    }

    SendClientMessageEx(playerid, color_cyan, "Welcome to Florida DM, %s {FFFFFF}["SCRIPT_VERSION"]", ReturnName(playerid));
    return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{EE28EB}[F:DM] {FFFFFF}Welcome to Florida DM","{FFFFFF}This user is registered\n{FFFFFF}Enter Your Password:", "Login", "Cancel");
}

function:OnPlayerRegister(playerid)
{
	PlayerInfo[playerid][pDBID] = cache_insert_id();
	format(PlayerInfo[playerid][pAccName], 32, "%s", ReturnName(playerid));
	new thread[120];
	mysql_format(ourConnection, thread, sizeof(thread), "SELECT * FROM accounts WHERE acc_name = '%e'", ReturnName(playerid));
	mysql_tquery(ourConnection, thread, "Query_LoadAccount", "i", playerid);
	PlayerInfo[playerid][pLoggedin] = true;
	ShowModelSelectionMenu(playerid, joinskin, "Pick A Skin");
}

function:LoggingIn(playerid)
{
	if(!cache_num_rows())
	{
		playerLogin[playerid]++;

		if(playerLogin[playerid] == 3)
		{
		       SendClientMessage(playerid, color_purple, "[Kick]{FFFFFF}: You were kicked for bad password attempts.");
		       return KickEx(playerid);
		}

		return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Welcome to Florida DM", "You entered the wrong password!\n\nYou have 3 chances to enter\nyour right password.\n\n           Enter Your Password:", "Login", "Cancel");
	}
	new thread[120];
    mysql_format(ourConnection, thread, sizeof(thread), "SELECT * FROM accounts WHERE acc_name = '%e'", ReturnName(playerid));
    mysql_tquery(ourConnection, thread, "Query_LoadAccount", "i", playerid);
	format(PlayerInfo[playerid][pAccName], 32, "%s", ReturnName(playerid));
	PlayerInfo[playerid][pLoggedin] = true;
    ShowModelSelectionMenu(playerid, joinskin, "Pick A Skin");
	return 1;
}
function:Query_LoadAccount(playerid)
{
    cache_get_value_name_int(0, "pAdmin", PlayerInfo[playerid][pAdmin]);
    cache_get_value_name_int(0, "acc_dbid", PlayerInfo[playerid][pDBID]);
    cache_get_value_name_int(0, "pMute", PlayerInfo[playerid][pMute]);
    cache_get_value_name_int(0, "pBan", PlayerInfo[playerid][pBan]);
	cache_get_value_name_int(0, "pDonator", PlayerInfo[playerid][pDonator]);
    cache_get_value_name(0, "pBanReason", PlayerInfo[playerid][pBanReason], 60);
    cache_get_value_name(0, "pBanAdmin", PlayerInfo[playerid][pBanAdmin], 60);
    cache_get_value_name_int(0, "acc_kills", PlayerInfo[playerid][pKills]);
    cache_get_value_name_int(0, "acc_money", PlayerInfo[playerid][pMoney]);
    cache_get_value_name_int(0, "acc_deaths", PlayerInfo[playerid][pDeaths]);
    cache_get_value_name_int(0, "acc_score", PlayerInfo[playerid][pScore]);
	if(PlayerInfo[playerid][pBan] > 0)
    {
        SendClientMessage(playerid,  color_banned, "=============You are permanently banned============");
        SendClientMessage(playerid,  color_banned, "You are permanently banned.");
        SendClientMessageEx(playerid,color_banned, "Reason: %s", PlayerInfo[playerid][pBanReason]);
        SendClientMessageEx(playerid,color_banned, "Banned by: %s", PlayerInfo[playerid][pBanAdmin]); 
		SendClientMessage(playerid,  color_banned,"");
        SendClientMessage(playerid,  color_banned, "[!] You can appeal your ban on our discord (https://discord.gg/rdaTBA6rgS)");
        SendClientMessage(playerid,  color_banned, "[!] Please do not ban evade or you will not be unbanned.");
        KickEx(playerid);
        return 1;
    }
	SetPlayerScore(playerid, PlayerInfo[playerid][pScore]);
	GivePlayerMoney(playerid, PlayerInfo[playerid][pMoney]);
	return 1;
}

function:ResetStatus(playerid)
{
	INL [playerid] = 1;
    GSF [playerid] = 0;
    NBA [playerid] = 0;
    LSV [playerid] = 0;
    INGWR [playerid] = 0;
    VAR [playerid] = 0;
    LVPD [playerid] = 0;
    WDM [playerid] = 0;
    INDM [playerid] = 0;
    INRCDM [playerid] = 0;
    PDM [playerid] = 0;
    SDM [playerid] = 0;
	publicoff[playerid] = false; // just in case
	togpm[playerid] = false;
	publicoff[playerid] = false;
	showconnect[playerid] = true;
	showhitmarker[playerid] = false;
	showlocation[playerid] = false;
    GDM [playerid] = 0;
	COPPOLICE [playerid] = 0;
	COPLEO [playerid] = 0;
	COPFBI [playerid] = 0;
	COPHRT [playerid] = 0;
	COPCRIM [playerid] = 0;
	ActiveReport [playerid] = 0;
	ActiveSupport [playerid] = 0;
	return 1;
}
