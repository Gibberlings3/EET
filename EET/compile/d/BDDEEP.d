//Disable response to Brother Deepvein regarding his dwarves joining the army against crusade if chapter > 9
ADD_TRANS_TRIGGER BDDEEP 80 ~GlobalLT("Chapter","GLOBAL",10)~ /*DO 0 1 2 3*/
EXTEND_BOTTOM BDDEEP 80
IF ~GlobalGT("Chapter","GLOBAL",9)~ THEN REPLY #263734 /* ~Don't look to me for answers. I've none to give.~ */ DO ~AddJournalEntry(267500,QUEST_DONE)
AddJournalEntry(264670,INFO)
~ GOTO 82
END
