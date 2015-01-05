BEGIN ~K#TELSPL~

IF ~  True()
~ THEN BEGIN 0
  SAY @1000500 /* ~Choose destination area:~ */
  IF ~~ THEN REPLY @1000501 /* ~Stay in current area~ */ DO ~DestroySelf()
~ EXIT
  //IF ~~ THEN REPLY @2 GOTO 1
END
