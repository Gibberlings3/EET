ADD_TRANS_TRIGGER DANDAL 1 ~GlobalLT("Chapter","GLOBAL",8)~ DO 1
EXTEND_BOTTOM DANDAL 1
IF ~GlobalGT("Chapter","GLOBAL",7)~ THEN REPLY #218665 /* ~Actually, we're adventurers. We're here to help out. Perhaps you could tell us about what's been going on in the region.~ */ GOTO 4
END

ADD_TRANS_TRIGGER BUB 0 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0

ADD_TRANS_TRIGGER RALEO 2 ~GlobalLT("Chapter","GLOBAL",8)~ DO 1
ADD_TRANS_TRIGGER RALEO 3 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0
ADD_TRANS_TRIGGER RALEO 5 ~GlobalLT("Chapter","GLOBAL",8)~ DO 1

ADD_STATE_TRIGGER VOLO 0 ~GlobalLT("Chapter","GLOBAL",8)~ 1

ADD_STATE_TRIGGER DRIZZT 6 ~GlobalLT("Chapter","GLOBAL",8)~

APPEND DRIZZT
IF ~GlobalGT("Chapter","GLOBAL",7)
Global("HelpDrizzt","GLOBAL",1)
Global("DrizztGnolls","GLOBAL",12)~ THEN BEGIN 6b
  SAY #202454 /* ~Well met, friend. Luck be on your side.~ */
  IF ~~ THEN DO ~EscapeArea()
~ JOURNAL #227002 /* ~The dark elf named Drizzt Do'Urden seems a deadly sort of fellow. I'll be glad never to get on the wrong side of his blades.~ */ EXIT
END
END

ADD_STATE_TRIGGER TAEROM 0 ~GlobalLT("Chapter","GLOBAL",8)~ 4
ADD_TRANS_TRIGGER TAEROM 4 ~GlobalLT("Chapter","GLOBAL",8)~ DO 2
ADD_TRANS_TRIGGER TAEROM 8 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0
ADD_TRANS_TRIGGER TAEROM 12 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0

EXTEND_BOTTOM TAEROM 8
IF ~GlobalGT("Chapter","GLOBAL",7)
PartyHasItem("MISC12")
~ THEN REPLY #226788 /* ~I'd like to sell you more ankheg shells.~ */ UNSOLVED_JOURNAL #227451 /* ~A New Suit of Armor
In just a day, Taerom "Thunderhammer" of Beregost should have my new ankheg-shell plate mail ready for me. I will look ferocious in it!~ */ GOTO 1b
END

EXTEND_BOTTOM TAEROM 12
IF ~GlobalGT("Chapter","GLOBAL",7)~ THEN REPLY #200203 /* ~I'll sell it to you. I'm sick of carrying it around.~ */ GOTO 1b
END

APPEND TAEROM
IF ~~ THEN BEGIN 1b
  SAY @1000048 /* ~Ah, this will make a fine suit of plate for a governor or better. Nobility like exotic materials and don't care much about the price. Probably close to 20,000 gold for a tenday's work when I'm finished.~ */
  IF ~~ THEN DO ~TakePartyItem("MISC12")
DestroyItem("MISC12")
GiveGoldForce(500)
EraseJournalEntry(227450)
EraseJournalEntry(227451)
EraseJournalEntry(227452)
~ SOLVED_JOURNAL #227452 /* ~A Small Fortune!
One lousy ankheg shell for 500 gold? I can't believe everyone isn't out hunting those giant bug monsters.~ */ EXIT
END
END

ADD_TRANS_TRIGGER NOBL10 0 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0 1 2
EXTEND_BOTTOM NOBL10 0
IF ~~ THEN EXIT
END

ADD_TRANS_TRIGGER SAMANT 0 ~GlobalLT("Chapter","GLOBAL",8)~ DO 1
EXTEND_BOTTOM SAMANT 0
IF ~GlobalGT("Chapter","GLOBAL",7)~ THEN REPLY #218698 /* ~We're adventurers, just arrived in town recently. So what's your name?~ */ GOTO 5
END

ADD_TRANS_TRIGGER HUNTER 1 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0

ADD_STATE_TRIGGER WHELP 0 ~GlobalLT("Chapter","GLOBAL",8)~
REPLACE_STATE_TRIGGER WHELP 3 ~GlobalGT("Chapter","GLOBAL",7)~

ADD_TRANS_TRIGGER SURREY 0 ~GlobalLT("Chapter","GLOBAL",8)~ DO 0

ADD_STATE_TRIGGER HULRIK 1 ~GlobalLT("Chapter","GLOBAL",8)~

ADD_STATE_TRIGGER MERC0706 0 ~GlobalLT("Chapter","GLOBAL",8)~
APPEND MERC0706
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0b
  SAY @1000048 /* ~A fine and lovely day to ye! Would you be interested in any of my fine odds and ends?~ */
  IF ~~ THEN REPLY #215764 /* ~I have no need of your trinkets. Good day.~ */ EXIT
  IF ~~ THEN REPLY #215765 /* ~Let's see what you have for offer.~ */ DO ~StartStore("sto0706",LastTalkedToBy(Myself))
~ EXIT
END
END

ADD_STATE_TRIGGER MERCH4 0 ~GlobalLT("Chapter","GLOBAL",8)~
APPEND MERCH4
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0b
  SAY @1000048 /* ~A fine and lovely day to ye! Would you be interested in any of my fine odds and ends?~ */
  IF ~~ THEN REPLY #215764 /* ~I have no need of your trinkets. Good day.~ */ EXIT
  IF ~~ THEN REPLY #215765 /* ~Let's see what you have for offer.~ */ DO ~StartStore("sto4906",LastTalkedToBy(Myself))
~ EXIT
END
END

ADD_STATE_TRIGGER MERCH2 0 ~GlobalLT("Chapter","GLOBAL",8)~ 1
APPEND MERCH2
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0-1b
  SAY @1000049 /* ~Hey there, you look like the adventurin' type. So, do ya need some new equipment?~ */
  IF ~~ THEN REPLY #215290 /* ~Show us your wares.~ */ DO ~StartStore("sto4901",LastTalkedToBy(Myself))
~ EXIT
  IF ~~ THEN REPLY #215291 /* ~We don't need anything today.~ */ EXIT
END
END

ADD_STATE_TRIGGER MERCH6 0 ~GlobalLT("Chapter","GLOBAL",8)~
APPEND MERCH6
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0b
  SAY @1000050 /* ~I trust you are enjoying the fair? What can I get for you?~ */
  IF ~~ THEN REPLY #215770 /* ~It has been a lovely diversion, indeed. What wares have you available?~ */ DO ~StartStore("sto4909",LastTalkedToBy(Myself))
~ EXIT
  IF ~~ THEN REPLY #215771 /* ~Sorry, but I've no need of anything right now. Perhaps another time.~ */ EXIT
END
END

ADD_STATE_TRIGGER MERCHA 2 ~GlobalLT("Chapter","GLOBAL",8)~

ADD_STATE_TRIGGER AMNIS3 2 ~GlobalLT("Chapter","GLOBAL",8)~

ADD_STATE_TRIGGER AMNIS 6 ~GlobalLT("Chapter","GLOBAL",8)~ 7 15 16
APPEND AMNIS
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 6-7-15-16b
  SAY #200352 /* ~Move along, citizen.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER AMNIS4 1 ~GlobalLT("Chapter","GLOBAL",8)~ 3 5 6 7 8 9
APPEND AMNIS4
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 1-3-5-6-7-8-9b
  SAY #213948 /* ~You make one move that be suspicious, and I swear your head will leave the mines before your neck.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER MTOWBE 0 ~GlobalLT("Chapter","GLOBAL",8)~ 13 14 15 16 18 19 20 22 24 25 29 30 31 32 33
APPEND MTOWBE
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0-13-14-15-16-18-19-20-22-24-25-29-30-31-32-33b
  SAY #206422 /* ~Sorry, buddy, but I'm just simple folk and don't know anything about politics and such.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER FTOWBE 2 ~GlobalLT("Chapter","GLOBAL",8)~ 5 6 9 10 11 12 13 20
APPEND FTOWBE
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 2-5-6-9-10-11-12-13-20b
  SAY #206419 /* ~I'm just a simple little lady, I don't know much at all.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER MTOWNA 0 ~GlobalLT("Chapter","GLOBAL",8)~ 1 2 3 8 11 14 15
APPEND MTOWNA
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0-1-2-3-8-11-14-15b
  SAY #206292 /* ~I don't know nuthin'. Sorry.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER FTOWNA 0 ~GlobalLT("Chapter","GLOBAL",8)~ 1 8 11
APPEND FTOWNA
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 0-1-8-11b
  SAY #200332 /* ~Please, leave me be.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER MTOWFR 1 ~GlobalLT("Chapter","GLOBAL",8)~ 2 3 9 16 17 21
APPEND MTOWFR
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 1-2-3-9-16-17-21b
  SAY #201474 /* ~I'm in no mood to speak with you. Get out of me face.~ */
  IF ~~ THEN EXIT
END
END

ADD_STATE_TRIGGER FTOWFR 2 ~GlobalLT("Chapter","GLOBAL",8)~ 4 5 8 9 10 14 17
APPEND MTOWFR
IF ~GlobalGT("Chapter","GLOBAL",7)
~ THEN BEGIN 2-4-5-8-9-10-14-17b
  SAY #200860 /* ~I'm sorry, my husband doesn't like me to speak with strangers.~ */
  IF ~~ THEN EXIT
END
END

//STO
REPLACE_STATE_TRIGGER RBALDU 0 ~Global("Chapter","GLOBAL",7)~ 1 2 3 4 10 13 16 17
REPLACE_STATE_TRIGGER RBALDU 6 ~GlobalLT("Chapter","GLOBAL",8)~ 7 8 11 12 18

REPLACE_STATE_TRIGGER RBEREG 1 ~Global("Chapter","GLOBAL",7)~ 16
REPLACE_STATE_TRIGGER RBEREG 3 ~GlobalLT("Chapter","GLOBAL",8)~ 4 5 7 9 12 17 20
ADD_STATE_TRIGGER RBEREG 6 ~GlobalLT("Chapter","GLOBAL",8)~ 15 18 19

REPLACE_STATE_TRIGGER RFRIEN 1 ~Global("Chapter","GLOBAL",7)~
REPLACE_STATE_TRIGGER RFRIEN 3 ~GlobalLT("Chapter","GLOBAL",8)~ 4 5 6
