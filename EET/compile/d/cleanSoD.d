//Disable response to Brother Deepvein regarding his dwarves joining the army against crusade if chapter > 9
ADD_TRANS_TRIGGER BDDEEP 80 ~GlobalLT("Chapter","GLOBAL",10)~ /*DO 0 1 2 3*/
EXTEND_BOTTOM BDDEEP 80
IF ~GlobalGT("Chapter","GLOBAL",9)~ THEN REPLY #263734 /* ~Don't look to me for answers. I've none to give.~ */ DO ~AddJournalEntry(267500,QUEST_DONE)
AddJournalEntry(264670,INFO)
~ GOTO 82
END

ADD_TRANS_TRIGGER BDISABEL 1 ~GlobalLT("Chapter","GLOBAL",13)~ DO 0

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

REPLACE_TRIGGER_TEXT BDSCHAEL ~BeenInParty("Khalid")~ ~BeenInParty("Khalid") !Dead("Khalid")~
REPLACE_TRIGGER_TEXT BDSCHAEL ~BeenInParty("Jaheira")~ ~BeenInParty("Jaheira") !Dead("Jaheira")~
REPLACE_TRIGGER_TEXT BDSCHAEL ~BeenInParty("Neera")~ ~BeenInParty("Neera") !Dead("Neera")~
REPLACE_TRIGGER_TEXT BDSCHAEL ~BeenInParty("Viconia")~ ~BeenInParty("Viconia") !Dead("Viconia")~

//separate @40871 and @40872 into 4 SAY strings with additional triggers while preserving original conversation flow
REPLACE_SAY BDSCHAEL 39 @1000040
REPLACE_SAY BDSCHAEL 40 @1000043

ADD_TRANS_TRIGGER BDSCHAEL 39 ~OR(2) Dead("Dynaheir") Dead("Minsc") Dead("Rasaad")~ DO 0

EXTEND_BOTTOM BDSCHAEL 39
  IF ~!Dead("Dynaheir") !Dead("Minsc")~ THEN GOTO 39b
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc")~ THEN GOTO 39c
END

APPEND BDSCHAEL

IF ~~ THEN BEGIN 39b
  SAY @1000041 /* ~The witch Dynaheir and her bodyguard Minsc are staying at the Three Old Kegs...~ */
  IF ~!Dead("Rasaad")~ THEN GOTO 39c
  IF ~Dead("Rasaad")~ THEN GOTO 40
END

IF ~~ THEN BEGIN 39c
  SAY @1000042 /* ~...A monk named Rasaad is currently working at the Iron Throne building—the Council made it a refuge for those fleeing Caelar.~ */
  IF ~~ THEN GOTO 40
END

END

//BD0040
ADD_STATE_TRIGGER BDSCHAEL 54 ~!Dead("Dynaheir") !Dead("Minsc")~
ADD_TRANS_TRIGGER BDSCHAEL 55 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 0
ADD_TRANS_TRIGGER BDSCHAEL 60 ~!Dead("Rasaad")~ DO 4
ADD_TRANS_TRIGGER BDSCHAEL 62 ~!Dead("Rasaad")~ DO 1
ADD_TRANS_TRIGGER BDSCHAEL 63 ~!Dead("Rasaad")~ DO 2
ADD_TRANS_TRIGGER BDSCHAEL 65 ~!Dead("Rasaad")~ DO 2

//BD0020
ADD_TRANS_TRIGGER BDSCHAEL 73 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 3
ADD_TRANS_TRIGGER BDSCHAEL 73 ~!Dead("Rasaad")~ DO 4
ADD_TRANS_TRIGGER BDSCHAEL 75 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 1
ADD_TRANS_TRIGGER BDSCHAEL 75 ~!Dead("Rasaad")~ DO 2
ADD_TRANS_TRIGGER BDSCHAEL 76 ~!Dead("Rasaad")~ DO 1
ADD_TRANS_TRIGGER BDSCHAEL 77 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 2

//BD0030
ADD_TRANS_TRIGGER BDSCHAEL 89 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 3
ADD_TRANS_TRIGGER BDSCHAEL 89 ~!Dead("Rasaad")~ DO 4
ADD_TRANS_TRIGGER BDSCHAEL 91 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 1
ADD_TRANS_TRIGGER BDSCHAEL 91 ~!Dead("Rasaad")~ DO 2
ADD_TRANS_TRIGGER BDSCHAEL 92 ~!Dead("Rasaad")~ DO 2
ADD_TRANS_TRIGGER BDSCHAEL 93 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 2
ADD_TRANS_TRIGGER BDSCHAEL 94 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 3

//BD0050
ADD_STATE_TRIGGER BDSCHAEL 96 ~!Dead("Rasaad")~
ADD_TRANS_TRIGGER BDSCHAEL 99 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 4
ADD_TRANS_TRIGGER BDSCHAEL 102 ~!Dead("Rasaad")~ 103 DO 0
ADD_TRANS_TRIGGER BDSCHAEL 107 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 1
ADD_TRANS_TRIGGER BDSCHAEL 109 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 2
ADD_TRANS_TRIGGER BDSCHAEL 110 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 3

EXTEND_BOTTOM BDSCHAEL 102 103
  IF ~~ THEN EXIT
END

//BD0010
ADD_TRANS_TRIGGER BDSCHAEL 112 ~!Dead("Dynaheir") !Dead("Minsc") !Dead("Rasaad")~ 113 114 DO 0

EXTEND_TOP BDSCHAEL 112
  IF ~!Dead("Dynaheir") !Dead("Minsc") Dead("Rasaad")~ THEN REPLY #260944 /* ~Where ARE we going? ~ */ GOTO 115b
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc") !Dead("Rasaad")~ THEN REPLY #260944 /* ~Where ARE we going? ~ */ GOTO 115c
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc") Dead("Rasaad")~ THEN REPLY #260944 /* ~Where ARE we going? ~ */ GOTO 115d
END

EXTEND_TOP BDSCHAEL 113
  IF ~!Dead("Dynaheir") !Dead("Minsc") Dead("Rasaad")~ THEN REPLY #260948 /* ~Where should we go? ~ */ GOTO 115b
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc") !Dead("Rasaad")~ THEN REPLY #260948 /* ~Where should we go? ~ */ GOTO 115c
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc") Dead("Rasaad")~ THEN REPLY #260948 /* ~Where should we go? ~ */ GOTO 115d
END

EXTEND_TOP BDSCHAEL 114
  IF ~!Dead("Dynaheir") !Dead("Minsc") Dead("Rasaad")~ THEN REPLY #260952 /* ~What do we have for options? ~ */ GOTO 115b
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc") !Dead("Rasaad")~ THEN REPLY #260952 /* ~What do we have for options? ~ */ GOTO 115c
  IF ~OR(2) Dead("Dynaheir") Dead("Minsc") Dead("Rasaad")~ THEN REPLY #260952 /* ~What do we have for options? ~ */ GOTO 115d
END

APPEND BDSCHAEL

IF ~~ THEN BEGIN 115b
  SAY @1000044 /* ~You tell me. We are to acquire equipment and allies for the trip north. There's a couple of Rashemi adventurers we can talk to at the Three Old Kegs, that bard or the thieves at the Elfsong Tavern. Or we could just return to the palace.~ */
  IF ~~ THEN REPLY #260956 /* ~All right, I know what I want to do. Follow me. ~ */ GOTO 118
  IF ~  Global("BD_Spoken_Safana","GLOBAL",0)
~ THEN REPLY #260958 /* ~Tell me about these thieves. ~ */ GOTO 121
  IF ~  Global("BD_Spoken_Garrick","GLOBAL",0)
~ THEN REPLY #260959 /* ~A bard, you say? ~ */ GOTO 123
  IF ~  Global("BD_Spoken_Tiax","GLOBAL",0)
~ THEN REPLY #260960 /* ~You forgot the cleric being held in the Flaming Fist headquarters. ~ */ GOTO 116
  IF ~  Global("bd_minsc_followup","GLOBAL",0)
~ THEN REPLY #260961 /* ~What can you tell me about the Rashemi pair? ~ */ GOTO 122
  IF ~~ THEN REPLY #260962 /* ~I feel safer out here than in there. ~ */ GOTO 117
END

IF ~~ THEN BEGIN 115c
  SAY @1000045 /* ~You tell me. We are to acquire equipment and allies for the trip north. There's that bard or the thieves at the Elfsong Tavern, or a monk at the Iron Throne Building. Or we could just return to the palace.~ */
  IF ~~ THEN REPLY #260956 /* ~All right, I know what I want to do. Follow me. ~ */ GOTO 118
  IF ~  Global("BD_Spoken_Rasaad","GLOBAL",0)
~ THEN REPLY #266856 /* ~Monk?~ */ GOTO 120
  IF ~  Global("BD_Spoken_Safana","GLOBAL",0)
~ THEN REPLY #260958 /* ~Tell me about these thieves. ~ */ GOTO 121
  IF ~  Global("BD_Spoken_Garrick","GLOBAL",0)
~ THEN REPLY #260959 /* ~A bard, you say? ~ */ GOTO 123
  IF ~  Global("BD_Spoken_Tiax","GLOBAL",0)
~ THEN REPLY #260960 /* ~You forgot the cleric being held in the Flaming Fist headquarters. ~ */ GOTO 116
  IF ~~ THEN REPLY #260962 /* ~I feel safer out here than in there. ~ */ GOTO 117
END

IF ~~ THEN BEGIN 115d
  SAY @1000046 /* ~You tell me. We are to acquire equipment and allies for the trip north. There's that bard or the thieves at the Elfsong Tavern. Or we could just return to the palace.~ */
  IF ~~ THEN REPLY #260956 /* ~All right, I know what I want to do. Follow me. ~ */ GOTO 118
  IF ~  Global("BD_Spoken_Safana","GLOBAL",0)
~ THEN REPLY #260958 /* ~Tell me about these thieves. ~ */ GOTO 121
  IF ~  Global("BD_Spoken_Garrick","GLOBAL",0)
~ THEN REPLY #260959 /* ~A bard, you say? ~ */ GOTO 123
  IF ~  Global("BD_Spoken_Tiax","GLOBAL",0)
~ THEN REPLY #260960 /* ~You forgot the cleric being held in the Flaming Fist headquarters. ~ */ GOTO 116
  IF ~~ THEN REPLY #260962 /* ~I feel safer out here than in there. ~ */ GOTO 117
END

END

//BD0106
ADD_TRANS_TRIGGER BDSCHAEL 158 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 1
ADD_TRANS_TRIGGER BDSCHAEL 162 ~!Dead("Dynaheir") !Dead("Minsc")~ DO 1

//BD0111
ADD_TRANS_TRIGGER BDSCHAEL 217 ~!Dead("Rasaad")~ DO 1
