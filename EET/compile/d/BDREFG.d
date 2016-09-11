//Disable refugee dialogues that suggests the crusade is still going and Shinning Lady is alive when chapter > 11
ADD_STATE_TRIGGER BDREFG1 15 ~GlobalLT("Chapter","GLOBAL",11)~ 18 20 24 25 26
ADD_STATE_TRIGGER BDREFG2 15 ~GlobalLT("Chapter","GLOBAL",11)~ 18 20 24 25 26
ADD_STATE_TRIGGER BDREFG3 15 ~GlobalLT("Chapter","GLOBAL",11)~ 18 20 24 25 26
ADD_STATE_TRIGGER BDREFG4 15 ~GlobalLT("Chapter","GLOBAL",11)~ 18 20 24 25 26
ADD_STATE_TRIGGER BDBFORT7 1 ~GlobalLT("Chapter","GLOBAL",11)~ 3

APPEND BDREFG1
IF ~GlobalGT("Chapter","GLOBAL",10)
  GlobalGT("bd_plot","global",155)
  OR(6)
    RandomNum(15,2)
    RandomNum(15,4)
    RandomNum(15,6)
    RandomNum(15,10)
    RandomNum(15,11)
    RandomNum(15,12)~ THEN BEGIN new
  SAY #255890 /* ~Forgive me, I'm not of a mind to chat at the moment.~ */
  IF ~~ THEN EXIT
END
END

APPEND BDREFG2
IF ~GlobalGT("Chapter","GLOBAL",10)
  GlobalGT("bd_plot","global",155)
  OR(6)
    RandomNum(15,2)
    RandomNum(15,4)
    RandomNum(15,6)
    RandomNum(15,10)
    RandomNum(15,11)
    RandomNum(15,12)~ THEN BEGIN new
  SAY #255890 /* ~Forgive me, I'm not of a mind to chat at the moment.~ */
  IF ~~ THEN EXIT
END
END

APPEND BDREFG3
IF ~GlobalGT("Chapter","GLOBAL",10)
  GlobalGT("bd_plot","global",155)
  OR(6)
    RandomNum(15,2)
    RandomNum(15,4)
    RandomNum(15,6)
    RandomNum(15,10)
    RandomNum(15,11)
    RandomNum(15,12)~ THEN BEGIN new
  SAY #255890 /* ~Forgive me, I'm not of a mind to chat at the moment.~ */
  IF ~~ THEN EXIT
END
END

APPEND BDREFG4
IF ~GlobalGT("Chapter","GLOBAL",10)
  GlobalGT("bd_plot","global",155)
  OR(6)
    RandomNum(15,2)
    RandomNum(15,4)
    RandomNum(15,6)
    RandomNum(15,10)
    RandomNum(15,11)
    RandomNum(15,12)~ THEN BEGIN new
  SAY #255890 /* ~Forgive me, I'm not of a mind to chat at the moment.~ */
  IF ~~ THEN EXIT
END
END

APPEND BDBFORT7
IF ~GlobalGT("Chapter","GLOBAL",10)
  OR(2)
    RandomNum(8,2)
    RandomNum(8,4)~ THEN BEGIN new
  SAY #262979 /* ~I know who you are and I'd rather not speak to you. ~ */
  IF ~~ THEN EXIT
END
END
