/* Plugin Template generated by Pawn Studio */

#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

#define FL_PISTOL_PRIMARY (1<<6) //Is 1 when you have a primary weapon and dual pistols
#define FL_PISTOL (1<<7) //Is 1 when you have dual pistols

public Plugin myinfo = 
{
	name = "L4D 2 Drop Weapon",
	author = "Frustian",
	description = "Allows players to drop the weapon they are holding, or another weapon they have",
	version = "1.1",
	url = ""
}

ConVar g_hSpecify;

public void OnPluginStart()
{
	CreateConVar("l4d_drop_version", "1.1", "Drop Weapon Version", FCVAR_SPONLY|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	g_hSpecify = CreateConVar("l4d_drop_specify", "1", "Allow people to drop weapons they have, but are not using", FCVAR_SPONLY);
	RegConsoleCmd("sm_drop", Command_Drop);
}

public Action Command_Drop(int client, int args)
{
	if (client == 0 || GetClientTeam(client) != 2 || !IsPlayerAlive(client))
		return Plugin_Handled;
	char weapon[32];
	if (args > 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_drop [weapon]");
		return Plugin_Handled;
	}
	if (args == 1)
	{
		if (GetConVarInt(g_hSpecify))
		{
			GetCmdArg(1, weapon, 32);
			if ((StrContains(weapon, "pump") != -1 || StrContains(weapon, "auto") != -1 || StrContains(weapon, "shot") != -1 || StrContains(weapon, "rifle") != -1 || StrContains(weapon, "smg") != -1 || StrContains(weapon, "uzi") != -1 || StrContains(weapon, "m16") != -1 || StrContains(weapon, "grenade") != -1 || StrContains(weapon, "ak47") != -1 || StrContains(weapon, "desert") != -1 || StrContains(weapon, "sg552") != -1 || StrContains(weapon, "chrome") != -1 || StrContains(weapon, "spas") != -1 || StrContains(weapon, "mp5") != -1 || StrContains(weapon, "silenced") != -1 || StrContains(weapon, "military") != -1 || StrContains(weapon, "awp") != -1 || StrContains(weapon, "scout") != -1 || StrContains(weapon, "hunt") != -1 || StrContains(weapon, "scar") != -1 || StrContains(weapon, "main") != -1 || StrContains(weapon, "m60") != -1) && GetPlayerWeaponSlot(client, 0) != -1)
				DropSlot(client, 0);
			else if ((StrContains(weapon, "pistol") != -1) && GetPlayerWeaponSlot(client, 1) != -1)
				DropSlot(client, 1);
			else if ((StrContains(weapon, "pipe") != -1 || StrContains(weapon, "vomit") != -1 || StrContains(weapon, "bile") != -1 || StrContains(weapon, "mol") != -1) && GetPlayerWeaponSlot(client, 2) != -1)
				DropSlot(client, 2);
			else if ((StrContains(weapon, "kit") != -1 || StrContains(weapon, "pack") != -1 || StrContains(weapon, "defib") != -1 || StrContains(weapon, "med") != -1 || StrContains(weapon, "ammo") != -1 ) && GetPlayerWeaponSlot(client, 3) != -1)
				DropSlot(client, 3);
			else if ((StrContains(weapon, "pill") != -1 || StrContains(weapon, "adre") != -1) && GetPlayerWeaponSlot(client, 4) != -1)
				DropSlot(client, 4);
			else
				ReplyToCommand(client, "[SM] You do not have a %s!", weapon);
		}
		else
			ReplyToCommand(client, "[SM] This server's settings do not allow you to drop a specific weapon.  Use sm_drop(/drop in chat) without a weapon name after it to drop the weapon you are holding.");
		return Plugin_Handled;
	}
	GetClientWeapon(client, weapon, 32);
	if (StrEqual(weapon, "weapon_rifle_m60") || StrEqual(weapon, "weapon_pumpshotgun") || StrEqual(weapon, "weapon_autoshotgun") || StrEqual(weapon, "weapon_rifle") || StrEqual(weapon, "weapon_smg") || StrEqual(weapon, "weapon_grenade_launcher") || StrEqual(weapon, "weapon_rifle_ak47") || StrEqual(weapon, "weapon_rifle_desert") || StrEqual(weapon, "weapon_rifle_sg552") || StrEqual(weapon, "weapon_shotgun_chrome") || StrEqual(weapon, "weapon_shotgun_spas") || StrEqual(weapon, "weapon_smg_mp5") || StrEqual(weapon, "weapon_smg_silenced") || StrEqual(weapon, "weapon_sniper_awp") || StrEqual(weapon, "weapon_sniper_military") || StrEqual(weapon, "weapon_sniper_scout") || StrEqual(weapon, "weapon_hunting_rifle"))
		DropSlot(client, 0);
	else if (StrEqual(weapon, "weapon_pistol"))
		DropSlot(client, 1);
	else if (StrEqual(weapon, "weapon_pipe_bomb") || StrEqual(weapon, "weapon_vomitjar") || StrEqual(weapon, "weapon_molotov"))
		DropSlot(client, 2);
	else if (StrEqual(weapon, "weapon_first_aid_kit") || StrEqual(weapon, "weapon_defibrillator") || StrEqual(weapon, "weapon_upgradepack_explosive") || StrEqual(weapon, "weapon_upgradepack_incendiary"))
		DropSlot(client, 3);
	else if (StrEqual(weapon, "weapon_pain_pills") || StrEqual(weapon, "weapon_adrenaline"))
		DropSlot(client, 4);
	return Plugin_Handled;
}

public void DropSlot(int client, int slot)
{
	if (GetPlayerWeaponSlot(client, slot) > 0)
	{
		char sWeapon[32];
		int ammo;
		int clip;
		int ammoOffset = FindSendPropInfo("CTerrorPlayer", "m_iAmmo");
		GetEdictClassname(GetPlayerWeaponSlot(client, slot), sWeapon, 32);
		if (slot == 0)
		{
			clip = GetEntProp(GetPlayerWeaponSlot(client, 0), Prop_Send, "m_iClip1");
			if (StrEqual(sWeapon, "weapon_pumpshotgun") || StrEqual(sWeapon, "weapon_autoshotgun") || StrEqual(sWeapon, "weapon_shotgun_chrome") || StrEqual(sWeapon, "weapon_shotgun_spas"))
			{
				ammo = GetEntData(client, ammoOffset+(6*4));
				SetEntData(client, ammoOffset+(6*4), 0);
			}
			else if (StrEqual(sWeapon, "weapon_smg") || StrEqual(sWeapon, "weapon_smg_silenced") || StrEqual(sWeapon, "weapon_smg_mp5"))
			{
				ammo = GetEntData(client, ammoOffset+(5*4));
				SetEntData(client, ammoOffset+(5*4), 0);
			}
			//else if (StrEqual(sWeapon, "weapon_rifle"))
			else if (StrEqual(sWeapon, "weapon_rifle_m60") || StrEqual(sWeapon, "weapon_rifle") || StrEqual(sWeapon, "weapon_rifle_ak47") || StrEqual(sWeapon, "weapon_rifle_desert") || StrEqual(sWeapon, "weapon_rifle_sg552") )
			{
				ammo = GetEntData(client, ammoOffset+(3*4));
				SetEntData(client, ammoOffset+(3*4), 0);
			}
			else if (StrEqual(sWeapon, "weapon_hunting_rifle")|| StrEqual(sWeapon, "weapon_sniper_military") || StrEqual(sWeapon, "weapon_sniper_awp") || StrEqual(sWeapon, "weapon_sniper_scout"))
			{
				ammo = GetEntData(client, ammoOffset+(2*4));
				SetEntData(client, ammoOffset+(2*4), 0);
			}
		}
		if (slot == 1)
		{
			if ((GetEntProp(client, Prop_Send, "m_iAddonBits") & (FL_PISTOL|FL_PISTOL_PRIMARY)) > 0)
			{
				clip = GetEntProp(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_iClip1");
				RemovePlayerItem(client, GetPlayerWeaponSlot(client, 1));
				SetCommandFlags("give", GetCommandFlags("give") & ~FCVAR_CHEAT);
				FakeClientCommand(client, "give pistol", sWeapon);
				SetCommandFlags("give", GetCommandFlags("give") | FCVAR_CHEAT);
				if (clip < 15)
					SetEntProp(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_iClip1", 0);
				else
					SetEntProp(GetPlayerWeaponSlot(client, 1), Prop_Send, "m_iClip1", clip-15);
				int index = CreateEntityByName(sWeapon);
				float cllocation[3];
				GetEntPropVector(client, Prop_Send, "m_vecOrigin", cllocation);
				cllocation[2]+=20;
				TeleportEntity(index,cllocation, NULL_VECTOR, NULL_VECTOR);
				DispatchSpawn(index);
				ActivateEntity(index);
			}
			else
				ReplyToCommand(client, "[SM] You can't drop your only pistol!");
			return;
		}
		int index = CreateEntityByName(sWeapon);
		float cllocation[3];
		GetEntPropVector(client, Prop_Send, "m_vecOrigin", cllocation);
		cllocation[2]+=20;
		TeleportEntity(index,cllocation, NULL_VECTOR, NULL_VECTOR);
		DispatchSpawn(index);
		ActivateEntity(index);
		RemovePlayerItem(client, GetPlayerWeaponSlot(client, slot));
		if (slot == 0)
		{
			SetEntProp(index, Prop_Send, "m_iExtraPrimaryAmmo", ammo);
			SetEntProp(index, Prop_Send, "m_iClip1", clip);
		}
	}
}