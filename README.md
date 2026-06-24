![Latest Release](https://img.shields.io/github/v/release/Gibberlings3/EET?include_prereleases&color=blue) 
![GitHub (Pre-)Release Date](https://img.shields.io/github/release-date-pre/Gibberlings3/EET?color=gold)
![Platform](https://img.shields.io/static/v1?label=platform&message=windows%20%7C%20macOS%20%7C%20linux%20%7C%20Project%20Infinity&color=informational)
![Language](https://img.shields.io/static/v1?label=language&message=English%20%7C%20Chinese%20%7C%20Czech%20%7C%20French%20%7C%20German%20%7C%20Polish%20%7C%20Russian%20%7C%20Spanish&color=limegreen)

![The G3 Logo](https://raw.githubusercontent.com/Gibberlings3/.github/master/profile/g3_neutral.png)

# Baldur's Gate: Enhanced Edition Trilogy (EET)

## Overview

Baldur's Gate: Enhanced Edition Trilogy (EET) is a modification for Baldur's Gate II: Enhanced Edition that merges the whole saga into one game and provides continuity between the events of Baldur's Gate, Tales of the Sword Coast, Shadows of Amn, Throne of Bhaal and Siege of Dragonspear expansions (also for both Black Pits adventures). The name of this modification probably rings a bell to those who have been following the IE modding scene, thanks to the classic mod that inspired this project called Baldur's Gate Trilogy (BGT), developed by Bardez and Ascension64. While EET remains mostly faithful to the premise of BGT, it shouldn't be considered a direct continuation of that project. In fact, both mods share little to no common code and have made different design decisions in many aspects.

Baldur's Gate: Enhanced Edition Trilogy has two main goals:

I. Unite the Baldur's Gate series into a single, continuous world that doesn't feel like 4 separate campaigns.
- Play all of the Infinity Engine Baldur's Gate Saga games in Baldur's Gate II: Enhanced Edition's engine. One game, complete package.
- Seamless experience, NPC continuity, better internal consistency between the games.
- United journal system that keeps track of all 22 chapters of your journey, from the beginning in Candlekeep up until the end of the Throne of Bhaal expansion.
- No restrictions in travelling between BG1, SoD, BG2 and ToB areas, once they are discovered. All areas accessible from the same worldmap.

II. Become a mod-friendly platform with the additional modding possibilities that come by fulfilling the first goal.
- Solution for mods designed to affect BG1 and BG2 content at the same time (preserved variables, character adjustments, world state, saves, things that can vary between installations like spell references assigned by WeiDU, etc).
- A way to create new content designed for higher-level parties in areas that normally wouldn't exist in the unmodded games or would be blocked after certain points of the story (BGT mod).
- Intuitive conventions for renamed BG:EE files and modders resources that can be used for adopting existing mods.
- Limited support for mods installed on BG:EE previous to installing EET on BG2:EE.

## Requirements for Linux and Macos Users

- A recent version of weidu (anything newer than v248, will do fine) on your path, you likely already have this if you have install mods before. If not here is a short example on how to add weidu to your path:
```bash
export PATH="${PATH}:<path to weidu>"
```
where `<path to weidu>` is the folder containing your weidu binary, If you do not have weidu locally you can fetch it from github.

- A recent version of Lua (bundled for windws is 5.3 Lua), your package manager's version should work as should homebrew/macports for macos. You can check the version of Lua you have on your path with, the following:

```bash
lua -v
```

you should see something like:

```bash
Lua 5.4.8  Copyright (C) 1994-2025 Lua.org, PUC-Rio
```

## More Information

:page_facing_up: [Project Page](https://www.gibberlings3.net/mods/other/eet/)  
:page_facing_up: [Readme](https://gibberlings3.github.io/Documentation/readmes/readme-EET.html)  
:page_facing_up: [Forum](https://www.gibberlings3.net/forums/forum/195-enhanced-edition-trilogy/) 

## 

![GitHub repo size](https://img.shields.io/github/repo-size/Gibberlings3/EET?style=plastic&label=repo%20size)
