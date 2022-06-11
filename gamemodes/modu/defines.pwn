//--------------------dialogs----------------------------------///

//accounts
#define DIALOG_REGISTER (0)
#define DIALOG_LOGIN (1)

#define DIALOG_DM (2)
#define DIALOG_GWR (3)
#define DIALOG_WPN (4)
//duel
#define DIALOG_DUEL (5)
//cop chase
#define DIALOG_COP_CHASE (6)
#define DIALOG_COP_CHASE_SAPD (7)
#define DIALOG_COP_CHASE_FBI (8)
//group dialogs
#define DIALOG_GROUP_INVITE (9)
//setting dialogs
#define DIALOG_SETTINGS (10)

//Group
#define MAX_GROUPS 150

//----------------Register / login stuff --------------------////
#define callcmd::%0(%1) CallLocalFunction(“cmd_%0”, %1, params)

//------------------- Functions -----------------------------------//
#define function:%0(%1) forward %0(%1); public %0(%1)
//------------------- Colors -----------------------------------//
//general
#define color_pink (0xd615d6FF)
#define rp_color (0xab78bfFF)
#define color_white (0xffffffFF)
#define color_lime (0x21f50aFF)
#define color_cyan (0x0aedf5FF)
#define color_blue (0x0a25f5FF)
#define color_red (0xf50a0eFF)
#define color_yellow (0xf0fc03FF)
#define color_green (0x2ead1aFF)
#define color_purple (0xaf11edFF)
#define color_orange (0xed3e1cFF)

#define color_ask (0xAC0EC4FF)
#define color_ticket (0x40FFFFFF)
#define color_error (0xFF8282FF)
#define color_wt (0x81C786FF)

//local
#define COLOR_FADE1 0xDDA2F0FF
#define COLOR_FADE2 0xDDA2F0FF
#define COLOR_FADE3  0xCA94DBFF
#define COLOR_FADE4  0xB484C4FF
#define COLOR_FADE5  0x916A9DFF

//pm
#define COLOR_YELLOW   0xf2f213ff
#define COLOR_YELLOW2  0xe2e21fff

//cop chase

#define color_criminal (0x991F1FFF)
#define COLOR_VOL 0x409FFFFF


// ------------[GANG WAR COLORS] ------------ //

#define COLOR_BALLAS  0xEE28EEFF
#define COLOR_GROVE   0x2B8A11FF
#define COLOR_VAGOS   0xF7D60AFF
#define COLOR_AZCETAS 0x0bc3d4FF


//--------[Admin system colors]---------------//
#define COLOR_KICK 0x8f400bFF
#define color_banned (0xFF2F00FF)