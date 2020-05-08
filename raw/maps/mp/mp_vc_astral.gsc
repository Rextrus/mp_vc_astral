// __/\\\________/\\\_______________________________________________________________________/\\\\\\\\\__/\\\\\\_________________________________        
//  _\/\\\_______\/\\\____________________________________________________________________/\\\////////__\////\\\_________________________________       
//   _\//\\\______/\\\___/\\\__________________/\\\_______/\\\___________________________/\\\/______________\/\\\_________________________________      
//   __\//\\\____/\\\___\///___/\\\\\\\\\\__/\\\\\\\\\\\_\///______/\\\\\\\\____________/\\\________________\/\\\_____/\\\\\\\\\_____/\\/\\\\\\___     
//    ___\//\\\__/\\\_____/\\\_\/\\\//////__\////\\\////___/\\\___/\\\//////____________\/\\\________________\/\\\____\////////\\\___\/\\\////\\\__    
//     ____\//\\\/\\\_____\/\\\_\/\\\\\\\\\\____\/\\\______\/\\\__/\\\___________________\//\\\_______________\/\\\______/\\\\\\\\\\__\/\\\__\//\\\_   
//      _____\//\\\\\______\/\\\_\////////\\\____\/\\\_/\\__\/\\\_\//\\\___________________\///\\\_____________\/\\\_____/\\\/////\\\__\/\\\___\/\\\_  
//       ______\//\\\_______\/\\\__/\\\\\\\\\\____\//\\\\\___\/\\\__\///\\\\\\\\______________\////\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\/\\_\/\\\___\/\\\_ 
//        _______\///________\///__\//////////______\/////____\///_____\////////__________________\/////////__\/////////___\////////\//__\///____\///__
/*
         _   ________   ___       __             _
        | | / / ___( ) / _ | ____/ /_____ ____  (_)
        | |/ / /__ |/ / __ |/ __/  '_/ _ `/ _ \/ /
        |___/\___/   /_/ |_/_/ /_/\_\\_,_/_//_/_/  
    Website: vistic-clan.com
    
    thanks: Phelix (for fixing the weapon problem :))
*/
main()
{
    maps\mp\_load::main();

    game["allies"] = "sas";
    game["axis"] = "opfor";
    game["attackers"] = "axis";
    game["defenders"] = "allies";
    game["allies_soldiertype"] = "woodland";
    game["axis_soldiertype"] = "woodland";

    precacheItem("m40a3_mp");
    precacheItem("remington700_mp");
    precacheItem("p90_silencer_mp");
    precacheItem("knife_mp");
    precacheItem("deserteaglegold_mp");
    precacheItem("m4_mp");
    precacheItem("g3_silencer_mp");
    precacheItem("c4_mp");
    precacheItem("deserteagle_mp");
    precacheItem("ak74u_mp");

    //level._effect["name"] = loadfx("explosions/small_vehicle_explosion");

    setdvar("r_specularcolorscale","1");
    setdvar("r_glowbloomintensity0",".25");
    setdvar("r_glowbloomintensity1",".25");
    setdvar("r_glowskybleedintensity0",".3");
    setDvar("compassmaxrange","1024");
    setDvar("bg_fallDamageMaxHeight", 9999);
    setDvar("bg_fallDamageMinHeight", 9998);

    thread startingRound();

    //traps
    thread trap_glas();
    thread trap_nonsolid();
    thread trap_updown();
    thread trap_rotate();
    thread trap_rotate2();
    thread trap_bounce();
    thread trap_spike();
    thread trap_spin();

    thread vclogo();
    thread sec_parts();
    thread teleporter();
    thread vip();
    thread glitcher();
    thread onConnect();
    thread secret();

    thread kniferoom();
    thread knifemagic();
    thread sniperroom();
    thread jumproom();
    thread jump_weapon();
    thread oldway();
}
onConnect()
{
    //level endon("game_ended");
   
    for(;;)
    {
        level waittill("connected",player);
        player.gotWeapon = false;
    }
}
vip()
{
    trig=getent("vip_button","targetname");
    trig waittill("trigger",who);
    trig delete();
    if(getsubstr(who getguid(),24,32)=="91f89ba1" && !isdefined(level.creatoron))
        {
            level.creatoron=true;
            iprintlnbold("Map creator ^1"+who.name+"^7 is on the Server");
            who givegun("p90_silencer_mp");
        }
        else if(who getstat(767)==1)
        {
            who iprintlnbold("^1Authorized ^7VC' Member!\n You got a ^1Gold Deagle^7!");
            who givegun("deserteaglegold_mp");
        }
        else
        who iprintlnbold("Unfortunally you are not VIP. ^1:(");

}
 
givegun(weap)
{	
	
    self takeallweapons();
    self giveweapon(weap);
    self givemaxammo(weap);
    self switchtoweapon(weap);
}
teleporter()
{
    tele=getentarray("teleport","targetname");
    if(isdefined(tele))
    {
        for(i=0;i<tele.size;i++)
            tele[i] thread portMe();
    }
}
portMe()
{
    for(;;)
    {
        self waittill("trigger",who);
        targ=getent(self.target,"targetname");
        who freezecontrols(1);
        who setorigin(targ.origin);
        who setplayerangles(targ.angles);
        wait 0.01;
        who freezecontrols(0);
    }
}

startingRound()
{
    level waittill("round_started");

    song=randomint(9);
    if(song==0||song==3||song==7)
        ambientplay("background1");
    else if(song==1||song==4||song==8)
        ambientplay("background2");
    else
        ambientplay("background3");

    for(;;)
    {
        iprintln("Map by ^1VC' Arkani^7!");
        wait 10;
        iprintln("Made for ^1Vistic^7 Clan!");
        wait 10;
    }
}


trap_glas()
{
    brush = getent("trap_glas", "targetname");
    trig = getent("trap_glas_trigger", "targetname");

    trig waittill("trigger", who);
    trig delete();

    brush delete();
    who iPrintLnBold("You destroyed the ^1Glas^7!");
    who braxi\_rank::giverankxp(undefined,40);
}
trap_nonsolid()
{
    brush = getentarray("trap_nonsolid", "targetname");
    brush2 = getentarray("trap_nonsolid2", "targetname");
    trig = getent("trap_nonsolid_trigger", "targetname");

    trig waittill ("trigger", who);
    trig delete ();
 
    rdm=randomint(4);
    if(rdm==1||rdm==0)
        brush[randomInt(brush.size)] notsolid();
    else
        brush2[randomInt(brush2.size)] notsolid();

    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You made one of them ^1Non-Solid^7!");
}
vclogo()
{
    brush = getent("vc_logo", "targetname");

    while(1)
    {
        brush rotateyaw(360, 10);
        wait 10;
    }
}
knifemagic()
{
    brush = getent("knife_magic", "targetname");

    while(1)
    {
        brush movez(-400, 10);
        brush rotateyaw(360, 10);
        wait 3;
        brush movez(400, 10);
        brush rotateyaw(360, 10);
        wait 3;
    }
}
trap_updown()
{
    brushs1 = getent("updown_1", "targetname");
    brushs2 = getent("updown_2", "targetname");
    trig = getent("trap_updown", "targetname");

    trig waittill("trigger", who);
    trig delete();

    brushs1 movez(-300, 2);
    wait 2;

    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You let them ^1Move^7!");
    while(1)
    {
        brushs1 movez(300, 2);
        brushs2 movez(-300, 2);
        wait 2;
        brushs1 movez(-300, 2);
        brushs2 movez(300, 2);
        wait 2;
    }
}
//secret
sec_parts()
{
    trig1 = getent("sec_part1", "targetname");


    trig1 waittill("trigger", who);
    trig1 delete();
    who iprintln("why would you press use here? lol"); 
}
trap_rotate()
{
    brush = getent("trap_rotate", "targetname");
    trig = getent("trap_rotate_trig", "targetname");
    trig_hurt = getent("trap_rotate_hurt", "targetname");

    trig waittill("trigger", who);
    trig delete();

    trig_hurt enableLinkTo();
    trig_hurt linkTo(brush);

    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You let them ^1Rotate^7!");

    while(1)
    {
        brush rotateyaw(360, 3);
        wait 3; 
    }
}
trap_rotate2()
{
    brushs = getent("trap_rotate2", "targetname");
    trig = getent("trap_rotate2_trig", "targetname");

    trig waittill("trigger", who);
    trig delete();

    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You let it ^1Rotate^7!");

    while(1)
    {
        brushs rotateyaw(360, 2);
        wait 4;
    }
}
trap_bounce()
{
    brush = getent("trap_bounce", "targetname");
    trig = getent("trap_bounce_trig", "targetname");

    trig waittill("trigger", who);
    trig delete();

    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You started moving the ^1Bounce^7!");

    while(1)
    {
        brush movez(120, 2);
        wait 3;
        brush movez(-120, 2);
        wait 5;
    }
}
trap_spin()
{
    brush = getent("trap_spin", "targetname");
    brush2 = getent("trap_spin2", "targetname");
    trig = getent("trap_spin_trig", "targetname");

    trig waittill("trigger", who);
    trig delete();

    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You started spinning the ^1Way^7!");

    while(1)
    {
        brush rotateroll(-360, 3);
        brush2 rotateroll(360, 3);
        wait 6;
    }
}
trap_spike()
{
    brush = getent("trap_spike", "targetname");
    trig = getent("trap_spike_trig", "targetname");
    trig_hurt = getent("spike_hurt", "targetname");
 //   exp1 = getent("exp1", "targetname");

//  playfx(level._effect["exp1"],fx_point1.origin);

    trig waittill("trigger", who);
    trig delete();
 
    trig_hurt enableLinkTo();
    trig_hurt linkTo(brush);
 
    who braxi\_rank::giverankxp(undefined,40);
    who iPrintLnBold("You let them ^1Fallen!^7!");
 
    brush movez(-176, 0.2);
}
sniperroom()
{
    level.sniper=getent("sniper_tp","targetname");   // trigger
    acti=getent("acti_sniper","targetname");           // activator origin
    jump=getent("jump_sniper","targetname");           // jumper origin
 
    while(1)
    {
        level.sniper waittill("trigger",who);
        if(!isdefined(level.sniper))
            return;
 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+who.name+"^7 entered ^1Sniper Fight");
            level.knife delete();
            level.jump delete();
            level.old delete();
        }
 
        if(isdefined(level.activ))
        {
            who endroomsetup(jump.origin,jump.angles,"m40a3_mp","remington700_mp",1);
            level.activ endroomsetup(acti.origin,acti.angles,"m40a3_mp","remington700_mp",1);
            wait 5;
            ambientplay("sniper");
            who freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            who iprintlnbold("^1You need an enemy you scrublord."); // ;)
            return;
        }
 
        while(isalive(who)&&isdefined(who))
            wait 1;
 
        iprintlnbold("^1"+who.name+"^7 has been killed");
        who braxi\_rank::giverankxp(undefined,150);
    }
}
 
kniferoom()
{
    level.knife=getent("knife_tp","targetname");   // trigger
    acti=getent("acti_knife","targetname");           // activator origin
    jump=getent("jumper_knife","targetname");           // jumper origin
 
    while(1)
    {
        level.knife waittill("trigger",who);
        if(!isdefined(level.knife))
            return;
 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+who.name+"^7 opened ^1Knife ^7Fight!");
            level.sniper delete();
            level.jump delete();
            level.old delete();
        }
 
        if(isdefined(level.activ))
        {
            who endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
            level.activ endroomsetup(acti.origin,acti.angles,"knife_mp",undefined,1);
            ambientplay("knife");
            wait 5;
            who freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            who iprintlnbold("^1You need an enemy you scrublord."); // ;)
            return;
        }
 
        while(isalive(who)&&isdefined(who))
            wait 1;
 
        iprintlnbold("^1"+who.name+"^7 has been killed!");
        who braxi\_rank::giverankxp(undefined,150);
    }
}

endroomsetup(origin,angles,weap,weap2,freeze)
{
    self setorigin(origin);
    self setplayerangles(angles);
 
    self takeallweapons();
    self giveweapon(weap);
    if(isdefined(weap2))
        self giveweapon(weap2);
    self switchtoweapon(weap);
 
    self freezecontrols(freeze);
}
jumproom()
{
    level.jump=getent("jumper_tp","targetname");   // trigger
    acti=getent("acti_jump","targetname");           // activator origin
    jump=getent("jump_jump","targetname");           // jumper origin
    level.roomEntered=false; 

    while(1)
    {
        level.jump waittill("trigger",who);
        if(!isdefined(level.jump))
            return;
 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+who.name+"^7 opened the ^1Bounce Room");
            level.sniper delete();
            level.knife delete();
            level.old delete();
            ambientplay("bounce");
        }
 
        if(isdefined(level.activ))
        {
            who endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
            level.activ endroomsetup(acti.origin,acti.angles,"knife_mp",undefined,1);
            wait 5;
            who freezecontrols(0);
            level.activ freezecontrols(0);
        }
        else
        {
            who iprintlnbold("^1no activator defined");
            return;
        }
 
        while(isalive(who)&&isdefined(who))
            wait 1;
 
        iprintlnbold("^1"+who.name+"^7 has been killed");
        who braxi\_rank::giverankxp(undefined,100);
    }
}
jump_weapon()
{
    weapon_jump_trig = getent("jump_getWeapon", "targetname");
 
    for(;;)
    {
        weapon_jump_trig waittill("trigger", who);
 
        if(!who.gotWeapon)
            {
                who.gotWeapon = true;
                givegun("m40a3_mp");
                who iprintlnbold("^1You have got a ^1Scope^7!");
                wait 5;
            }
        else
            who iprintlnbold("^1You already have got the ^1Scope^7!");
            wait 5;
    }
}

glitcher()
{
    trig = getent("glitcher", "targetname");
    targ=getent("glitcher_back","targetname");

    for(;;)
    {
        trig waittill("trigger", who);
        who freezecontrols(1);
        who takeallweapons();
        who setorigin(targ.origin);
        who setplayerangles(targ.angles);
        wait 0.1;
        iprintlnbold("^1"+who.name+"^7 tried to glitch! ^1Execute^7 him!");
    }
}
oldway()
{
    level.old=getent("old_enter","targetname");   // trigger
    jump=getent("old_origin","targetname");           // jumper origin
 
    while(1)
    {
        level.old waittill("trigger",who);
        if(!isdefined(level.old))
            return;
 
        if(!level.roomEntered)
        {
            level.roomEntered=true;
            iprintlnbold("^1"+who.name+"^7 opened ^1Old ^7Fight!");
            level.sniper delete();
            level.jump delete();
            level.knife delete();
        }

        who endroomsetup(jump.origin,jump.angles,"knife_mp",undefined,1);
        wait 0.1;
        who freezecontrols(0);

 
        while(isalive(who)&&isdefined(who))
            wait 1;
 
        iprintlnbold("^1"+who.name+"^7 has been killed!");
        who braxi\_rank::giverankxp(undefined,150);
    }
}
secret()
{
    trig = getent("sec_open", "targetname");

    trig waittill("trigger", who);
    trig delete();
    who iprintln("why would u?");

    thread secret_enter();
    thread secret_leave();
    thread secret_leave_shot();
}
secret_enter()
{
    trig = getent("sec_enter", "targetname");
    origin=getent("auto1","targetname");  

    for(;;)
    {
        trig waittill("trigger", who);

        who endroomsetup(origin.origin,origin.angles,"deserteagle_mp","c4_mp",1);
        who iPrintLnBold("You've entered the ^1Secret ^7and have ^12^7 minutes to finish it!");
        wait 3;
        who freezecontrols(0);
        who secretTimer();
    }

}

secret_leave_shot()
{
    trig = getent("secret_leave_shot", "targetname");
    new_origin = getent("spawn", "targetname");
    for(;;)
    {
        trig waittill("trigger", who);

        who iPrintLnBold("You're left the ^1Secret^7!");
        who notify("secret_completed");
        if(isdefined(who.secretTimer))
            who.secretTimer destroy();
        who endroomsetup(new_origin.origin,new_origin.angles,"knife_mp",undefined,1);
        wait 0.1;
        who freezecontrols(0);
    }
}
secret_leave()
{
    trig=getent("secret_leave","targetname");
    targ=getent("secret_out","targetname");
    for(;;)
    {
        trig waittill("trigger",who);
        who notify("secret_completed");
 
        if(isdefined(who.secretTimer))
            who.secretTimer destroy();
        who freezecontrols(1);
        who setorigin(targ.origin);
        who setplayerangles(targ.angles);
        wait 0.1;
        who freezecontrols(0);
        iprintlnbold("^1"+who.name+"^7 finished the ^1Secret^7.");
        who braxi\_rank::giverankxp(undefined,300);
    }
}
secretTimer()
{
    self endon("secret_completed");

    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
 
    self.secretTimer=newclienthudelem(self);
    self.secretTimer.foreground = true;
    self.secretTimer.alignX = "center";
    self.secretTimer.alignY = "bottom";
    self.secretTimer.horzAlign = "center";
    self.secretTimer.vertAlign = "bottom";
    self.secretTimer.x = 0;
    self.secretTimer.y = -7;
    self.secretTimer.sort = 5;
    self.secretTimer.fontScale = 1.6;
    self.secretTimer.font = "default";
    self.secretTimer.glowAlpha = 1;
    self.secretTimer.hidewheninmenu = true;
       self.secretTimer.label = &"Time in left: &&1";
       
    if(isdefined(level.randomcolor))
        self.secretTimer.glowColor=level.randomcolor;
    else
        self.secretTimer.glowColor=(1,0,0);
 
    for(i=0;i<120;i++)
    {
        self.secretTimer setvalue(120-i);
        wait 1;
    }
    self.secretTimer setvalue(0);
    self suicide();
 
    if(isdefined(self.secretTimer))
        self.secretTimer destroy();
}


moveActiCar()
{
	car = getent("Trapmoving1","targetname");
	trigger1 = getent("trapmover1", "targetname");
	trigger2 = getent("deserttrap1", "targetname");
	trigger3 = getent("deserttrap2", "targetname");

	for(;;)
	{
		trigger1 waittill("trigger", who);
		trigger1 delete();
		car movex(1853,3,1,1);
		wait 3;
		trigger2 waittill("trigger", who);
		trigger2 delete();
		car movex(512, 1,.4,.4);
		wait 1;
		car movex(160,2,1,1);
		car rotateyaw(90,2,1,1);
		wait 1;
		car movey(1248,2,1,1);
		wait 2;
		trigger3 waittill("trigger", who);
		trigger3 delete();
	}
}