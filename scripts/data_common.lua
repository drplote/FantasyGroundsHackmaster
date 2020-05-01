-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Abilities (database names)
abilities = {
  "strength",
  "dexterity",
  "constitution",
  "intelligence",
  "wisdom",
  "charisma",
  "comeliness"
};

ability_ltos = {
  ["strength"] = "STR",
  ["dexterity"] = "DEX",
  ["constitution"] = "CON",
  ["intelligence"] = "INT",
  ["wisdom"] = "WIS",
  ["charisma"] = "CHA",
  ["comeliness"] = "COM"
};

ability_stol = {
  ["STR"] = "strength",
  ["DEX"] = "dexterity",
  ["CON"] = "constitution",
  ["INT"] = "intelligence",
  ["WIS"] = "wisdom",
  ["CHA"] = "charisma",
  ["COM"] = "comeliness"
};


saves = {
    "poison",
    "paralyzation",
    "death",
    "rod",
    "staff",
    "wand",
    "petrification",
    "polymorph",
    "breath",
    "spell",
	"apology",
	"fatigue"
};

saves_stol = {
    ["poison"] = "Poison",
    ["paralyzation"] = "Paralyzation",
    ["death"] = "Death",
    ["rod"] = "Rod",
    ["staff"] = "Staff",
    ["wand"] = "Wand",
    ["petrification"] = "Petrification",
    ["polymorph"] = "Polymorph",
    ["breath"] = "Breath",
    ["spell"] = "Spell",
	["apology"] = "Apology",
	["fatigue"] = "Fatigue"
};

saves_multi_name = {
  ["poison"] = "poison",
  ["paralyzation"] = "paralyzation",
  ["death"] = "death",
  ["rod"] = "rod",
  ["rods"] = "rod",
  ["staff"] = "staff",
  ["staves"] = "staff",
  ["wand"] = "wand",
  ["wands"] = "wand",
  ["petrification"] = "petrification",
  ["petrify"] = "petrification",
  ["polymorph"] = "polymorph",
  ["breath"] = "breath",
  ["other"] = "other",
  ["spell"] = "spell",
  ["spells"] = "spell",
  ["apology"] = "apology",
  ["fatigue"] = "fatigue"
};

saves_shortnames = {
  "poison",
  "paralyzation",
  "death",
  "rod",
  "staff",
  "wand",
  "petrification",
  "polymorph",
  "breath",
  "spell",
  "apology",
  "fatigue"
};

-- Basic class values (not display values)
classes = {
  "barbarian",
  "bard",
  "cleric",
  "druid",
  "fighter",
  "monk",
  "paladin",
  "ranger",
  "rogue",
  "sorcerer",
  "warlock",
  "wizard",
};

-- Values for wound comparison
healthstatusfull = "healthy";
healthstatushalf = "bloodied";
healthstatuswounded = "wounded";

-- Values for alignment comparison
alignment_lawchaos = {
  ["lawful"] = 1,
  ["chaotic"] = 3,
  ["lg"] = 1,
  ["ln"] = 1,
  ["le"] = 1,
  ["cg"] = 3,
  ["cn"] = 3,
  ["ce"] = 3,
};
alignment_goodevil = {
  ["good"] = 1,
  ["evil"] = 3,
  ["lg"] = 1,
  ["le"] = 3,
  ["ng"] = 1,
  ["ne"] = 3,
  ["cg"] = 1,
  ["ce"] = 3,
};

-- Values for size comparison
creaturesize = {
  ["tiny"] = 1,
  ["small"] = 2,
  ["medium"] = 3,
  ["large"] = 4,
  ["huge"] = 5,
  ["gargantuan"] = 6,
  ["T"] = 1,
  ["S"] = 2,
  ["M"] = 3,
  ["L"] = 4,
  ["H"] = 5,
  ["G"] = 6,
};

-- Values for creature type comparison
creaturedefaulttype = "humanoid";
creaturehalftype = "half-";
creaturehalftypesubrace = "human";
creaturetype = {
  "aberration",
  "beast",
  "celestial",
  "construct",
  "dragon",
  "elemental",
  "fey",
  "fiend",
  "giant",
  "humanoid",
  "monstrosity",
  "ooze",
  "plant",
  "undead",
};
creaturesubtype = {
  "aarakocra",
  "bullywug",
  "demon",
  "devil",
  "dragonborn",
  "dwarf",
  "elf", 
  "gith",
  "gnoll",
  "gnome", 
  "goblinoid",
  "grimlock",
  "halfling",
  "human",
  "kenku",
  "kuo-toa",
  "kobold",
  "lizardfolk",
  "living construct",
  "merfolk",
  "orc",
  "quaggoth",
  "sahuagin",
  "shapechanger",
  "thri-kreen",
  "titan",
  "troglodyte",
  "yuan-ti",
  "yugoloth",
};

-- Values supported in effect conditionals
conditionaltags = {
};

-- Conditions supported in effect conditionals and for token widgets
conditions = {
  "blinded", 
  "charged",
  "charmed",
  --"cursed",
  "deafened",
  "displaced",
  --"encumbered",
  "frightened", 
--  "grappled", 
--  "incapacitated",
--  "incorporeal",
  "intoxicated",
  "invisible", 
  "no-dexterity",
  "paralyzed",
  "petrified",
  "poisoned",
  "polymorphed",
  "prone", 
  "restrained",
  "shieldless",
  "slept",
  --"stable", 
  "stunned",
  "turned",
  "unconscious",
  "conceal25",
  "conceal50",
  "conceal75",
  "conceal90",
  "cover25",
  "cover50",
  "cover75",
  "cover90",
};

-- Bonus/penalty effect types for token widgets
bonuscomps = {
  "INIT",
  "CHECK",
  "AC",
  "ATK",
  "DMG",
  "DMGX",
  "HEAL",
  "HEALX",
  "SAVE",
  "STR",
  "CON",
  "DEX",
  "INT",
  "WIS",
  "CHA",
  "MELEEAC",  -- ranged AC (when being attacked by range weapon)
  "RANGEAC",  -- melee AC (when being attacked by melee)
  "MAC",      -- Mental AC
  "PSIATK",
  "DMGPSP",
};

-- Condition effect types for token widgets
condcomps = {
  ["blinded"] = "cond_blinded",
  ["charmed"] = "cond_charmed",
  ["deafened"] = "cond_deafened",
  ["displaced"] = "cond_incorporeal",
  ["charged"] = "cond_vulnerable",
  ["encumbered"] = "cond_encumbered",
  ["frightened"] = "cond_frightened",
  ["grappled"] = "cond_grappled",
  ["incapacitated"] = "cond_paralyzed",
  ["incorporeal"] = "cond_incorporeal",
  ["invisible"] = "cond_invisible",
  ["no-dexterity"] = "cond_paralyzed",
  ["paralyzed"] = "cond_paralyzed",
  ["petrified"] = "cond_paralyzed",
  ["poisoned"] = "cond_sickened",
  ["prone"] = "cond_prone",
  ["restrained"] = "cond_restrained",
  ["shieldless"] = "cond_vulnerable",
  ["slept"] = "cond_unconscious",
  ["stunned"] = "cond_stunned",
  ["turned"] = "cond_paralyzed",
  ["unconscious"] = "cond_unconscious",
  -- Similar to conditions
  ["cover"] = "cond_cover",
  ["scover"] = "cond_cover",
  ["cover25"] = "cond_cover",
  ["cover50"] = "cond_cover",
  ["cover75"] = "cond_cover",
  ["cover90"] = "cond_cover",
  ["conceal25"] = "cond_conceal",
  ["conceal50"] = "cond_conceal",
  ["conceal75"] = "cond_conceal",
  ["conceal90"] = "cond_conceal",
};

-- Other visible effect types for token widgets
othercomps = {
	["COVER"] = "cond_cover",
	["SCOVER"] = "cond_cover",
	["IMMUNE"] = "cond_immune",
	["RESIST"] = "cond_resistance",
	["VULN"] = "cond_vulnerable",
	["REGEN"] = "cond_regeneration",
	["DMGO"] = "cond_bleed",
  ["DMGPSPO"] = "cond_ongoing",
};

-- Effect components which can be targeted
targetableeffectcomps = {
  "HIDDEN",
  "COVER",
  "SCOVER",
  "AC",
  "SAVE",
  "ATK",
  "DMG",
  "DMGX",
  "IMMUNE",
  "VULN",
  "RESIST",
  "PSIATK",
};

connectors = {
  "and",
  "or"
};

-- Range types supported
rangetypes = {
  "melee",
  "ranged",
  "psionic"
};

-- Damage types supported
dmgtypes = {
  "acid",    -- ENERGY TYPES
  "cold",
  "fire",
  "force",
  "lightning",
  "necrotic",
  "poison",
  "psychic",
  "radiant",
  "thunder",
  "adamantine",   -- WEAPON PROPERTY DAMAGE TYPES
  "bludgeoning",
  "cold-forged iron",
  "magic",
  "piercing",
  "silver",
  "slashing",
  "critical", -- SPECIAL DAMAGE TYPES
  "magic +1", --+1 weapons
  "magic +2", --+2 weapons
  "magic +3", --+3 weapons
  "magic +4", --+4 weapons
  "magic +5", --+5 weapons
  "magic +6", --+6 weapons
};

specialdmgtypes = {
  "critical",
};

-- Bonus types supported in power descriptions
bonustypes = {
};
stackablebonustypes = {
};

function onInit()

  -- Classes
  class_nametovalue = {
    [Interface.getString("class_value_barbarian")] = "barbarian",
    [Interface.getString("class_value_bard")] = "bard",
    [Interface.getString("class_value_cleric")] = "cleric",
    [Interface.getString("class_value_druid")] = "druid",
    [Interface.getString("class_value_fighter")] = "fighter",
    [Interface.getString("class_value_monk")] = "monk",
    [Interface.getString("class_value_paladin")] = "paladin",
    [Interface.getString("class_value_ranger")] = "ranger",
    [Interface.getString("class_value_rogue")] = "rogue",
    [Interface.getString("class_value_sorcerer")] = "sorcerer",
    [Interface.getString("class_value_warlock")] = "warlock",
    [Interface.getString("class_value_wizard")] = "wizard",
  };

  class_valuetoname = {
    ["barbarian"] = Interface.getString("class_value_barbarian"),
    ["bard"] = Interface.getString("class_value_bard"),
    ["cleric"] = Interface.getString("class_value_cleric"),
    ["druid"] = Interface.getString("class_value_druid"),
    ["fighter"] = Interface.getString("class_value_fighter"),
    ["monk"] = Interface.getString("class_value_monk"),
    ["paladin"] = Interface.getString("class_value_paladin"),
    ["ranger"] = Interface.getString("class_value_ranger"),
    ["rogue"] = Interface.getString("class_value_rogue"),
    ["sorcerer"] = Interface.getString("class_value_sorcerer"),
    ["warlock"] = Interface.getString("class_value_warlock"),
    ["wizard"] = Interface.getString("class_value_wizard"),
  };

  -- Skills
        skilldata = {};
  -- skilldata = {
    -- [Interface.getString("skill_value_acrobatics")] = { lookup = "acrobatics", stat = 'dexterity' },
    -- [Interface.getString("skill_value_animalhandling")] = { lookup = "animalhandling", stat = 'wisdom' },
    -- [Interface.getString("skill_value_arcana")] = { lookup = "arcana", stat = 'intelligence' },
    -- [Interface.getString("skill_value_athletics")] = { lookup = "athletics", stat = 'strength' },
    -- [Interface.getString("skill_value_deception")] = { lookup = "deception", stat = 'charisma' },
    -- [Interface.getString("skill_value_history")] = { lookup = "history", stat = 'intelligence' },
    -- [Interface.getString("skill_value_insight")] = { lookup = "insight", stat = 'wisdom' },
    -- [Interface.getString("skill_value_intimidation")] = { lookup = "intimidation", stat = 'charisma' },
    -- [Interface.getString("skill_value_investigation")] = { lookup = "investigation", stat = 'intelligence' },
    -- [Interface.getString("skill_value_medicine")] = { lookup = "medicine", stat = 'wisdom' },
    -- [Interface.getString("skill_value_nature")] = { lookup = "nature", stat = 'intelligence' },
    -- [Interface.getString("skill_value_perception")] = { lookup = "perception", stat = 'wisdom' },
    -- [Interface.getString("skill_value_performance")] = { lookup = "performance", stat = 'charisma' },
    -- [Interface.getString("skill_value_persuasion")] = { lookup = "persuasion", stat = 'charisma' },
    -- [Interface.getString("skill_value_religion")] = { lookup = "religion", stat = 'intelligence' },
    -- [Interface.getString("skill_value_sleightofhand")] = { lookup = "sleightofhand", stat = 'dexterity' },
    -- [Interface.getString("skill_value_stealth")] = { lookup = "stealth", stat = 'dexterity', disarmorstealth = 1 },
    -- [Interface.getString("skill_value_survival")] = { lookup = "survival", stat = 'wisdom' },
  -- };

  -- Party sheet drop down list data
  psabilitydata = {
    Interface.getString("strength"),
    Interface.getString("dexterity"),
    Interface.getString("constitution"),
    Interface.getString("intelligence"),
    Interface.getString("wisdom"),
    Interface.getString("charisma"),
  };

  -- Party sheet drop down list data
        psskilldata = {};
  -- psskilldata = {
    -- Interface.getString("skill_value_acrobatics"),
    -- Interface.getString("skill_value_animalhandling"),
    -- Interface.getString("skill_value_arcana"),
    -- Interface.getString("skill_value_athletics"),
    -- Interface.getString("skill_value_deception"),
    -- Interface.getString("skill_value_history"),
    -- Interface.getString("skill_value_insight"),
    -- Interface.getString("skill_value_intimidation"),
    -- Interface.getString("skill_value_investigation"),
    -- Interface.getString("skill_value_medicine"),
    -- Interface.getString("skill_value_nature"),
    -- Interface.getString("skill_value_perception"),
    -- Interface.getString("skill_value_performance"),
    -- Interface.getString("skill_value_persuasion"),
    -- Interface.getString("skill_value_religion"),
    -- Interface.getString("skill_value_sleightofhand"),
    -- Interface.getString("skill_value_stealth"),
    -- Interface.getString("skill_value_survival"),
  -- };
  
  -- partysheet save drop down list
  pssavedata = saves;
  -- pssavedata = {
    -- Interface.getString("save_paralyzation_poison_death"),
    -- Interface.getString("save_rod_staff_wand"),
    -- Interface.getString("save_petrify_polymorph"),
    -- Interface.getString("save_breath"),
    -- Interface.getString("save_spell"),
  -- };

end
