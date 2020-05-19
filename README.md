# FantasyGroundsHackmaster
Hackmaster 4e ruleset for Fantasy Grounds

Modifies the 2e ruleset to support Hackmaster 4th edition. Ideally I turn this into an extension rather than an entire ruleset, but I had a lot to get done in a short amount of time and this was way easier, so it is what it is. I'll see about converting it to an extension when it nears feature completion.

A backlog of desired/completed/in-progress changes can be viewed here: https://trello.com/b/n3jCxUOd/fantasy-grounds-hm4-ruleset

Unfortunately, I don't think it's legal for me to share my work with regards to Player's Handbook, Gamemaster's Guide, and Hacklopedia of Beasts data, so if you use this you're going to have to enter the data for weapons, armor, races, classes, spells, etc yourself. Using the 2E PHB, DMG, and MM on Fantasy Grounds as a basis and copying and modifying records is probably the easiest way to do that. 

#### Things you need to do on the data side of things to fully use this (not a complete list):

If you've already got a data source (such as the 2E DMG) for your weapons/armor, you're going to need to go into those records and update some fields:

For armor, you need to add data to the "AC Regression" column. This should be a comma-separated string of values that match the hit points at each level of armor, from best AC To worst.. For instance, for Leather Armor you'd input "2,1" and for a Medium Shield you'd input "5,4,3". If this is empty, the armor won't use HM armor degradation rules. There's also a "Damage Soak" input that should default to 1. For armor like Full Plate, you'd want to set this to 2.

For weapons, when you're setting up the "Action" part of a weapon (where you define it's damage), there's a new property called "Damage Type". This is used for determining what kind of crit the weapon performed. This will accept the values "hacking", "slashing", "bludgeoning", "crushing", "piercing", or "puncturing". Those are 3 different types, not 6... I just wanted it to accept the 2e names for things too. If a weapon is multiple types, just enter them comma-separated, such as "bludgeoning,piercing". When a crit occurs, if there is more than one type, it'll just choose one at random as the crit type. If this is left blank or is an unrecognizable string, it will default to hacking.

Note that crits just spit out a lot of text... they don't actually roll extra damage or apply extra effects (for now, anyway). You'll have to handle that yourself.

For characters, you'll have to give them their 20 hp kicker manually. For NPCS, it should be adding it automatically for any that didn't have a specific HP value set. So, for instance, if they're just set as 2HD creatures, when you pull one to the combat tracker he'll have 20 + 2d8 hit points. But if an NPC record you created had hit points set specifically to 17, he'll still just have 17 hit points.

Don't have more than one suit of armor or more than one shield equipped at a time. It'll get the armor damage code confused and possibly apply damage to the wrong one. You can have more than one in your inventory, or even carried. Just not worn.

You'll have to create/edit your own Races and Classes if you want them to match what's in Hackmaster versus what's in 2e. I've done it myself, but don't think I can legally share that info. Monsters, however, will use the Saving Throw and to-hit charts from Hackmaster based on their hit dice, so if you're using the 2e Monster Manual, you really shouldn't have any work you need to do there to convert a monster for HM use, for the most part. From what I can tell the Hacklopedia tends to stay pretty close to what the 2E Monster Manual has, other than occasionally changing d4 damages to d6-2 or something like that. 
