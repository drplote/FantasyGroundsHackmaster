# Fantasy Grounds Ruleset for Hackmaster 4th Edition
Hackmaster 4e ruleset for Fantasy Grounds

Modifies the 2e ruleset to support Hackmaster 4th edition. Ideally I turn this into an extension rather than an entire ruleset, but I had a lot to get done in a short amount of time and this was way easier, so it is what it is. I'll see about converting it to an extension when it nears feature completion.

A backlog of desired/completed/in-progress changes can be viewed here: https://trello.com/b/n3jCxUOd/fantasy-grounds-hm4-ruleset

Unfortunately, I don't think it's legal for me to share my work with regards to Player's Handbook, Gamemaster's Guide, and Hacklopedia of Beasts data, so if you use this you're going to have to enter the data for weapons, armor, races, classes, spells, etc yourself. Using the 2E PHB, DMG, and MM on Fantasy Grounds as a basis and copying and modifying records is probably the easiest way to do that. 

## Installation

1. Download the code. On the GitHub page (https://github.com/drplote/FantasyGroundsHackmaster), there's a green "Code" button near the top right. Click it and select "Download .zip"
2. After it's downloaded, use your .zip tool of choice to unzip it.
3. Click into the folder you just unzipped. The first folder inside should be FantasyGroundsHackmaster-master. Click into that, and now you'll see a number of files and folders. You'll know your in the right directory if there is a file called "base.xml"
4. Select all those files and folders and create a .zip file out of them using your favorite zip tool. Alternately, if you're on Windows, instead of steps 4-6 you could edit the "pak-it.bat" file in notepad and change the path(s) in the "xcopy" lines to point at your rulesets folder(s). Then when you double-click pak-it.bat to run it, it should automatically zip up the folder contents, rename them, and copy them to the location(s) you specified. You only need one xcopy line if you're only running one version of Fantasy Grounds... I have both so that it copies to both my FGC directory and my FGU directory.
5. Rename the .zip you just created to Hackmaster4e.pak
6. Copy Hackmaster4e.pak to your rulesets folder. For instance, for mine in FGC, it's located at "%APPDATA%\Fantasy Grounds\rulesets"
7. That's it. Now when you start up Fantasy Grounds, you should be able to select the "HM4" ruleset when creating a campaign.

## What It Does So Far 
I'm probably forgetting some things, but:

- Adds the Comeliness stat
- Adds Honor and temporary honor, as well as giving +1/-1 to attack and damage dice for great honor and dishonor. Doesn't factor in to any other rolls yet.
- Automatically rolls weapon damage, spell damage, and heals as penetrating dice
- Adds the /pen to roll dice manually with penetration.
- Adds the /penp command to roll dice with penetration "plus", (i.e., penetrate on max and max -1, like a crossbow)
- /mishap to generate a spell mishap result
- /fumble to generate a fumble
- "/fumble u" or "/fumble unarmed" to generate an unarmed fumble result
- /qf to roll on the quirks/flaws table. Not super useful but I had to add all this code for spell mishaps anyway so figured I might as well expose this as a command
- Added fatigue saves (as per the book, based on stats, but reversed so it looks like a saving throw instead of an attribute check) and apology saves
- Added manual fatigue tracking and automatic strength/dex penalties. Works a little different than HM in that reducing fatigue to zero immediately clears all remaining penalties, and each time you reduce it below your fatigue factor (but not down to 0), it makes a check to see if either penalty has cleared by a point. I hope to automate fatigue in the future, but haven't yet determined a safe way to decide if it should increment or decrement in a round, so until I figure that out it remains a manual process.
- Changed minimum damage on damage rolls to be 1 instead of 0 (2e ruleset bug... they don't have as many weapon damages with built in minuses as Hackmaster does, so it didn't really come up)
 - Changed stat bonuses/penalties (to-hit, damage, reaction adj, etc) to match what's in the Hackmaster books. 
 - Changed encumbrance calculations to match what Hackmaster does
 - Players still use Thac0 (plan to change this eventually), but monsters use the attack matrix from the DMG, based on their Hit Dice.
 - Monsters use HM saving throws based on the DMG.
 - Changed the character control for experience points to allow 15% or 20% bonuses. It's fiddly though... the 2e control really isn't meant for bonuses that change over your career (such as changes due to honor/dishonor). Be careful with it. I have plans to rework this eventually.
 - Detects when a monster misses but would have hit a player's shield. Text shows in blue for a miss, red for a hit, and orange for a shield hit (with some text to indicate it too).
 - Hold alt while rolling damage to apply it first against the target's shield. Make sure you keep alt held down the whole time... you can't let it up while you see the dice rolling. This will follow normal shield rules and apply damage first to the shield, then to the target if the shield breaks.
 - Added a new effect type, "SHIELDSPEC", that alters how much damage a shield can soak per point of damage it takes. So, for instance, if a character has the "Shield Specialization" proficiency that makes shields only take 1 damage for every 2 received, add a "SHIELDSPEC:2" effect to the character to reflect this.
 - Added text to indicate when a Threshold of Pain check is needed (i.e., when a target takes half their max health in a single hit). Does not actually roll the check or anything for you.
 - Added a "HP Lost" property to armor and shields that shows how much damage they've taken
 - Added a "AC Regression" field to armor and shields that lets you set how many hit points of damage every level could take. For instance, for a Medium Shield, you'd want to put "5,4,3" in there. If this is empty, the armor is treated like 2E armor rather than Hackmaster armor.
 - Added a "Damage Soak" field to armor and shields that says how many points of damage they soak per die of damage. Defaults to 1. You'd want to set it to 2 for something like Full Plate.
 - 2e was giving NPCs initiative bonuses and penalties (mostly penalties) for size. Removed those.
 - Changed initiative handling in the combat tracker to work more like Hackmaster. If a combatant's initiative is >10, when you hit the "next round" button, rather than rolling a new initiative for them it will just subtract 10 from their initiative. This should help keep track of people who were too slow go to in a round because they had an initiative higher than 10.
 - Changed the "Default" PC inititive rolling when you start a new combat round to just set them to 99 rather than rolling a d10. I found it annoying that it would roll something for them, and then I'd just tell them to roll again anyway with their correct modifiers for weapon speed, etc. Setting it to 99 made it clearer to me who had rolled and who hadn't.
 - Changed ranged and thrown weapons to go on a fixed initiative. So if you set a longbow to weapon speed of 1 and roll initiative for it, you'll always get 1. This is to help match the HM rule where ranged weapons go on fixed segments, not on what was rolled. You can mimic this effect for any weapon initiative roll if you hold alt while rolling. 
- Changed spell initiative to be fixed at whatever their casting time is, unless they have a material component, in which case it's 1d4+casting time. If, for instance, the spellcaster already had declared they had the material components ready, you could hold alt while clicking on the initiative for the spell to ignore the "roll" part and just go on a fixed initiative of whatever the casting time is.
- Changed the d10 initiative rolls to factor in reaction adjustment from Dex. 2E didn't do this.
- I don't have a good way of handling multiple attacks yet (bows with a high ROF... fighters with specialization, etc). Working on something but not sure how best to deal with it yet. Sorry!
- When a character receives damage, it soaks some and damages the armor per die rolled as in the HM rules, assuming you've set their worn armor up with "AC Regression" as described above.
- As armor takes damage, the AC value it provides diminishes, as in Hackmaster. However, this only seems to work for PCs, not NPCs (so far), because NPC code is for determining AC is different and I haven't gotten to it yet.
- Added a "Fatigue Factor Multiplier". Click the gear icon near where you see Fatigue on the main character sheet, and you can edit this if the character has something like the Endurance talent which doubles their fatigue. Defaulted to 1.
- Added "Damage Type" to the "Action" part of a weapon. Fill it in with "hacking", "puncturing", "bludgeoning", or some comma-separated combination of those. This gets used for crit type if an attack with that action crits. If it's unset, the crit defaults to hacking. If more than one is set, it selects one randomly for each crit.
- When a natural 1 is rolled on an attack, it generates fumble text. You have to apply any of the effects of this manually.
- When a natural 20 is rolled on an attack, it generates critical hit text. You have to apply any of the effects of this (including bonus damage) manually.
- Added an "armor damage tracker" to the character's main tab that shows them their armor & shield status in terms of how much AC they've lost and how much damage they've taken, along with buttons to increment/decrement the damage. This is to make it easier to handle corner cases where the automatic armor damage code didn't work how you wanted it to. Maybe you didn't want the flaming arrow spell to be affected by armor, or alternately maybe they just got hit with and acid arrow and you decided you want that to do extra armor damage beyond the norma. It's just meant as a convenient control for the players to see the current status without clicking through inventory to their armor and opening it up, and to help the players and GM tweak what's happening for special situations. Plus, I wrote that first before I got the automation working and it's easier to leave it in then strip it out!
- House Rule: When magic armor is hit a by a weapon, it only takes damage if the weapon has an atypical damage type (such as fire or acid) or if the magic bonus of the weapon is at least equal to the magic bonus of the armor. Spells still affect armor normally. I didn't want to deal with the complicated official magic armor damage rules from the errata, and I never liked them much anyway.
- Turn undead now works like HM4 instead of 2e: # of hit dice affected when turning undead matches HM rules (1d4, +1d4 if T or D, +another 2d4 if D*), turn table is harder
- Automated the 'weapon type vs armor type' to-hit modifiers, so long as the weapon name and armor name somewhat matches items from the PHB.
 

#### Things you need to do on the data side of things to fully use this (not a complete list):

If you've already got a data source (such as the 2E DMG) for your weapons/armor, you're going to need to go into those records and update some fields:

For armor, you need to add data to the "AC Regression" column. This should be a comma-separated string of values that match the hit points at each level of armor, from best AC To worst.. For instance, for Leather Armor you'd input "2,1" and for a Medium Shield you'd input "5,4,3". If this is empty, the armor won't use HM armor degradation rules. There's also a "Damage Soak" input that should default to 1. For armor like Full Plate, you'd want to set this to 2.

For weapons, when you're setting up the "Action" part of a weapon (where you define it's damage), there's a new property called "Damage Type". This is used for determining what kind of crit the weapon performed. This will accept the values "hacking", "slashing", "bludgeoning", "crushing", "piercing", or "puncturing". Those are 3 different types, not 6... I just wanted it to accept the 2e names for things too. If a weapon is multiple types, just enter them comma-separated, such as "bludgeoning,piercing". When a crit occurs, if there is more than one type, it'll just choose one at random as the crit type. If this is left blank or is an unrecognizable string, it will default to hacking.

Note that crits just spit out a lot of text... they don't actually roll extra damage or apply extra effects (for now, anyway). You'll have to handle that yourself.

For characters, you'll have to give them their 20 hp kicker manually. For NPCS, it should be adding it automatically for any that didn't have a specific HP value set. So, for instance, if they're just set as 2HD creatures, when you pull one to the combat tracker he'll have 20 + 2d8 hit points. But if an NPC record you created had hit points set specifically to 17, he'll still just have 17 hit points.

Don't have more than one suit of armor or more than one shield equipped at a time. It'll get the armor damage code confused and possibly apply damage to the wrong one. You can have more than one in your inventory, or even carried. Just not worn.

You'll have to create/edit your own Races and Classes if you want them to match what's in Hackmaster versus what's in 2e. I've done it myself, but don't think I can legally share that info. Monsters, however, will use the Saving Throw and to-hit charts from Hackmaster based on their hit dice, so if you're using the 2e Monster Manual, you really shouldn't have any work you need to do there to convert a monster for HM use, for the most part. From what I can tell the Hacklopedia tends to stay pretty close to what the 2E Monster Manual has, other than occasionally changing d4 damages to d6-2 or something like that. 
