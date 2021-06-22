function generateBioText(t)
	t = t or chargen
	bioClass = ""
	bioRace = ""
	local myRace = t.races[currentChargenRace].id
	local myClass = t.class[currentChargenClass].id
	local myKit = -1
	if t.kit[currentChargenKit] ~= nil then
		myKit = t.kit[currentChargenKit].id
	end
	local colClass = 2 + Infinity_GetINIValue('Program Options','Active Campaign')
	local colRace = 1 + Infinity_GetINIValue('Program Options','Active Campaign')
	-- Go through each row of bioClassData
	for i = 1, #bioClassData do
		-- Check chargen.class and chargen.kit to find a match against the current row 
		if myClass == bioClassData[i][1] and myKit == bioClassData[i][2] then
			-- On match, set bioClass string equal to bioClassData text
			bioClass = Infinity_FetchString(bioClassData[i][colClass])
		end
	end
	-- Go through each row of bioRaceData
	for i = 1, #bioRaceData do
		-- Check chargen.race to find a match against the current row
		if myRace == bioRaceData[i][1] then
			-- On match, set bioRace string equal to bioRaceData text
			bioRace = Infinity_FetchString(bioRaceData[i][colRace])
		end
	end
end

-- -- -- -- --
-- UTIL.LUA --
-- -- -- -- --

-- new Textflash showTextflash function to override the one in util.lua changing the displayTime
showTextFlash = function (title, str, displayTime)
	if #textflashes == 0 then
		textflashidx = 1
	end
	local fullStr = Infinity_FetchString(str)
	local splitLines = string.gmatch(fullStr, "[^\r\n]+")
	local line1 = splitLines()
	local line2 = splitLines()
	if(line2 == nil) then return end
	fps = Infinity_GetINIValue('Program Options','Maximum Frame Rate')
	textflashes[textflashidx] = {title, line1, line2, displayTime * (fps / 30), str}
	textflashidx = textflashidx + 1
end

--increase chapter variable
function incrChapter(amount)
	if ( ((chapter + amount) > Infinity_GetMaxChapterPage()) or ((chapter + amount) < 0 ) ) then
		return
	end
	chapter = chapter + amount
end

--journal chapter labels
chapterText = function ()
	if(chapter < 0) then
		chapter = Infinity_GetMaxChapterPage()
		updateDisplayJournal()
	end
	if (currentCampaign == const.START_CAMPAIGN_BP1) or (currentCampaign == const.START_CAMPAIGN_BP2) then
		return t("ARENA_MODE_LABEL")
	elseif (chapter == 0) then
		return Infinity_FetchString(216202)
	elseif (chapter < 23) then
		return eetStrings.EET_CHAPTER .. chapter
	else
		return Infinity_FetchString(-1)
	end
end
