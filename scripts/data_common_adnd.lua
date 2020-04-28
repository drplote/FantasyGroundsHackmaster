-- 
-- 
-- 
--

-- what version of AD&D is this
coreVersion = "2e";

-- this index points to the location of this save
-- in the aWarriorSaves, aPriestSaves, aWizardSaves, aRogueSaves
-- We do this so we can split the saves up and give
-- bonuses for things like just poison or just wands.
-- 1 = Paralyzation, poison or death
-- 2 = Rod, Staff or Wand
-- 3 = Petrification or Polymorph
-- 4 = Breath
-- 5 = Spell
saves_table_index = {
    ["poison"] = 1,
    ["paralyzation"] = 1,
    ["death"] = 1,
    ["rod"] = 2,
    ["staff"] = 2,
    ["wand"] = 2,
    ["petrification"] = 3,
    ["polymorph"] = 3,
    ["breath"] = 4,
    ["spell"] = 5
};
-- ability scores 
aStrength = {};
aDexterity = {};
aWisdom = {};
aConstitution = {};
aCharisma = {};
aIntelligence = {};
aComeliness = {};

-- turn undead, cleric
aTurnUndead = {};

-- required for npcs, base save table
aWarriorSaves = {};
-- required for npcs, hit matrix when used
aMatrix = {};

-- distance per unit grid, this is for reach? --celestian
nDefaultDistancePerUnitGrid = 10;

-- used in effects to denote that these types of modifiers are not added up
-- and to use the "best" (highest) one.
basetypes = {
  "BSTR",
  "BDEX",
  "BINT",
  "BCHA",
  "BCON",
  "BWIS",
  "BPSTR",
  "BPDEX",
  "BPINT",
  "BPCHA",
  "BPCON",
  "BPWIS",
  "DDR",      -- damage dice reduction, the higher the value the better (reduce damage that amount)
};

-- base effect, take LOWEST (low AC is good remember)
lowtypes = {
  "BAC",      -- base AC
  "BRANGEAC", -- base ranged AC (attack is via range)
  "BMELEEAC", -- base melee AC
  "BMAC",     -- base mental AC
};

-- also added these effect tags
--"TURN",
--"TURNLEVEL",
--"SURPRISE",
--"HP",
--"ARCANE", --modify the arcane casting level of the target
--"DIVINE", --modify the arcane casting level of the target
--"ANY-SPELL-CLASS-NAME", --modify the ANY-SPELL-CLASS-NAME casting level of the target

-- these class get con bonus to hp
fighterTypes = {
  "fighter",
  "ranger",
  "paladin",
  "barbarian",        
};
    
--
-- lots of psionic attack/defense nonsense
--
-- attack name to index
psionic_attack_index = {
    ["mind thrust"] = 1,
    ["ego whip"] = 2,
    ["id insinuation"] = 3,
    ["psychic crush"] = 4,
    ["psionic blast"] = 5,
};
-- defense name to index
psionic_defense_index = {
    ["mind blank"] = 1,
    ["thought shield"] = 2,
    ["mental barrier"] = 3,
    ["intellect fortress"] = 4,
    ["tower of iron will"] = 5,
};
-- this stores the modifiers for attack mode versus a defense mode
psionic_attack_v_defense_table = {};
    
-- Item records, type fields    
itemTypes = {
  "",
  "Alchemical",
  "Ammunition",
  "Animal",
  "Armor",
  "Art",
  "Clothing",
  "Cloak",
  "Container",
  "Daily Food and Lodging",
  "Equipment Packs",
  "Gear",
  "Gem",
  "Jewelry",
  "Magic",
  "Potion",
  "Provisions",
  "Ring",
  "Robe",
  "Rod",
  "Service",
  "Scroll",
  "Staff",
  "Shield",
  "Herb or Spice",
  "Tack and Harness",
  "Tool",
  "Transport",
  "Wand",
  "Weapon",
  "Other",
}
itemSubTypes = itemTypes;
itemRarity = {
  "",
  "Common",
  "Uncommon",
  "Rare",
  "Very Rare",
  "Unique",
  "Other"
}

itemArmorTypes = {
  "armor",
}
itemShieldArmorTypes = {
  "shield",
}
itemOtherArmorTypes = {
  "ring",
  "cloak",
  "robe"
}
itemArmorNonCloak = {
  "plate",
  "chain",
  "ring",
  "scale",
  "banded",
  "brigadine",
  "studded",
  "bracer",
}
arcaneSpellClasses = {
  "arcane",
  "wizard",
  "bard",
  "sorcerer",
  "mage",
  "magic-user",
}
divineSpellClasses = {
  "divine",
  "cleric",
  "druid",
  "paladin",
  "ranger",
}

-- coin type followed by XP value
expForCoinRate = {
  {'PP',5},
  {'GP',1},
  {'EP',.5},
  {'SP',.1},
  {'CP',.01},
}
function onInit()
  local sRulesetName = User.getRulesetName();
  
  -- default initiative dice size 
  nDefaultInitiativeDice = 10;
  -- default coin weight, 50 coins = 1 pound
  nDefaultCoinWeight = 0.02;
  -- default surprise dice
  if (sRulesetName == "2E") then
    aDefaultSurpriseDice = {"d10"};
  else
    aDefaultSurpriseDice = {"d6"};
  end
  
  -- HM4 mod: different strength spread
  -- aStrength[abilityScore]={hit adj, dam adj, weight allow, max press, open doors, bend bars, light enc, moderate enc, heavy enc, severe enc, max enc}
  aStrength[1]  = {-3,-8,1,3,"1(0)",0 ,2,4,6,8,10};
  aStrength[2]  = {-3,-8,2,4,"1(0)",0 ,3,5,7,9,11};
  
  aStrength[3]  = {-3,-7,3,5,"1(0)",0 ,4,6,8,10,12};
  aStrength[4]  = {-3,-7,4,7,"1(0)",0 ,5,7,9,11,13};
  
  aStrength[5]  = {-3,-6,5,10,"2(0)",0 ,6,8,10,12,16};
  aStrength[6]  = {-3,-6,7,20,"2(0)",0 ,8,10,12,15,22};
  
  aStrength[7]  = {-2,-5,9,25,"3(0)",0 ,10,12,15,19,28};
  aStrength[8]  = {-2,-5,11,35,"3(0)",0 ,12,15,18,23,34};
  
  aStrength[9]  = {-2,-4,13,30,"3(0)",0 ,14,17,21,27,40};
  aStrength[10]  = {-2,-4,15,40,"3(0)",0 ,16,20,24,31,46};
  
  aStrength[11]  = {-2,-3,18,55,"4(0)",0 ,19,24,28,37,55};
  aStrength[12]  = {-2,-3,21,68,"4(0)",0 ,22,27,33,43,55};
  
  aStrength[13]  = {-1,-2,24,70,"4(0)",0 ,25,31,37,49,73};
  aStrength[14]  = {-1,-2,27,80,"5(0)",0 ,28,35,42,55,82};
  
  aStrength[15]  = {-1,-1,30,90,"5(0)",1 ,31,39,46,61,91};
  aStrength[16]  = {-1,-1,33,95,"5(0)",1 ,34,42,51,67,100};
  
  aStrength[17]  = {0,-1,36,100,"5(0)",1 ,37,46,55,73,109};
  aStrength[18]  = {0,-1,39,110,"6(0)",1 ,40,50,60,79,118};
  
  aStrength[19] = {0,0,43,115,"6(0)",2 ,44,55,88,87,130};
  aStrength[20] = {0,0,47,125,"6(0)",3 ,48,60,72,95,142};
  
  aStrength[21] = {0,0,51,130,"6(0)",4 ,52,65,78,103,154};
  aStrength[22] = {0,0,55,135,"7(0)",4 ,56,70,84,111,166};
  
  aStrength[23] = {0,1,59,140,"7(0)",5 ,60,75,90,119,178};
  aStrength[24] = {0,1,63,145,"7(0)",5 ,64,80,96,127,190};
  
  aStrength[25] = {1,1,67,150,"7(0)",6 ,68,85,102,135,202};
  aStrength[26] = {1,1,71,160,"8(0)",6 ,72,90,108,143,214};
  
  aStrength[27] = {1,2,76,170,"8(0)",7 ,77,96,115,153,229};
  aStrength[28] = {1,2,81,175,"8(0)",8 ,82,102,123,163,244};
  
  aStrength[29] = {1,3,86,185,"9(0)",9 ,87,109,130,173,259};
  aStrength[30] = {1,3,91,190,"9(0)",10 ,92,115,138,183,274};
  
  aStrength[31] = {2,4,97,195,"10(0)",11 ,98,122,147,195,292};
  aStrength[32] = {2,4,103,220,"10(0)",12 ,104,130,156,207,310};
  
  aStrength[33] = {2,5,109,255,"11(0)",15 ,110,137,165,219,328};
  aStrength[34] = {2,5,115,290,"11(0)",20 ,116,145,174,231,346};
  
  aStrength[35] = {3,6,130,350,"12(3)",25 ,131,164,196,261,391};
  aStrength[36] = {3,6,160,480,"14(6)",35 ,161,201,241,321,481};
  
  aStrength[37] = {3,7,200,640,"15(8)",50 ,201,251,301,401,601};
  aStrength[38] = {3,7,300,660,"16(9)",50 ,301,376,451,601,901};
  
  aStrength[39] = {3,8,400,700,"17(10)",60 ,401,501,601,801,1201};
  aStrength[40] = {3,8,500,625,"17(11)",65 ,501,626,751,1001,1501};
  
  aStrength[41] = {4,9,600,810,"17(12)",70 ,601,751,901,1201,1801};
  aStrength[42] = {4,9,700,865,"18(13)",75 ,701,876,1051,1401,2101};
  
  aStrength[43] = {4,10,800,970,"18(14)",80 ,801,1001,1201,1601,2401};
  aStrength[44] = {4,10,900,1050,"18(15)",85 ,901,1126,1351,1801,2701};
  
  aStrength[45] = {5,11,1000,1130,"18(16)",90 ,1001,1251,1501,2001,3001};
  aStrength[46] = {5,11,1100,1320,"19(16)",95 ,1101,1376,1651,2201,3301};
  
  aStrength[47] = {6,12,1200,1440,"19(16)",97 ,1201,1501,1801,2401,3601};
  aStrength[48] = {6,12,1300,1540,"19(17)",98 ,1301,1626,1951,2601,3901};
  
  aStrength[49] = {7,14,1500,1750,"19(18)",99 ,1501,1876,2251,3001,4501};
  aStrength[50] = {7,14,1500,1750,"19(18)",99 ,1501,1876,2251,3001,4501};


  -- HM4 mod: different dexterity spread
  -- aDexterity[abilityScore]={reaction, missile, defensive}
  aDexterity[1]  =  {-5,-6,5};
  aDexterity[2]  =  {-5,-5,5};
  
  aDexterity[3]  =  {-5,-5,4};
  aDexterity[4]  =  {-4,-5,4};
  
  aDexterity[5]  =  {-4,-4,4};
  aDexterity[6]  =  {-4,-4,3};
  
  aDexterity[7]  =  {-3,-4,3};
  aDexterity[8]  =  {-3,-3,3};
  
  aDexterity[9]  =  {-3,-3,2};
  aDexterity[10]  =  {-2,-3,2};
  
  aDexterity[11]  =  {-2,-2,2};
  aDexterity[12]  =  {-2,-2,1};
  
  aDexterity[13]  =  {-1,-2,1};
  aDexterity[14]  =  {-1,-1,1};
  
  aDexterity[15]  =  {-1,-1,0};
  aDexterity[16]  =  {0,-1,0};
  
  aDexterity[17]  =  {0,0,0};
  aDexterity[18]  =  {0,0,0};
  
  aDexterity[19]  = {0,0,0};
  aDexterity[20]  = {0,0,0};
  
  aDexterity[21]  = {0,0,0};
  aDexterity[22]  = {0,0,0};
  
  aDexterity[23]  = {0,0,0};
  aDexterity[24]  = {0,1,0};
  
  aDexterity[25]  = {1,1,0};
  aDexterity[26]  = {1,1,-1};
  
  aDexterity[27]  = {1,2,-1};
  aDexterity[28]  = {2,2,-1};
  
  aDexterity[29]  = {2,2,-2};
  aDexterity[30]  = {2,3,-2};
  
  aDexterity[31]  = {3,3,-2};
  aDexterity[32]  = {3,3,-3};
  
  aDexterity[33]  = {3,4,-3};
  aDexterity[34]  = {4,4,-3};
  
  aDexterity[35]  = {4,4,-4};
  aDexterity[36]  = {4,5,-4};
  
  aDexterity[37]  = {5,5,-4};
  aDexterity[38]  = {5,5,-5};
  
  aDexterity[39]  = {5,6,-5};
  aDexterity[40]  = {6,6,-5};
  
  aDexterity[41]  = {6,6,-6};
  aDexterity[42]  = {6,7,-6};
  
  aDexterity[43]  = {7,7,-6};
  aDexterity[44]  = {7,7,-7};
  
  aDexterity[45]  = {7,8,-7};
  aDexterity[46]  = {8,8,-7};
  
  aDexterity[47]  = {8,8,-8};
  aDexterity[48]  = {8,9,-8};
  
  aDexterity[49]  = {9,9,-8};
  aDexterity[50]  = {9,9,-8};
  
  -- aWisdom[abilityScore]={magic adj, spell bonuses, spell failure, spell imm., MAC base, PSP bonus }
  aWisdom[1]   =    {-6, "None", 80, "None",10,0};
  aWisdom[2]   =    {-4, "None", 60, "None",10,0};
  aWisdom[3]   =    {-3, "None", 50, "None",10,0};
  aWisdom[4]   =    {-2, "None", 45, "None",10,0};
  aWisdom[5]   =    {-1, "None", 40, "None",10,0};
  aWisdom[6]   =    {-1, "None", 35, "None",10,0};
  aWisdom[7]   =    {-1, "None", 30, "None",10,0};
  aWisdom[8]   =    { 0, "None", 25, "None",10,0};
  aWisdom[9]   =    { 0, "None", 20, "None",10,0};
  aWisdom[10]  =    { 0, "None", 15, "None",10,0};
  aWisdom[11]  =    { 0, "None", 10, "None",10,0};
  aWisdom[12]  =    { 0, "None", 5, "None",10,0};
  aWisdom[13]  =    { 0, "1x1st", 0, "None",10,0};
  aWisdom[14]  =    { 0, "2x1st", 0, "None",10,0};
  aWisdom[15]  =    { 1, "2x1st,1x2nd", 0, "None",10,0};
  aWisdom[16]  =    { 2, "2x1st,2x2nd", 0, "None",9,1};
  aWisdom[17]  =    { 3, "Various", 0, "None",8,2};
  aWisdom[18]  =    { 4, "Various", 0, "None",7,3};
  aWisdom[19]  =    { 4, "Various", 0, "Various",6,4};
  aWisdom[20]  =    { 4, "Various", 0, "Various",5,5};
  aWisdom[21]  =    { 4, "Various", 0, "Various",4,6};
  aWisdom[22]  =    { 4, "Various", 0, "Various",3,7};
  aWisdom[23]  =    { 4, "Various", 0, "Various",2,8};
  aWisdom[24]  =    { 4, "Various", 0, "Various",1,9};
  aWisdom[25]  =    { 4, "Various", 0, "Various",0,10};
  -- deal with long string bonus for tooltip
  aWisdom[117]  =    { 3, "Bonus Spells: 2x1st, 2x2nd, 1x3rd",        0, "None"};
  aWisdom[118]  =    { 4, "Bonus Spells: 2x1st, 2x2nd, 1x3rd, 1x4th", 0, "None"};
  aWisdom[119]  =    { 4, "Bonus Spells: 3x1st, 2x2nd, 2x3rd, 1x4th", 0, "Spells: cause fear,charm person, command, friends, hypnotism"};
  aWisdom[120]  =    { 4, "Bonus Spells: 3x1st, 3x2nd, 2x3rd, 2x4th", 0, "Spells: cause fear,charm person, command, friends, hypnotism, forget, hold person, enfeeble, scare"};
  aWisdom[121]  =    { 4, "Bonus Spells: 3x1st, 3x2nd, 3x3rd, 2x4th, 5th", 0, "Spells: cause fear,charm person, command, friends, hypnotism, forget, hold person, enfeeble, scare, fear"};
  aWisdom[122]  =    { 4, "Bonus Spells: 3x1st, 3x2nd, 3x3rd, 3x4th, 2x5th", 0, "Spells: cause fear,charm person, command, friends, hypnotism, forget, hold person, enfeeble, scare, fear, charm monster, confusion, emotion, fumble, suggestion"};
  aWisdom[123]  =    { 4, "Bonus Spells: 4x1st, 3x2nd, 3x3rd, 3x4th, 2x5th, 1x6th", 0, "Spells: cause fear,charm person, command, friends, hypnotism, forget, hold person, enfeeble, scare, fear, charm monster, confusion, emotion, fumble, suggestion, chaos, feeblemind, hold monster,magic jar,quest"};
  aWisdom[124]  =    { 4, "Bonus Spells: 4x1st, 3x2nd, 3x3rd, 3x4th, 3x5th, 2x6th", 0, "Spells: cause fear,charm person, command, friends, hypnotism, forget, hold person, enfeeble, scare, fear, charm monster, confusion, emotion, fumble, suggestion, chaos, feeblemind, hold monster,magic jar,quest, geas, mass suggestion, rod of ruleship"};
  aWisdom[125]  =    { 4, "Bonus Spells: 4x1st, 3x2nd, 3x3rd, 3x4th, 3x5th, 3x6th,1x7th", 0, "Spells: cause fear,charm person, command, friends, hypnotism, forget, hold person, enfeeble, scare, fear, charm monster, confusion, emotion, fumble, suggestion, chaos, feeblemind, hold monster,magic jar,quest, geas, mass suggestion, rod of ruleship, antipathy/sympath, death spell,mass charm"};

-- HM4 mod: different con  spread
  -- aConstitution[abilityScore]={hp, system shock, resurrection survivial, poison save, regeneration, psp bonus}
  aConstitution[1]  =   {"-5",25,30,-2,"None",0};
  aConstitution[2]  =   {"-4",30,35,-1,"None",0};
  aConstitution[3]  =   {"-4",35,40,0,"None",0};
  aConstitution[4]  =   {"-3",40,45,0,"None",0};
  aConstitution[5]  =   {"-3",45,50,0,"None",0};
  aConstitution[6]  =   {"-2",50,55,0,"None",0};
  aConstitution[7]  =   {"-2",55,60,0,"None",0};
  aConstitution[8]  =   {"-1",60,65,0,"None",0};
  aConstitution[9]  =   {"-1",65,70,0,"None",0};
  aConstitution[10]  =  {"0",70,75,0,"None",0};
  aConstitution[11]  =  {"0",75,80,0,"None",0};
  aConstitution[12]  =  {"1",80,85,0,"None",0};
  aConstitution[13]  =  {"1",85,90,0,"None",0};
  aConstitution[14]  =  {"2",88,92,0,"None",0};
  aConstitution[15]  =  {"2",90,94,0,"None",0};
  aConstitution[16]  =  {"3",95,96,0,"None",1};
  aConstitution[17]  =  {"3",97,98,0,"None",2};
  aConstitution[18]  =  {"4",99,100,0,"None",3};
  aConstitution[19]  =  {"4",99,100,1,"None",4};
  aConstitution[20]  =  {"5",99,100,1,"1/6 turns",5};
  aConstitution[21]  =  {"5",99,100,2,"1/5 turns",6};
  aConstitution[22]  =  {"6",99,100,2,"1/4 turns",7};
  aConstitution[23]  =  {"6",99,100,3,"1/3 turns",8};
  aConstitution[24]  =  {"7",99,100,3,"1/2",9};
  aConstitution[25]  =  {"7",100,100,4,"1 turn",10};
  
  -- aCharisma[abilityScore]={reaction, missile, defensive}
  aCharisma[1]   =  {0, -8,-7};
  aCharisma[2]   =  {1, -7,-6};
  aCharisma[3]   =  {1, -6,-5};
  aCharisma[4]   =  {1, -5,-4};
  aCharisma[5]   =  {2, -4,-3};
  aCharisma[6]   =  {2, -3,-2};
  aCharisma[7]   =  {3, -2,-1};
  aCharisma[8]   =  {3, -1,0};
  aCharisma[9]   =  {4, 0, 0};
  aCharisma[10]  =  {4, 0, 0};
  aCharisma[11]  =  {4, 0, 0};
  aCharisma[12]  =  {5, 0, 0};
  aCharisma[13]  =  {5, 0, 1};
  aCharisma[14]  =  {6, 1, 2};
  aCharisma[15]  =  {7, 3, 3};
  aCharisma[16]  =  {8, 4, 5};
  aCharisma[17]  =  {10,6, 6};
  aCharisma[18]  =  {15,8, 7};
  aCharisma[19]  =  {20,10,8};
  aCharisma[20]  =  {25,12,9};
  aCharisma[21]  =  {30,14,10};
  aCharisma[22]  =  {35,16,1};
  aCharisma[23]  =  {40,18,12};
  aCharisma[24]  =  {45,20,13};
  aCharisma[25]  =  {50,20,14};
  
  -- aIntelligence[abilityScore]={# languages, spelllevel, learn spell, max spells, illusion immunity, MAC mod, PSP Bonus,MTHACO bonus}
  aIntelligence[1]  =    {0, 0,0,  0,"None",0,0,0};
  aIntelligence[2]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[3]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[4]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[5]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[6]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[7]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[8]  =    {1, 0,0,  0,"None",0,0,0};
  aIntelligence[9]  =    {2, 4,35, 6,"None",0,0,0};
  aIntelligence[10]  =   {2, 5,40, 7,"None",0,0,0};
  aIntelligence[11]  =   {2, 5,45, 7,"None",0,0,0};
  aIntelligence[12]  =   {3, 6,50, 7,"None",0,0,0};
  aIntelligence[13]  =   {3, 6,55, 9,"None",0,0,0};
  aIntelligence[14]  =   {4, 7,60, 9,"None",0,0,0};
  aIntelligence[15]  =   {4, 7,65, 11,"None",0,0,0};
  aIntelligence[16]  =   {5, 8,70, 11,"None",1,1,1};
  aIntelligence[17]  =   {6, 8,75, 14,"None",1,2,1};
  aIntelligence[18]  =   {7, 9,85, 18,"None",2,3,2};
  aIntelligence[19]  =   {8, 9,95, "All","1st",2,4,2};
  aIntelligence[20]  =   {9, 9,96, "All","1,2",3,5,3};
  aIntelligence[21]  =   {10,9,97, "All","1,2,3",3,6,3};
  aIntelligence[22]  =   {11,9,98, "All","1,2,3,4",3,7,3};
  aIntelligence[23]  =   {12,9,99, "All","1,2,3,4,5",4,8,4};
  aIntelligence[24]  =   {15,9,100,"All","1,2,3,4,5,6",4,9,4};
  aIntelligence[25]  =   {20,9,100,"All","1,2,3,4,5,6,7",4,10,4};
  -- these have such long values we stuff them into tooltips instead
  aIntelligence[119]  =   {8, 9,95, "All","Level: 1st"};
  aIntelligence[120]  =   {9, 9,96, "All","Level: 1st, 2nd"};
  aIntelligence[121]  =   {10,9,97, "All","Level: 1st, 2nd, 3rd"};
  aIntelligence[122]  =   {11,9,98, "All","Level: 1st, 2nd, 3rd, 4th"};
  aIntelligence[123]  =   {12,9,99, "All","Level: 1st, 2nd, 3rd, 4th, 5th"};
  aIntelligence[124]  =   {15,9,100,"All","Level: 1st, 2nd, 3rd, 4th, 5th, 6th"};
  aIntelligence[125]  =   {20,9,100,"All","Level: 1st, 2nd, 3rd, 4th, 5th, 6th, 7th"};
  
  aComeliness[1] = {"You're ugly. Hover for more", "Such an individual is simply ugly. The reaction evidenced will tend toward unease and a desire to get away from such brutishness as quickly as possible. If given the opportunity, the character's Charisma can offset ugliness, but this requires a fair amount of conversation and interaction to take place."};
  aComeliness[2] = {"You're ugly. Hover for more", "Such an individual is simply ugly. The reaction evidenced will tend toward unease and a desire to get away from such brutishness as quickly as possible. If given the opportunity, the character's Charisma can offset ugliness, but this requires a fair amount of conversation and interaction to take place."};
  aComeliness[3] = {"You're ugly. Hover for more", "Such an individual is simply ugly. The reaction evidenced will tend toward unease and a desire to get away from such brutishness as quickly as possible. If given the opportunity, the character's Charisma can offset ugliness, but this requires a fair amount of conversation and interaction to take place."};
  aComeliness[4] = {"You're ugly. Hover for more", "Such an individual is simply ugly. The reaction evidenced will tend toward unease and a desire to get away from such brutishness as quickly as possible. If given the opportunity, the character's Charisma can offset ugliness, but this requires a fair amount of conversation and interaction to take place."};
  aComeliness[5] = {"You're ugly. Hover for more", "Such an individual is simply ugly. The reaction evidenced will tend toward unease and a desire to get away from such brutishness as quickly as possible. If given the opportunity, the character's Charisma can offset ugliness, but this requires a fair amount of conversation and interaction to take place."};
  aComeliness[6] = {"You're ugly. Hover for more", "Such an individual is simply ugly. The reaction evidenced will tend toward unease and a desire to get away from such brutishness as quickly as possible. If given the opportunity, the character's Charisma can offset ugliness, but this requires a fair amount of conversation and interaction to take place."};
  aComeliness[7] = {"You're homely. Hover for more.", "The homeliness of the individual will be such that initial contact will be of a negative sort. This negative feeling will not be strongly evidenced. High Charisma will quickly overcome it if any conversation and interpersonal interaction transpires."};
  aComeliness[8] = {"You're homely. Hover for more.", "The homeliness of the individual will be such that initial contact will be of a negative sort. This negative feeling will not be strongly evidenced. High Charisma will quickly overcome it if any conversation and interpersonal interaction transpires."};
  aComeliness[9] = {"You're homely. Hover for more.", "The homeliness of the individual will be such that initial contact will be of a negative sort. This negative feeling will not be strongly evidenced. High Charisma will quickly overcome it if any conversation and interpersonal interaction transpires."};
  aComeliness[10] = {"You're average. Hover for more", "Plain to Average Comeliness; no effect on the viewer."};
  aComeliness[11] = {"You're average. Hover for more", "Plain to Average Comeliness; no effect on the viewer."};
  aComeliness[12] = {"You're average. Hover for more", "Plain to Average Comeliness; no effect on the viewer."};
  aComeliness[13] = {"You're average. Hover for more", "Plain to Average Comeliness; no effect on the viewer."};
  aComeliness[14] = {"You're attractive. Hover for more.", "Interest in viewing the individual is evidenced by those in contact, as he is good-looking. The reaction adjustment is increased by a percentage equal to the Comeliness score of the character. Individuals of the opposite sex will seek out such characters, and they will be affected as if under a Fascinate spell unless hte Wisdom of such individuals exceeds 50% of the character's Comeliness total."};
  aComeliness[15] = {"You're attractive. Hover for more.", "Interest in viewing the individual is evidenced by those in contact, as he is good-looking. The reaction adjustment is increased by a percentage equal to the Comeliness score of the character. Individuals of the opposite sex will seek out such characters, and they will be affected as if under a Fascinate spell unless hte Wisdom of such individuals exceeds 50% of the character's Comeliness total."};
  aComeliness[16] = {"You're attractive. Hover for more.", "Interest in viewing the individual is evidenced by those in contact, as he is good-looking. The reaction adjustment is increased by a percentage equal to the Comeliness score of the character. Individuals of the opposite sex will seek out such characters, and they will be affected as if under a Fascinate spell unless hte Wisdom of such individuals exceeds 50% of the character's Comeliness total."};
  aComeliness[17] = {"You're attractive. Hover for more.", "Interest in viewing the individual is evidenced by those in contact, as he is good-looking. The reaction adjustment is increased by a percentage equal to the Comeliness score of the character. Individuals of the opposite sex will seek out such characters, and they will be affected as if under a Fascinate spell unless hte Wisdom of such individuals exceeds 50% of the character's Comeliness total."};
  
  aComeliness[18] = {"You're beautiful. Hover for more.","The beauty of the character will cause heads to turn and hearts to race. Reaction for initial contact is at a percent equal to 150% of the Comeliness score. Individuals of the opposite sex will be affected as if under a Fascinate spell unless their Wisdom exceeds two-thirds of the character's Comeliness total. Individuals of the same sex will do likewise unless Wisdom totals at least 50% of the other character's Comeliness score. Rejection of harsh nature can cause the individual rejected to have a reaction as if the character had negative Comeliness of half the actual (positive) score."};
  aComeliness[19] = {"You're beautiful. Hover for more.","The beauty of the character will cause heads to turn and hearts to race. Reaction for initial contact is at a percent equal to 150% of the Comeliness score. Individuals of the opposite sex will be affected as if under a Fascinate spell unless their Wisdom exceeds two-thirds of the character's Comeliness total. Individuals of the same sex will do likewise unless Wisdom totals at least 50% of the other character's Comeliness score. Rejection of harsh nature can cause the individual rejected to have a reaction as if the character had negative Comeliness of half the actual (positive) score."};
  aComeliness[20] = {"You're beautiful. Hover for more.","The beauty of the character will cause heads to turn and hearts to race. Reaction for initial contact is at a percent equal to 150% of the Comeliness score. Individuals of the opposite sex will be affected as if under a Fascinate spell unless their Wisdom exceeds two-thirds of the character's Comeliness total. Individuals of the same sex will do likewise unless Wisdom totals at least 50% of the other character's Comeliness score. Rejection of harsh nature can cause the individual rejected to have a reaction as if the character had negative Comeliness of half the actual (positive) score."};
  aComeliness[21] = {"You're beautiful. Hover for more.","The beauty of the character will cause heads to turn and hearts to race. Reaction for initial contact is at a percent equal to 150% of the Comeliness score. Individuals of the opposite sex will be affected as if under a Fascinate spell unless their Wisdom exceeds two-thirds of the character's Comeliness total. Individuals of the same sex will do likewise unless Wisdom totals at least 50% of the other character's Comeliness score. Rejection of harsh nature can cause the individual rejected to have a reaction as if the character had negative Comeliness of half the actual (positive) score."};
  aComeliness[22] = {"You are stunning. Hover for more.", "The stunning beauty and gorgeous looks of a character with so high a Comeliness will be similar to that of those of lesser beauty (18-21). However, individuals will actually flock around the character, follow him, and generally behave foolishly or in some manner so as to attract the attention of the character. The reaction adjustment is double the score of Comeliness. Fascinate-like power will affect all those with Wisdom less than two-thirds the Comeliness score of the character. If an individual of the opposite sex is actually consciously sought by a character with Comeliness of 22-25, that individual will be effectively Fascinated unless his Wisdom is 18 or higher."};
  aComeliness[23] = {"You are stunning. Hover for more.", "The stunning beauty and gorgeous looks of a character with so high a Comeliness will be similar to that of those of lesser beauty (18-21). However, individuals will actually flock around the character, follow him, and generally behave foolishly or in some manner so as to attract the attention of the character. The reaction adjustment is double the score of Comeliness. Fascinate-like power will affect all those with Wisdom less than two-thirds the Comeliness score of the character. If an individual of the opposite sex is actually consciously sought by a character with Comeliness of 22-25, that individual will be effectively Fascinated unless his Wisdom is 18 or higher."};
  aComeliness[24] = {"You are stunning. Hover for more.", "The stunning beauty and gorgeous looks of a character with so high a Comeliness will be similar to that of those of lesser beauty (18-21). However, individuals will actually flock around the character, follow him, and generally behave foolishly or in some manner so as to attract the attention of the character. The reaction adjustment is double the score of Comeliness. Fascinate-like power will affect all those with Wisdom less than two-thirds the Comeliness score of the character. If an individual of the opposite sex is actually consciously sought by a character with Comeliness of 22-25, that individual will be effectively Fascinated unless his Wisdom is 18 or higher."};
  aComeliness[25] = {"You are stunning. Hover for more.", "The stunning beauty and gorgeous looks of a character with so high a Comeliness will be similar to that of those of lesser beauty (18-21). However, individuals will actually flock around the character, follow him, and generally behave foolishly or in some manner so as to attract the attention of the character. The reaction adjustment is double the score of Comeliness. Fascinate-like power will affect all those with Wisdom less than two-thirds the Comeliness score of the character. If an individual of the opposite sex is actually consciously sought by a character with Comeliness of 22-25, that individual will be effectively Fascinated unless his Wisdom is 18 or higher."};
    
    -- default turn dice size 
  nDefaultTurnDice = {"d20"};
  nDefaultTurnUndeadMaxHD = 13; -- this is actually the number of turn_name_index entries
  -- index of the turns 1-13
  turn_name_index ={      -- make sure the HD listing is XXHD or X-XHD, 
      "Skeleton or 1HD",  -- we need the number it from of HD for the 
      "Zombie or 1-2HD",  -- turn undead automation.
      "Ghoul or 2HD",
      "Shadow or 3-4HD",
      "Wight or 5HD",
      "Ghast or 5-6HD",
      "Wraith or 6HD",
      "Mummy or 7HD",
      "Spectre or 8HD",
      "Vampire or 9HD",
      "Ghost or 10HD",
      "Lich or 11-15HD+", -- 11++ doesn't work so I added 11-15 so the max HD is 15 this will work on
      "Special 20HD++"    -- "special" doesn't translate so added 20+ HD
  };
    
  -- cap of turn improvement
  nDefaultTurnUndeadMaxLevel = 14;

  --  0 = Cannot turn
  -- -1 = Turn
  -- -2 = Disentigrate
  -- -3 = Additional 2d4 creatures effected.
  aTurnUndead[1] =  {10,13,16,19,20,0,0,0,0,0,0,0,0};
  aTurnUndead[2] =  {7,10,13,16,19,20,0,0,0,0,0,0,0};
  aTurnUndead[3] =  {4,7,10,13,16,19,20,0,0,0,0,0,0};
  aTurnUndead[4] =  {-1,4,7,10,13,16,19,20,0,0,0,0,0};
  aTurnUndead[5] =  {-1,-1,4,7,10,13,16,19,20,0,0,0,0};
  aTurnUndead[6] =  {-2,-1,-1,4,7,10,13,16,19,20,0,0,0};
  aTurnUndead[7] =  {-2,-2,-1,-1,4,7,10,13,16,19,20,0,0};
  aTurnUndead[8] =  {-3,-2,-2,-1,-1,4,7,10,13,16,19,20,0};
  aTurnUndead[9] =  {-3,-3,-2,-2,-1,-1,4,7,10,13,16,19,20};
  aTurnUndead[10] = {-3,-3,-3,-2,-2,-1,-1,4,7,10,13,16,19};
  aTurnUndead[11] = {-3,-3,-3,-2,-2,-1,-1,4,7,10,13,16,19};
  aTurnUndead[12] = {-3,-3,-3,-3,-2,-2,-1,-1,4,7,10,13,16};
  aTurnUndead[13] = {-3,-3,-3,-3,-2,-2,-1,-1,4,7,10,13,16};
  aTurnUndead[14] = {-3,-3,-3,-3,-3,-2,-2,-1,-1,4,7,10,13};

  -- this needs to stick around for NPC save values
  -- since they use the warrior table
  -- Death, Rod, Poly, Breath, Spell
  aWarriorSaves[0]  = {16,18,17,20,19};
  aWarriorSaves[1]  = {14,16,15,17,17};
  aWarriorSaves[2]  = {14,16,15,17,17};
  aWarriorSaves[3]  = {13,15,14,16,16};
  aWarriorSaves[4]  = {13,15,14,16,16};
  aWarriorSaves[5]  = {11,13,12,13,14};
  aWarriorSaves[6]  = {11,13,12,13,14};
  aWarriorSaves[7]  = {10,12,11,12,13};
  aWarriorSaves[8]  = {10,12,11,12,13};
  aWarriorSaves[9]  = {8,10,9,9,11};
  aWarriorSaves[10] = {8,10,9,9,11};
  aWarriorSaves[11] = {7,9,8,8,10};
  aWarriorSaves[12] = {7,9,8,8,10};
  aWarriorSaves[13] = {5,7,6,5,8};
  aWarriorSaves[14] = {5,7,6,5,8};
  aWarriorSaves[15] = {4,6,5,4,7};
  aWarriorSaves[16] = {4,6,5,4,7};
  aWarriorSaves[17] = {3,5,4,4,6};
  aWarriorSaves[18] = {3,5,4,4,6};
  aWarriorSaves[19] = {3,5,4,4,6};
  aWarriorSaves[20] = {3,5,4,4,6};
  aWarriorSaves[21] = {3,5,4,4,6};
    
  --psionic attack/defense adjustments
  --           psionic_attack_index = psionic_defense_index
  psionic_attack_v_defense_table[1] = { 5, 3,-2,-3,-5};
  psionic_attack_v_defense_table[2] = { 3, 4, 2,-4,-3};
  psionic_attack_v_defense_table[3] = {-5,-3,-1, 2, 5};
  psionic_attack_v_defense_table[4] = { 1,-4, 4,-1,-2};
  psionic_attack_v_defense_table[5] = {-3, 2,-5, 4, 3};
  
  -- matrix style hit table for monsters
-- AC 10 .. -10  
-- -1      = 11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23,24,25,26 
 -- 0      = 10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23,24,25
 -- 1      = 9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23,24
 -- 1+     = 8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23
 -- 2-3+   = 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21
 -- 4-5+   = 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20
 -- 6-7+   = 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20
 -- 8-9+   = 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20
 -- 10-11+ = 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
 -- 12-13+ = -1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
 -- 14-15+ = -2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
 -- 16+    = -3,-2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17

 aMatrix['-1']  = {11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23,24,25,26}; -- below 1-1
 aMatrix['1-1'] = {10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23,24,25}; -- 1-1
 aMatrix['1']   = {9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23,24};  
 aMatrix['1+']  = {8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21,22,23};   -- 1+X
 aMatrix['2']   = {6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21};
 aMatrix['3']   = {6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20,21};
 aMatrix['4']   = {5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20};
 aMatrix['5']   = {5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20,20,20};
 aMatrix['6']   = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20};
 aMatrix['7']   = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20,20};
 aMatrix['8']   = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20};
 aMatrix['9']   = {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,20};
 aMatrix['10']  = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
 aMatrix['11']  = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20};
 aMatrix['12']  = {-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19};
 aMatrix['13']  = {-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19};
 aMatrix['14']  = {-2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
 aMatrix['15']  = {-2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18};
 aMatrix['16']  = {-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17};
   
end
