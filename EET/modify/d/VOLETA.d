ADD_STATE_TRIGGER ~VOLETA~ 0 ~Global("ENDOFBG1","GLOBAL",0)~
//REPLACE_STATE_TRIGGER ~VOLETA~ 0 ~Global("ENDOFBG1","GLOBAL",0)~

APPEND ~VOLETA~

IF ~  Global("ENDOFBG1","GLOBAL",1)
~ THEN BEGIN n0
  SAY @1000400 /* ~You're back.  I'm rather surprised you survived.  No one's ever made it through the maze before.  Well that bastard is dead, at least.  If you made it through that and back, there's no doubt he's gone, too.~ */
  IF ~~ THEN GOTO n1
END

IF ~~ THEN BEGIN n1
  SAY @1000401 /* ~I'll be fine for now.  The others will fix me up good soon enough, so just get out of here. You've caused enough trouble one way or another.~ */
  IF ~~ THEN EXIT
END

END
