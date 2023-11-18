IncludeLib("BATTLE");
IncludeLib("TITLE");
IncludeLib("ITEM");
IncludeLib("TIMER");
IncludeLib("FILESYS");
IncludeLib("SETTING");
IncludeLib("TASKSYS")
IncludeLib("PARTNER");
IncludeLib("BATTLE");
IncludeLib("RELAYLADDER");
IncludeLib("TONG");
IncludeLib("LEAGUE");
Include("\\script\\task\\system\\task_string.lua" );
Include("\\script\\task\\newtask\\newtask_head.lua");  
Include("\\script\\lib\\remoteexc.lua");
Include("\\script\\lib\\common.lua");
Include("\\script\\lib\\awardtemplet.lua");
Include("\\script\\lib\\log.lua");
Include("\\script\\activitysys\\playerfunlib.lua");
Include("\\script\\misc\\eventsys\\type\\npc.lua");
Include("\\script\\dailogsys\\dailogsay.lua");
Include("\\script\\dailogsys\\g_dialog.lua");
Include("\\script\\activitysys\\functionlib.lua");
Include("\\script\\activitysys\\npcdailog.lua");


----------https://youtube.com/c/PYTAGAMING--------------
TITLEDIALOG = "Tªn nh©n vËt : <color=green>%s<color>\n".."Tªn tµi kho¶n: <color=green>%s<color>\n".."Täa ®é       : <color=green>%d, %d/%d<color>"

function main()
	local strFaction = GetFaction()
	local nW,nX,nY = GetWorldPos();
	local tbSay = {format(TITLEDIALOG, GetName(), GetAccount() ,nW,nX,nY)};
	 
	tinsert(tbSay, "Reload/reload")

	tinsert(tbSay, "ChiÕn ®Êu/#SetFightState(1)")
	tinsert(tbSay, "§i bé/#SetFightState(0)")

	tinsert(tbSay, "Shop 166/#Sale(166)")

	--tinsert(tbSay, "Di ChuyÓn VÒ Ba L¨ng HuyÖn/GoBLH");
	--tinsert(tbSay, "Th«ng tin NPC/kiemtranpc"); 
	tinsert(tbSay, "Tho¸t./no");
	CreateTaskSay(tbSay) 
	return 1
end

 


function reload()
	dofile("script/global/vinh/items/nhanvat.lua")
	main()
end
