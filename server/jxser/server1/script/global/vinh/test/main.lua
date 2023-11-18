IncludeLib("FILESYS")
IncludeLib("TITLE");
IncludeLib("ITEM");
IncludeLib("TIMER");
IncludeLib("FILESYS");
IncludeLib("SETTING");
IncludeLib("TASKSYS")
IncludeLib("PARTNER");
IncludeLib("BATTLE");
IncludeLib("RELAYLADDER")
IncludeLib("TONG")
IncludeLib("LEAGUE")

Include("\\script\\lib\\remoteexc.lua")
Include("\\script\\lib\\common.lua");
Include("\\script\\lib\\string.lua" );
Include("\\script\\lib\\log.lua")
Include("\\script\\lib\\awardtemplet.lua")

Include("\\script\\activitysys\\playerfunlib.lua")
Include("\\script\\misc\\eventsys\\type\\npc.lua")
Include("\\script\\dailogsys\\dailogsay.lua");
Include("\\script\\activitysys\\functionlib.lua")
Include("\\script\\activitysys\\npcdailog.lua")
Include("\\script\\global\\titlefuncs.lua")
Include( "\\script\\lib\\string.lua" )

Include("\\script\\global\\vinh\\simcity\\head.lua")

NPCManager = {
	currPage = 1,
	allNPCs = {},
	allManualNPCs = {},

	startNPC = 1
}


worldMap = {

}

function GetTabFileData( path, tab_name, start_row, max_col ) -- Doc file txt
    if TabFile_Load(path, tab_name) ~= 1 then return print("§äc tËp tin thÊt b¹i! " .. path) end
    if not start_row or start_row < 1 then start_row = 1 end
    if not max_col or max_col < 1 then max_col = 1 end
    local nCount = TabFile_GetRowCount(tab_name)
    local tbData = {}
    for y = start_row, nCount do
        local tbTemp = {}
        for x = 1, max_col do tinsert(tbTemp, TabFile_GetCell(tab_name, y, x)) end
        tinsert(tbData, tbTemp)
    end
    return tbData, nCount - start_row + 1
end


-- AI = 0, kind = 3 : walk smoothly and CAN click, and  APPEARS in small map
-- AI = 0, kind = 4 : walk smoothly and CANNOT click, and NOT appear in small map
-- AI = 1, kind = 0 : pk
-- Kind: 0 : anh huong cua nguoi choi xung quanh
 
-- 
 -- [ebp+nfNewFeature.m_eAvailableTimeType], 0
-- mov     [ebp+nfNewFeature.m_nAvailableTime], 0
-- mov     [ebp+nfNewFeature.m_nNpcSettingIdx], 0
-- mov     [ebp+nfNewFeature.m_nHelmType], 0
-- mov     [ebp+nfNewFeature.m_nArmorType], 0
-- fstp    [ebp+var_98]
-- mov     [ebp+nfNewFeature.m_nWeaponType], 0
-- mov     [ebp+nfNewFeature.m_nHorseType], 0FFFFFFFFh
-- mov     [ebp+nfNewFeature.m_nMantleType], 0FFFFFFFFh
-- mov     [ebp+nfNewFeature.m_eFeaturePriority], 20h ; ' '
-- mov     [ebp+nfNewFeature.m_eFeatureState], 1

function createNpc(id, nW, nX, nY, name)
	local name = name or id.." "..nW.." "..nX.." "..nY 	
	local index = AddNpc(id,random(1,4),SubWorldID2Idx(nW),nX*32,nY*32,0,name)
 	return index
end 
function testSet()
	NPCManager.currPage = 0
	Msg2Player("CurrPage: "..NPCManager.currPage)
	NPCManager:taoNPC_confirm()

end


function askNo()	 
	g_AskClientStringEx(GetStringTask(TASK_S_POSITION), 0, 256, "Ng­¬i t×m NPC nµo", {askNo_confirm})	
end


function askNo_confirm(inp)  
	local id = tonumber(inp) 
	NPCManager.currPage = id
end


function askID()	 
	--g_AskClientStringEx(GetStringTask(TASK_S_POSITION), 0, 256, "Ng­¬i t×m NPC nµo", {askID_confirm})	
	--askID_confirm(688)
	local nW, nX, nY = GetWorldPos()
	nX = nX*32
	nY = nY*32
	nW = SubWorldID2Idx(nW) 

 	local start = 739
 	local endS = 748

 	local i = 0

 	for i=start,endS do
		local id1 = AddNpcEx(i, 95, random(0,4), nW, nX - random(-2,2)*32, nY + random(-2,2)*32, 1, i , 0)
		SetNpcCurCamp(id1,random(0,5))
	end
	--SetNpcCurCamp(id3,5)
	--Msg2Player(id1)
	--Msg2Player(id2)
	--Msg2Player(id3)

end
 

function NPCManager:delAllManual()
	for i=1,getn(self.allManualNPCs) do
		DelNpc(self.allManualNPCs[i])
	end
	self.allManualNPCs = {}
end


function NPCManager:taoNPC_confirm()
	local inpNo = self.currPage * 100
	local nW, nX, nY = GetWorldPos()
	nX = nX - 5
	nY = nY - 5

	local row = 0
	local col = 0

	for i=0,100 do 
			local id = inpNo + i
			local index = createNpc(id, nW, (nX+(col*4)), (nY+(row*4)))			
			local kind = GetNpcKind(index)
			if kind == 0 then
				DelNpc(index)
			else
                Msg2Player("C "..id)
				tinsert(NPCManager.allNPCs, index)
			end
            col = col + 1
            if col > 3  then
				col = 0
				row = row + 1
			end

	end
end


function doReload()
	dofile("script/global/vinh/test/main.lua")
	--askID()
 	--SimCityKeoXe:nv_tudo_xe(1)
end


function mainTest()

	local tbData, count = GetTabFileData("\\settings\\npcs.txt", "all_npcs",1,4)
	local npcInfoData = {}
	for i=1,count do
		npcInfoData["n"..(i+2)] = {
			name = tbData[i][1],
			kind = tbData[i][2],
			camp = tbData[i][3],
			series = tbData[i][4]
		}
	end

	local item = npcInfoData.n1606
	Msg2Player(format("%s %s %s %s", item.name, item.kind, item.camp, item.series))
end

function main()
	local nW, nX, nY = GetWorldPos()

	local name = nW.." "..nX.." "..nY 

 	local tbSay = {"VINHSMOKE City"}
  
  	Earn(10000)
 	tinsert(tbSay,"Shop LB/#Sale(188)")
	tinsert(tbSay,"Reload./doReload")
    tinsert(tbSay, "KÕt thóc ®èi tho¹i./no")
    CreateTaskSay(tbSay)

 

	return 1
end

function delAll()
	NPCManager:delAll()
end

function delAllManual()
	NPCManager:delAllManual()

	local tbNpc, nCount = GetAroundNpcList(30)
	for i=1,nCount do
		DelNpc(tbNpc[i])
	end
end

function NPCManager:delAll()
	for i=1,getn(self.allNPCs) do
		DelNpc(self.allNPCs[i])
	end
    self.allNPCs = {}

end
function NPCManager:viewNext()
	self:delAll()
	self.currPage = self.currPage + 1
	Msg2Player("CurrPage: "..self.currPage)
	self:taoNPC_confirm()
end


function NPCManager:viewPrev()
	--saveWorldPos2File()
	
	self:delAll()
	self.currPage = self.currPage - 1
	Msg2Player("CurrPage: "..self.currPage)
	self:taoNPC_confirm()
end


function saveWorldPos2File()
	local nW, nX, nY = GetWorldPos()
	local name = "{"..nX..","..nY.."}," 
	local file  = openfile("./script/global/vinh/test/something.log", "a+")
 	write(file,name..'\n')
 	closefile(file)
	Msg2Player(name)
	return 1
end