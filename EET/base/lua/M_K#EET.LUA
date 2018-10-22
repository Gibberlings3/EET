function generateBioText()
	bioClass = ""
	bioRace = ""
	MyRace = chargen.races[currentChargenRace].id
	MyClass = chargen.class[currentChargenClass].id
	MyKit = -1
	MyKit = chargen.kit[currentChargenKit].id
	colClass = 2 + Infinity_GetINIValue('Program Options','Active Campaign')
	colRace = 1 + Infinity_GetINIValue('Program Options','Active Campaign')
	-- Go through each row of bioClassData
	for i=1,#bioClassData,1 do
		-- Check chargen.class and chargen.kit to find a match against the current row 
		if MyClass == bioClassData[i][1] and MyKit == bioClassData[i][2] then
			-- On match, set bioClass string equal to bioClassData text
			bioClass = Infinity_FetchString(bioClassData[i][colClass])
		end
	end
	-- Go through each row of bioRaceData
	for i=1,#bioRaceData,1 do
		-- Check chargen.race to find a match against the current row
		if MyRace == bioRaceData[i][1] then
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

--little change to support both BG:EE and BG2:EE style journal entries
createEntry = function (questId, objectiveId, entryId, previousObjectives, subGroup)
	local quest = findQuest(questId)
	if(not quest) then
		Infinity_Log("Failed to create entry: " .. entryId .. "for quest: " .. questId)
		return
	end

	--parse the entry out into an objective and entry
	local entry = {}
	local objective = {}
	entry.text = ""
	entry.previousObjectives = {} --this feature will be unused for now.
	entry.id = entryId
	
	--set up this entry's subgroup
	entry.subGroup = subGroup
	if(subGroup) then
		if(not subGroups[subGroup]) then subGroups[subGroup] = {} end
		table.insert(subGroups[subGroup],entry)
	end
	
	local lineCount = 1
	local fullStr = Infinity_FetchString(entryId)
	local lineTotal = 0
	for line in string.gmatch(fullStr, "[^\r\n]+") do
		lineTotal = lineTotal + 1
	end
	for line in string.gmatch(fullStr, "[^\r\n]+") do
		if(lineTotal == 1) then --text
			--it looks like sometimes entries are just an unbroken paragraph
			--in this case the entry should get the paragraph and the objective gets nothing
			objective.text = line
			entry.text = objective.text
			objective.text = Infinity_FetchString(quest.text)
		elseif(lineTotal == 2) then --entry name + text
			if(lineCount == 1) then
				--objective text is first line.
				objective.text = line
			end
			if(lineCount > 1) then
				--entry text is everything after first
				entry.text = entry.text .. line .. "\n"
			end
		elseif(lineTotal > 2) then --entry name + objective + text
			if(lineCount == 2) then
				--objective text is second line.
				objective.text = line
			end
			if(lineCount > 2) then
				--entry text is everything after second
				entry.text = entry.text .. line .. "\n"
			end
		end
		lineCount = lineCount + 1
	end
	objective.entries = {entry}
	table.insert(quest.objectives,objective)
end

-- -- -- -- --
-- UI.MENU  --
-- -- -- -- --

--obviously theres some redundancy in this data but I dislike the idea of assuming what our frame/sequence will be.
startCampaignData = {
	{id = 'BG1', name = 'EET_CMP_TITLE_BG1', description = 'EET_CMP_TEXT_BG1', title = 0, bigLogo = 0, icon = 0, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'SOD', name = 'EET_CMP_TITLE_SOD', description = 'EET_CMP_TEXT_SOD', title = 1, bigLogo = 1, icon = 1, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'SOA', name = 'EET_CMP_TITLE_SOA', description = 'EET_CMP_TEXT_SOA', title = 2, bigLogo = 2, icon = 2, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'TOB', name = 'EET_CMP_TITLE_TOB', description = 'EET_CMP_TEXT_TOB', title = 3, bigLogo = 3, icon = 3, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'BP1', name = 'EET_CMP_TITLE_BP1', description = 'EET_CMP_TEXT_BP1', title = 4, bigLogo = 4, icon = 4, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = true, cheatAreasTable = cheatAreasArena_BP1},
	{id = 'BP2', name = 'EET_CMP_TITLE_BP2', description = 'EET_CMP_TEXT_BP2', title = 5, bigLogo = 5, icon = 5, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = true, cheatAreasTable = cheatAreasArena},
	{id = 'TUT', name = 'EET_CMP_TITLE_TUT', description = 'EET_CMP_TEXT_TUT', title = 6, bigLogo = 6, icon = 6, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreasTutorial},
}

-- class, kit, clastxtBIO: BG1, SOD, SOA, TOB, BP1, BP2, TUT, (...)
bioClassData = {
}

-- race, racetextBIO: BG1, SOD, SOA, TOB, BP1, BP2, TUT, (...)
bioRaceData = {
}

-- -- -- -- --
-- L_x.LUA  --
-- -- -- -- --

--strings used by UI.MENU file
eetStrings = {
}
