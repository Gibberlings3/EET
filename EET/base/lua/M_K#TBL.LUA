-- -- -- -- --
-- UI.MENU  --
-- -- -- -- --

--obviously theres some redundancy in this data but I dislike the idea of assuming what our frame/sequence will be.
startCampaignData = {
	{id = 'BG1', name = 'EET_CMP_TITLE_BG1', description = 'EET_CMP_TEXT_BG1', title = 0, bigLogo = 0, icon = 0, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'SOD', name = 'EET_CMP_TITLE_SOD', description = 'EET_CMP_TEXT_SOD', title = 1, bigLogo = 1, icon = 1, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'SOA', name = 'EET_CMP_TITLE_SOA', description = 'EET_CMP_TEXT_SOA', title = 2, bigLogo = 2, icon = 2, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'TOB', name = 'EET_CMP_TITLE_TOB', description = 'EET_CMP_TEXT_TOB', title = 3, bigLogo = 3, icon = 3, background = 2, button = 2, sidebar = 2, importEnabled = false, tutorialEnabled = false, forceParty = false, cheatAreasTable = cheatAreas},
	{id = 'BP1', name = 'EET_CMP_TITLE_BP1', description = 'EET_CMP_TEXT_BP1', title = 4, bigLogo = 4, icon = 4, background = 2, button = 2, sidebar = 2, importEnabled = true, tutorialEnabled = false, forceParty = true, cheatAreasTable = cheatAreasArena_BP1},
	{id = 'BP2', name = 'EET_CMP_TITLE_BP2', description = 'EET_CMP_TEXT_BP2', title = 5, bigLogo = 5, icon = 5, background = 2, button = 2, sidebar = 2, importEnabled = true, tutorialEnabled = false, forceParty = true, cheatAreasTable = cheatAreasArena},
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
