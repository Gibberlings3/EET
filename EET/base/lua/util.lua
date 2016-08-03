-- return true if we need to use the string literal escape format
function needsEscape(value)
    if value:find("['\n]") then
        return true
    end
    return false
end

--Write ini out.
function printIni(fp)
	for section, option in pairs(options) do
		for key, value in pairs(option) do
			local out
			if needsEscape(value) then
				out = "SetPrivateProfileString('" .. section .. "','" .. key .. "',[[" .. value .. "]])\n"
			else
				out = "SetPrivateProfileString('" .. section .. "','" .. key .. "','" .. value .. "')\n"
			end
			Infinity_WriteINILine(fp,out)
		end
	end 
end

function initLanguage(locale, credits, notes, name)
	if(languages[locale] ~= nil) then languages[locale] = {credits,notes,name} end
end

function displaySubtitles(frame, name)
	for index, movie in pairs(movies) do
		if((frame > movie[2]) and (frame < movie[3]) and (movie[1] == name)) then
			Chitin_DisplaySubtitles(movie[4],movie[5],movie[6])
		end
	end 
end

function loadBindings()
	for catIndex, cat in pairs(keybindings) do
		for keyIndex, key in pairs(cat) do
			local keyValue = Infinity_GetINIValue(keycategories[key[2]][3], key[3], key[7]) --get the ini value, defaulting to array value.
			keybindings[catIndex][keyIndex][6] = keyValue --Set the key in luas memory.
			Infinity_SetKey(keyValue,key[1])	--Set the key in C++ memory.
		end
	end 
end

function setKey(newValue)
	--Resolve conflicts.
	for catIndex, cat in pairs(keybindings) do 
		for keyIndex, curKey in pairs(cat) do
			if ( curKey[6] == newValue ) then --If old key has new value, set it to 0.
				keybindings[catIndex][keyIndex][6] = 0
				Infinity_SetKey(0,curKey[1])	--Set the key in C++ memory.
				Infinity_SetINIValue(keycategories[curKey[2]][3], curKey[3], 0) --Set the key in the ini.

			end
		end
	end 
	keybindings[keyCategory][key][6] = newValue --Set the key in luas memory.
	local chKey = keybindings[keyCategory][key]
	if(newValue ~= keybindings[keyCategory][key][7]) then
		Infinity_SetINIValue(keycategories[chKey[2]][3], chKey[3], newValue) --Set the key in the ini.
	else
		Infinity_RemoveINIEntry(keycategories[chKey[2]][3], chKey[3]) --Key is default, remove it from ini.
	end
	Infinity_SetKey(newValue,chKey[1])	--Set the key in C++ memory.
	
	key = 0 --deselect.
end

function revertKeymap()
	for catIndex, cat in pairs(keybindings) do
		for keyIndex, key in pairs(cat) do
			local default = key[7]
			Infinity_RemoveINIEntry(keycategories[key[2]][3],key[3])
			keybindings[catIndex][keyIndex][6] = default --Set the key in luas memory.
			Infinity_SetKey(default,key[1])	--Set the key in C++ memory.
		end
	end 
end
function findKeyNameById(id)
	for catIndex, cat in pairs(keybindings) do
		for keyIndex, key in pairs(cat) do
			if(key[1] == id) then
				return key[4]
			end
		end
	end
	return 0
end
function keyExists(name, col)
	for catIndex, cat in pairs(keybindings) do
		for keyIndex, key in pairs(cat) do
			--We could constrain the search here by checking category id.
			if(key[col] == name) then
				return 1
			end
		end
	end
	return 0
end
function checkEntryComplete(journalId, stateType)
	--Check if a journal entry is part of a quest that's already complete
	
	--If anything other than an unfinished entry return false.
	if(stateType ~= const.ENTRY_TYPE_INPROGRESS) then return false end
	
	--Check if my quest is marked complete.
	local questIndex = entryToQuest[journalId]
	local quest = quests[questIndex]
	if (quest and quest.stateType == const.ENTRY_TYPE_COMPLETE) then
		return 1
	else
		return 0
	end
end

function initQuestsOld()
	--All quest states set to 0
	for index, quest in pairs(quests) do
		quests[index][const.QUEST_IDX_STATE] = 0
	end

	--First quest starts enabled.
	quests[1][const.QUEST_IDX_STATE] = const.ENTRY_TYPE_INPROGRESS
	
	--All entry states set to 0
	for index, entry in pairs(journals_quests) do
		journals_quests[index][const.ENTRIES_IDX_STATE] = 0
	end
	buildJournalTable()
	updateDisplayJournal()
	
	info = {}
	user = {}
	textflashes = {}
end
--Build a table that we can access by strref in constant time.
function buildJournalTable()
	for index,entry in pairs(journals_quests) do
		journal[entry[const.ENTRIES_IDX_STRREF]] = entry
	end
end
--Update a journal entry by the strref/journalId
function updateJournalEntryOld(journalId, recvTime, stateType, chapter, timeStamp)
	
	if(stateType == const.ENTRY_TYPE_USER) then
		addUserEntry(journalId, recvTime, chapter, timeStamp)
		return
	end
	if(stateType == const.ENTRY_TYPE_INFO) then
		addInfoEntry(journalId, recvTime, chapter, timeStamp)
		return
	end
	if(journal[journalId] == nil) then
		return --This will skip entries handled by old UI (journal)
	end
	local questIndex = journal[journalId][const.ENTRIES_IDX_QUEST]
	
	-- go through all journal entries and check for subgroup as per [Feature #4204]
	if(stateType == const.ENTRY_TYPE_COMPLETE and journal[journalId][const.ENTRIES_IDX_SUBGROUP] ~= 0) then
		for index, entry in pairs(journal) do
			--If current is done, then close all existing entries.
			if (entry[const.ENTRIES_IDX_SUBGROUP] == journal[journalId][const.ENTRIES_IDX_SUBGROUP]) then
				journal[index][const.ENTRIES_IDX_STATE] = const.ENTRY_TYPE_NONE
			end
			--Below code didn't do anything (stateType can't be 1 here), but it might need to be implemented elsewhere?
			--If current is unfinished, check for done, and don't add if done.
			--if(stateType == 1 and entry[4] == journal[journalId][4] and entry[3] == 2) then
			--	return
			--end
		end
	end
	
	if(stateType ~= const.ENTRY_TYPE_NONE) then
		journal[journalId][const.ENTRIES_IDX_STATE] = stateType
	end
	if(timeStamp ~= "") then
		journal[journalId][const.ENTRIES_IDX_TIMESTAMP] = timeStamp
	end
	if(chapter ~= -1) then
		quests[questIndex][const.QUEST_IDX_CHAPTER] = chapter
	end
	if(recvTime ~= -1) then
		journal[journalId][const.ENTRIES_IDX_RECV] = recvTime
		quests[questIndex][const.QUEST_IDX_RECV] = recvTime
	end
	
	updateQuestState()
	updateDisplayJournal()
end

--Derive the quest states from journal entries
function updateQuestState()
	for index, entry in pairs(quests) do
		--By default, quests are off.
		quests[index][const.QUEST_IDX_STATE] = const.ENTRY_TYPE_NONE
	end
	for index, entry in pairs(journal) do
		local questIndex = entry[const.ENTRIES_IDX_QUEST]
		local stateType = entry[const.ENTRIES_IDX_STATE]
		if(stateType == const.ENTRY_TYPE_COMPLETE) then
			--If an entry is marked done, corresponding quest is done.
			quests[questIndex][const.QUEST_IDX_STATE] = const.ENTRY_TYPE_COMPLETE
		end
		if(stateType == const.ENTRY_TYPE_INPROGRESS and quests[questIndex][const.QUEST_IDX_STATE] ~= const.ENTRY_TYPE_COMPLETE) then
			--If an entry is in progress, and quest is not marked done, quest is in progress.
			quests[questIndex][const.QUEST_IDX_STATE] = const.ENTRY_TYPE_INPROGRESS
		end
	end
end

--Add an info entry.
function addInfoEntry(journalId, recvTime, chapter, timeStamp)
	info[journalId] = {journalId, timeStamp, const.ENTRY_TYPE_INFO, chapter, recvTime}
	updateDisplayJournal()
end
--Add a user entry.
function addUserEntry(journalId, recvTime, chapter, timeStamp)
	user[journalId] = {journalId, timeStamp, const.ENTRY_TYPE_USER, chapter, recvTime}
	updateDisplayJournal()
end
function removeJournalEntry(id)
	local quest = quests[entryToQuest[id]]
	if(not quest) then return end
	for k,objective in pairs(quest.objectives) do
		for k2,entry in pairs(objective.entries) do
			if(entry.id == id) then
				Infinity_Log("remove entry" .. id)
				entry.stateType = const.ENTRY_TYPE_NONE
				objective.stateType = const.ENTRY_TYPE_NONE
			end
		end
	end
	buildQuestDisplay()
end
function removeUserEntry(id)
	for k,v in pairs(userNotes) do
		if(v.text == id) then
			userNotes[k] = nil
		end
	end
	buildQuestDisplay()
end
function highlightJournalButton(journalId)
	local questId = entryToQuest[journalId]
	if(questId == 1) then --if from main quest.
		Infinity_HighlightJournalButton()
	end
end

function clearSessionsBefore(updated)
	for key, value in pairs(mp_sessions) do
		if(value['updated_at'] < updated) then
			--Delete the entry.
			mp_sessions_jid[value['jid']] = nil
			mp_sessions[key] = nil
		end
	end

	for key2, value2 in pairs(mp_shownSessions) do
		if value2['updated_at'] < updated then
			mp_shownSessions[key2] = nil
		end
	end
end

--in-place quicksort
function quicksort(t, start, endi, sorti)
	--partition w.r.t. first element
	if(endi - start < 1) then return t end
	local pivot = start
	-- for i = start + 1, endi do
	i = start + 1
	while ( i < endi ) do
		if (t[i][sorti] <= t[pivot][sorti]) then
			local temp = t[pivot + 1]
			t[pivot + 1] = t[pivot]
			if(i == pivot + 1) then
				t[pivot] = temp
			else
				t[pivot] = t[i]
				t[i] = temp
			end
			pivot = pivot + 1
		end
		i = i + 1
	end
	t = quicksort(t, start, pivot - 1, sorti)
	return quicksort(t, pivot + 1, endi, sorti)
end

function length(t)
	return #t
end

function showTextFlash(title, str, displayTime)
	if #textflashes == 0 then
		textflashidx = 1
	end
	local fullStr = Infinity_FetchString(str)
	local splitLines = string.gmatch(fullStr, "[^\r\n]+")
	local line1 = splitLines()
	local line2 = splitLines()
	if(line2 == nil) then return end
	textflashes[textflashidx] = {title, line1, line2, displayTime, str}
	textflashidx = textflashidx + 1
end

function inOutExpo(t, b, c, d)
	if t == 0 then return b end
	if t == d then return b + c end
	t = t / d * 2
	if t < 1 then
		return c / 2 * (2 ^ (10 * (t - 1))) + b - c * 0.0005
	else
		t = t - 1
		return c / 2 * 1.0005 * (-(2 ^ (-10 * t)) + 2) + b
	end
end

function fadeInOut(t, startTime, rampTime, showTime)
	if t < startTime then
		return 0
	elseif t > startTime + showTime + rampTime * 2 then
		return 0
	end

	if t < startTime + rampTime then -- fade In
		local dt = (t - startTime) / rampTime
		return inOutExpo(dt, 0, 1, 1)
	elseif t > startTime + rampTime + showTime then -- fade out
		local dt = (t - (startTime + rampTime + showTime)) / rampTime
		return 1 - inOutExpo(dt, 0, 1, 1)
	else -- opaque
		return 1
	end
end

--- Journal update functions
function updateDisplayJournal()
	if(state == const.JOURNAL_STATE_INPROGRESS or state == const.JOURNAL_STATE_COMPLETE) then
		updateDisplayTitles(quests,const.QUEST_IDX_STATE, const.QUEST_IDX_CHAPTER, const.QUEST_IDX_RECV)
		updateDisplayEntries()
		return
	end
	if (state == const.JOURNAL_STATE_USER) then
		updateDisplayTitles(user,const.USER_IDX_STATE, const.USER_IDX_CHAPTER, const.USER_IDX_RECV)
		return
	end
	if (state == const.JOURNAL_STATE_INFO) then
		updateDisplayTitles(info, const.INFO_IDX_STATE, const.INFO_IDX_CHAPTER, const.INFO_IDX_RECV)
		return
	end
end
-- update a table of quests based on the current state.
function updateDisplayTitles(source, stateIdx, chapterIdx, recvIdx)
	titles_display = {}
	local tabIndex = 1
	for index, entry in pairs(source) do
		if (entry[stateIdx] == state) and (entry[chapterIdx] == chapter)  then --if quest matches our state and chapter.
			titles_display[tabIndex] = entry
			tabIndex = tabIndex + 1
		end
	end
	--Sort, with important events at the top if applicable.
	table.sort(titles_display, function(a,b) if(a[const.IDX_IMPORTANT] == 1 or b[const.IDX_IMPORTANT] == 1) then return (a[const.IDX_IMPORTANT] == 1); else return a[recvIdx] > b[recvIdx] end end)
end

--update a string for the entries to display
function updateDisplayEntries()
	local displayTab = {}
	local displayTabInd = 1
	entries_display = ""
	if( (selectedQuest == 0) or (selectedQuest > #titles_display)) then
		return
	end
	for index, entry in pairs(journal) do
		--if selected quests id matches entries questid and state matches current
		if ((entry[const.ENTRIES_IDX_QUEST] == titles_display[selectedQuest][const.QUEST_IDX_ID]) and (entry[const.ENTRIES_IDX_STATE] == state)) then
			displayTab[displayTabInd] = entry -- put into a table
			displayTabInd = displayTabInd + 1 
		end
	end
	quicksort(displayTab, 1, displayTabInd, const.ENTRIES_IDX_RECV) -- sort by time recieved.
	local index = displayTabInd - 1
	while index >= 1 do --go through in order, we can assume index 1 .. n exists since we just built the table.
		entries_display = entries_display .. displayTab[index][const.ENTRIES_IDX_TIMESTAMP] .. '\n' .. Infinity_FetchString(displayTab[index][const.ENTRIES_IDX_STRREF]) .. '\n\n' --add to string
		index = index - 1
	end
end


function getTitleText(rowNumber)
	if (state == const.JOURNAL_STATE_INPROGRESS or state == const.JOURNAL_STATE_COMPLETE) then
		--quests and completed quests
		return Infinity_FetchString(titles_display[rowNumber][const.QUEST_IDX_STRREF])
	end
	--user entries.
	if(state == const.JOURNAL_STATE_USER) then
		local text = Infinity_FetchString(titles_display[rowNumber][const.USER_IDX_STRREF])
		local newlineIdx = string.find(text,"\n")
		if(newlineIdx) then
			text = string.sub(text,1,string.find(text,"\n")-1)
		end
		if(string.len(text) < 25) then
			return text
		else
			return string.sub(text,1,24) .. "..."
		end
	end
	--info entries. display timestamp as title
	if(state == const.JOURNAL_STATE_INFO) then
		return titles_display[rowNumber][const.INFO_IDX_TIMESTAMP]
	end
end

function getEntriesText()
	if (state == const.JOURNAL_STATE_INPROGRESS or state == const.JOURNAL_STATE_COMPLETE) then
		--quests and completed quests
		return entries_display
	end
	if((state == const.JOURNAL_STATE_USER) and titles_display[selectedQuest]) then
		--Show timestamp with user entry text, since its not in the title
		return titles_display[selectedQuest][const.USER_IDX_TIMESTAMP] .. "\n" .. Infinity_FetchString(titles_display[selectedQuest][const.USER_IDX_STRREF])
	end
	if((state == const.JOURNAL_STATE_INFO) and titles_display[selectedQuest]) then
		return Infinity_FetchString(titles_display[selectedQuest][const.INFO_IDX_STRREF])
	end
	return ""
end

function toggleDoneState()
	if (state == const.JOURNAL_STATE_INPROGRESS) then
		state = const.JOURNAL_STATE_COMPLETE
	else
		state = const.JOURNAL_STATE_INPROGRESS
	end
	updateDisplayJournal()
	if(#titles_display > 0) then
		selectedQuest = 1
	else
		selectedQuest = 0
	end
end

function setDoneState(newState)
	state = newState
	updateDisplayJournal()
end

function incrChapter(amount)
	local minChapter = 1
	
	if(game:GetMissionPackInfoTBP()) then
		--Black pits uses chapter 0
		minChapter = 0
	end
	
	if ( ((chapter + amount) > Infinity_GetMaxChapterPage()) or ((chapter + amount) < minChapter ) ) then
		return
	end
	chapter = chapter + amount
end

function doneText()
	if (state == const.JOURNAL_STATE_INPROGRESS) then
		return t("DONE_QUESTS_BUTTON")
	else
		return t("QUESTS_BUTTON")
	end
end

function chapterText()
	if(chapter < 0) then
		chapter = Infinity_GetMaxChapterPage()
		updateDisplayJournal()
	end
	if (chapter < 8) then
		return Infinity_FetchString(16202 + chapter)
	elseif (chapter == 8) then
		return t('EET_CHAPTER_8')
	elseif (chapter == 9) then
		return t('EET_CHAPTER_9')
	elseif (chapter == 10) then
		return t('EET_CHAPTER_10')
	elseif (chapter == 11) then
		return t('EET_CHAPTER_11')
	elseif (chapter == 12) then
		return t('EET_CHAPTER_12')
	elseif (chapter == 13) then
		return Infinity_FetchString(74414)
	elseif (chapter == 14) then
		return Infinity_FetchString(74412)
	elseif (chapter == 15) then
		return Infinity_FetchString(74390)
	elseif (chapter == 16) then
		return Infinity_FetchString(74407)
	elseif (chapter == 17) then
		return Infinity_FetchString(74399)
	elseif (chapter == 18) then
		return Infinity_FetchString(74400)
	elseif (chapter == 19) then
		return Infinity_FetchString(74353)
	elseif (chapter < 23) then
		return Infinity_FetchString(71000 + chapter)
	else
		return t("ARENA_MODE_LABEL")
	end
end

function setSelectedQuest(id)
	--set to the correct state
	local quest = quests[entryToQuest[id]]
	if(not quest) then return end
	for k,objective in pairs(quest.objectives) do
		for k2,entry in pairs(objective.entries) do
			if(entry.id == id) then
				if(entry.stateType == const.ENTRY_TYPE_USER or entry.stateType == const.ENTRY_TYPE_INFO) then
					journalMode = const.JOURNAL_MODE_JOURNAL
				else
					journalMode = const.JOURNAL_MODE_QUESTS
				end
				return
			end
		end
	end
	updateDisplayJournal()
end

function getDisplayQuestComplete()
	local tf = next(textflashes)
	if( tf == nil ) then
		return 0
	end
	local journalId = textflashes[tf][5]
	if(journal[journalId] == nil) then
		return 0
	end
	if ( journal[journalId][3] == 2 ) then
		return 1
	else
		return 0
	end
end
function getOpacityForInfoBlock(rampTime)
	local tf = next(textflashes)

	if tf then
		local time = Infinity_GetGameTicks()
		local v = textflashes[tf]
		if v[6] == nil then
			v[6] = time
		end
		local t = fadeInOut(time, v[6], rampTime, v[4])
		if time > v[6] + v[4] + rampTime*2 then
			textflashes[tf] = nil
		end
		return t
	else
		return 0
	end
end

function getTitleString()
	local tf = next(textflashes)

	if tf then
		return Infinity_FetchString(textflashes[tf][1])
	else
		return ''
	end
end
function getSubtitleString()
	local tf = next(textflashes)

	if tf then
		return textflashes[tf][2]
	else
		return ''
	end
end
function getBodyString()
	local tf = next(textflashes)

	if tf then
		return textflashes[tf][3]
	else
		return ''
	end
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function uniqueFromTable(t, idx)
	local out = {}
	local tmp = {}
	for k, v in pairs(t) do
		tmp[v[idx]] = v
	end
	for _, v in pairs(tmp) do
		table.insert(out, v)
	end

	return out
end

-- filter(function, table)
-- e.g: filter(is_even, {1,2,3,4}) -> {2,4}
function filter(func, tbl)
	local newtbl= {}
	for i,v in ipairs(tbl) do
		if func(v) then
			table.insert(newtbl, v)
		end
	end
	return newtbl
end

function popupInfo(info)
	TEXT_popup_info = info
	Infinity_PushMenu("POPUP_INFO")
end
function popup2Button(info, okText, okFunc, cancelText, cancelFunc)
	Popup2Button = {
		info = info,
		okFunc = okFunc,
		okText = okText,
		cancelFunc = cancelFunc,
		cancelText = cancelText,
	}

	Infinity_PushMenu("POPUP_TWOBUTTON")
end

function popup3Button(info, leftText, leftFunc, midText, midFunc, rightText, rightFunc)
	Popup3Button = {
		info = info,
		leftText = leftText,
		leftFunc = leftFunc,
		midText = midText,
		midFunc = midFunc,
		rightText = rightText,
		rightFunc = rightFunc,
	}

	Infinity_PushMenu("POPUP_THREEBUTTON")
end
function popup4Button(info, farLeftText, farLeftFunc, leftText, leftFunc, rightText, rightFunc, farRightText, farRightFunc)
	Popup4Button = {
		info = info,
		farLeftText = farLeftText,
		farLeftFunc = farLeftFunc,
		leftText = leftText,
		leftFunc = leftFunc,
		rightText = rightText,
		rightFunc = rightFunc,
		farRightText = farRightText,
		farRightFunc = farRightFunc,
	}

	Infinity_PushMenu("POPUP_FOURBUTTON")
end

function popupDetails(title, name, description, icon)
	PopupDetails = {
		title = title,
		name = name,
		description = description,
		icon = icon
	}

	Infinity_PushMenu("POPUP_DETAILS")
end
function popupRequester (maxCount, func, selling)
	requester.requesterMax = maxCount
	requester.requesterFunc = func
	requester.selling = selling
	Infinity_PushMenu('POPUP_REQUESTER',0,0)
end
function pushSidebars()
	Infinity_PushMenu('RIGHT_SIDEBAR',0,0)
	Infinity_PushMenu('LEFT_SIDEBAR',0,0)
end
function popSidebars()
	Infinity_PopMenu('RIGHT_SIDEBAR',0,0)
	Infinity_PopMenu('RIGHT_SIDEBAR_HIDDEN',0,0)
	Infinity_PopMenu('LEFT_SIDEBAR',0,0)
	Infinity_PopMenu('LEFT_SIDEBAR_HIDDEN',0,0)
end
function greySidebars()
	sidebarsGreyed = 1
end

function ungreySidebars()
	sidebarsGreyed = 0
end
function getTooltipWithHotkey(hotkeyIndex, tooltipRef)
	return CInfToolTip:FormatTooltipPrefix("",hotkeyIndex,0xffff) .. Infinity_FetchString(tooltipRef)
end
function chatboxScroll(top, height, contentHeight)
	if(chatboxScrollToBottom and contentHeight > height) then
		chatboxScrollToBottom = nil
		return height-contentHeight
	else
		--defer to default
		return nil
	end
end
--its not ideal to have a different function just to check a different var, but i prefer it to piping
--through an identifier to the scroll functions. if this comes up again then a refactor is called for.
function mpChatboxScroll(top, height, contentHeight)
	if(mpChatboxScrollToBottom and contentHeight > height) then
		mpChatboxScrollToBottom  = nil
		return height-contentHeight
	else
		--defer to default
		return nil
	end
end
function resetScrollbar(top, height, contentHeight)
	if(scrollbarReset) then
		scrollbarReset = nil
		return 0
	else
		--defer to default
		return nil
	end
end

function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            Infinity_Log(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        Infinity_Log(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        Infinity_Log(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        Infinity_Log(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                Infinity_Log(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end


function autopickMageSpells()
    -- choose all our specialist spells
    for k,v in pairs(chargen.choose_spell) do
        spell = mageSpells[chargen.currentSpellLevelChoice][v.key]
        if spell.specialist and chargen.extraSpells > 0 then
            createCharScreen:OnLearnMageSpellButtonClick(k)
        end
    end
    -- choose any remaining auto pick spells
    for k, v in pairs(chargen.choose_spell) do
        spell = mageSpells[chargen.currentSpellLevelChoice][v.key]
        if not v.enabled and spell.autopick and chargen.extraSpells > 0 then
            createCharScreen:OnLearnMageSpellButtonClick(k)
        end
    end
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function getFileNameStringRef(rowNumber, tab)
	if ( filenames_stringrefs[tab[rowNumber]] ~= nil ) then
		return Infinity_FetchString(filenames_stringrefs[tab[rowNumber]][1])
	else
		return tab[rowNumber]
	end
end


function currentCellCheck(cellNum)
	if cellNumber == cellNum and rowSelected == rowNumber then
		return 1
	else
		return 0
	end
end
function plusButtonClickable(row)
	local clickable =  (chargen.proficiency[row].value < chargen.proficiency[row].max)
	clickable = clickable and chargen.extraProficiencySlots > 0
	return clickable
end
function minusButtonClickable(row)
	return (chargen.proficiency[row].value > chargen.proficiency[row].min)
end
function getPlusFrame(cellNum)
	if (not plusButtonClickable(rowNumber)) then
		return 3
	else
		return currentCellCheck(cellNum)
	end
end
function getMinusFrame(cellNum)
	if (not minusButtonClickable(rowNumber)) then
		return 3
	else
		return currentCellCheck(cellNum)
	end
end


function sortBySpellName(a, b)
	local aName = Infinity_FetchString(spellBook[chargen.currentSpellLevelChoice][a.key].name)
	local bName = Infinity_FetchString(spellBook[chargen.currentSpellLevelChoice][b.key].name)
	return string.lower(aName) < string.lower(bName)
end
function sortByMageSpellName(a, b)
	local aName = Infinity_FetchString(mageSpells[chargen.currentSpellLevelChoice][a.key].name)
	local bName = Infinity_FetchString(mageSpells[chargen.currentSpellLevelChoice][b.key].name)
	return string.lower(aName) < string.lower(bName)
end
function sortByPriestSpellName(a, b)
	local aName = Infinity_FetchString(priestSpells[chargen.currentSpellLevelChoice][a.key].name)
	local bName = Infinity_FetchString(priestSpells[chargen.currentSpellLevelChoice][b.key].name)
	return string.lower(aName) < string.lower(bName)
end

stringTokens = {}
function t(stringName)
	if(not uiStrings[stringName]) then
		Infinity_Log("UI string not found: " .. stringName) 
		uiStrings[stringName] = stringName
	end
	local returnString = uiStrings[stringName]
	if #(stringTokens) > 0 then
		returnString = processStringTokensLua(uiStrings[stringName])
	end
	return returnString
end
function processStringTokensLua(stringToProcess)
	--print("Processing string "..stringToProcess)
	for k,v in pairs(stringTokens) do
		stringToProcess = string.gsub(stringToProcess, v[1], v[2])
	end
	return stringToProcess
end
function setStringTokenLua(tokenName,tokenValue)
	local found = false
	for k,v in pairs(stringTokens) do
		if v[1] == tokenName then
			v[2] = tokenValue
			found = true
			break
		end
	end

	if found == false then
		local newToken = {tokenName,tokenValue}
		table.insert(stringTokens,newToken)
	end
end
function removeStringTokenLua(tokenName)
	local tokenIndex = 1
	for tokenIndex = 1, #(stringTokens), 1 do
		if stringTokens[tokenIndex][1] == tokenName then
			table.remove(stringTokens, tokenIndex)
			break
		end
	end
end

function adjustItemGroup(group, xDelta, yDelta, wDelta, hDelta)
	for k,itemName in pairs(group) do
		local xOld,yOld,wOld,hOld = Infinity_GetArea(itemName)
		Infinity_SetArea(itemName, xOld + xDelta, yOld + yDelta, wOld + wDelta, hOld + hDelta)
	end
end
function highlightString(s, pat, color)
	local sIdx,eIdx = string.find(string.lower(s),string.lower(pat))
	local endTag = "^-"
	while(sIdx) do
		s = string.sub(s,1,sIdx-1) .. color .. string.sub(s,sIdx,eIdx) .. endTag .. string.sub(s,eIdx+1)
		sIdx, eIdx = string.find(string.lower(s),string.lower(pat),eIdx + #endTag + #color + 1)
	end
	return s
end

--journal builder functions
function findQuest(questId)
	for k,v in pairs(quests) do
		if(v.text == questId) then return v end
	end
end
function findObjective(objectiveId, questId)
	local quest = findQuest(questId)
	if(not quest) then return nil end
	for k,v in pairs(quest.objectives) do
		if(v.text == objectiveId) then return v end
	end
end
function createQuest(questId)
	local quest = {}
	quest.text = questId
	quest.objectives = {}
	table.insert(quests,quest)
end
function createObjective(questId, objectiveId)
	--TODO objective data
	--for now, just build the objectives out of entries.
	--some time in the future objectives will have their own data, allowing them to have unique text, multiple entries, state .. etc
	
	--local quest = findQuest(questId)
	--if(not quest) then
	--	Infinity_Log("Quest not found. Failed to create objective: " .. objectiveId .. " for quest: " .. questId)
	--	return
	--end
	--local objective = {}
	--objective.text = objectiveId
	--objective.entries = {}
	--table.insert(quest.objectives,objective)
end
function createEntry(questId, objectiveId, entryId, previousObjectives, subGroup)
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

function getStringFromAmbiguousSource(stringReference)
	local ret = ""
	
	if tonumber(stringReference) == nil then
		ret = t(stringReference)
	else
		ret = Infinity_FetchString(stringReference)
	end

	return ret
end