ADD_STATE_TRIGGER ~WINSKI~ 0 ~Global("ENDOFBG1","GLOBAL",0)~
//REPLACE_STATE_TRIGGER ~WINSKI~ 0 ~Global("ENDOFBG1","GLOBAL",0)~

APPEND ~WINSKI~

IF ~  Global("ENDOFBG1","GLOBAL",1)
~ THEN BEGIN n0
  SAY @1000200 /* ~So... you killed him, did you?  I didn't know who would be the victor, but I should have assumed it would be you.  You were the thorn in his side all along, and his victory would have been hollow anyway.~ */
  IF ~~ THEN GOTO n1
END

IF ~~ THEN BEGIN n1
  SAY @1000201 /* ~Just leave me here.  I... I don't have any more drive left.  Let the damn Fist come for me. I don't care anymore.~ */
  IF ~~ THEN EXIT
END

END
