EXTEND_BOTTOM OHBJOKER 1
	IF ~Global("BLACK_PITS_VICTORY","GLOBAL",0)~ THEN REPLY @1000100 /* ~You can tell a ballad with more subtleties and nuances if you have experienced something first hand.  Listen to my story.~ */ DO ~ClearAllActions()
StartCutScene("K#CUTBP1")~ EXIT
END
