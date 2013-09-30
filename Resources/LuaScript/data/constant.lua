MapWidth=3000
MapHeight=1120
SIZEX=32
SIZEY=16
DEBUG=true
MAX_BUILD_ZORD=10000

Keys = {
    buildingKey,
    equipKey,
    drugKey,
    goldKey,
    silverKey,
    crystalKey,
    plantKey,
    soldierKey,
    freeKey,
    allTasksKey,
    herbKey,
    prescriptionKey,
    null,
    drugKey,
    fallThingKey,
    goodsListKey,
    magicStoneKey,
    skillsKey,
    statusPossibleKey,
    mapBloodKey,
    fightingCostKey,
    MoneyGameGoodsKey,
    ExpGameGoodsKey,
    equipSkillKey,
    ParticleKey,
    levelMaxFallGainKey,
    mineProductionKey,
}
CostData = {
    buildingData,
    equipData,
    drugData,
    goldData,
    silverData,
    crystalData,
    plantData,
    soldierData,
    freeData,
    allTasksData,
    herbData,
    prescriptionData,
    null,
    drugData,
    fallThingData,
    goodsListData,
    magicStoneData,
    skillsData,
    statusPossibleData,
    mapBloodData,
    fightingCostData,
    MoneyGameGoodsData,
    ExpGameGoodsData,
    equipSkillData,
    ParticleData,
    levelMaxFallGainData,
    mineProductionData,
}



--从1开始编号
--StoreGoods 里面的编号都要+1
GOODS_KIND = {
    BUILD=1,
	EQUIP = 2,
	DRUG = 3,
	GOLD = 4,
	SILVER = 5,
	CRYSTAL = 6,
	PLANT = 7,
	SOLDIER = 8,
	FREE_GOLD = 9,
	TASK = 10,
	HERB = 11,
	PRESCRIPTION = 12,
	NOTIFY = 13,
	RELIVE = 14,
	FALL_THING = 15,
	TREASURE_STONE = 16,
	MAGIC_STONE = 17,
	SKILL = 18,
	STATUS = 19,
	MAP_INFO = 20,
	FIGHT_COST = 21,
	MONEY_GAME_GOODS = 22,
	EXP_GAME_GOODS = 23,
	EQUIP_SKILL = 24,
	PARTICLES = 25,
	LEVEL_MAX_FALL_GAIN = 26,
	MINE_PRODUCTION = 27,
}
costKey = {"silver", "gold", "crystal"}
addKey = {"people", "cityDefense", "attack", "defense", "health", "gainsilver", "gaincrystal", "gaingold", "exp", 
    "healthBoundary", "physicAttack", "physicDefense", "magicAttack", "magicDefense", "recoverSpeed",
    "percentHealth", "percentHealthBoundary", "percentAttack", "percentDefense", "effectLevel",
    "attack", "defense", "percentHealth",
}
PLAN_KIND = {
    PLAN_BUILDING=1,
    PLAN_SOLDIER=2,
}


KindsPre = {
    "build[ID].png",
    "equip[ID].png",
    "drug[ID].png",
    "storeGold.png",
    "storeSilver.png",
    "storeCrystal.png",
    "Wplant[ID].png",
    "soldier[ID].png",
    "storeGold.png",
    "task",
    "herb[ID].png",
    "prescription",
    nil,
    "drug[ID].png",
    "",
    "stone[ID].png",
    "magicStone[ID].png",
    "skill[ID].png",
    "status[ID].png",
    nil,
    nil,
}

ZoneCenter = {
    {2526, 626},
    {1533, 726},
    {1533, 726},
    {1533, 726},
    {1533, 726},
}





SOW = 0
SEED = 1
MEDIUM = 2
MATURE = 3
ROT = 4


BUILD_ANI_OBJ = 0
BUILD_ANI_ROT = 1
BUILD_ANI_ANI = 2
buildAnimate = dict({
    {1, {{"mb0.png", "mb1.png", "mb2.png", "mb3.png", "mb4.png", "mb5.png", "mb6.png", "mb7.png"}, {62, 49}, 2000, 0, {50, 100}}},
    {140, {{"f0.png"}, {87, 37}, 2000, 1, {50, 50}}},
    {141, {{"f1.png"}, {87, 37}, 2000, 1, {50, 50}}},
    {202, {{"god0.png", "god1.png","god2.png","god3.png","god4.png","god5.png","god6.png","god7.png","god8.png"}, {101, 0}, 2000, 0, {50, 50}}},
    {203, {{"god0.png", "god1.png","god2.png","god3.png","god4.png","god5.png","god6.png","god7.png","god8.png"}, {28, 0}, 2000, 0, {50, 50}}},
    {204, {{"drugStore0.png",  "drugStore1.png","drugStore2.png","drugStore3.png","drugStore4.png","drugStore5.png","drugStore6.png","drugStore7.png","drugStore8.png","drugStore9.png"}, {31, -60}, 2000, 0, {0, 0}}},
    {205, {{"drugStore0.png",  "drugStore1.png","drugStore2.png","drugStore3.png","drugStore4.png","drugStore5.png","drugStore6.png","drugStore7.png","drugStore8.png","drugStore9.png"}, {109, -60}, 2000, 0, {0, 0}}},
    {206, {{"forgeShop0.png", "forgeShop1.png", "forgeShop2.png", "forgeShop3.png", "forgeShop4.png", "forgeShop5.png", "forgeShop6.png", "forgeShop7.png", "forgeShop8.png", "forgeShop9.png" }, {31, -60}, 2000, 0, {0, 0}}},
    {207, {{"forgeShop0.png", "forgeShop1.png", "forgeShop2.png", "forgeShop3.png", "forgeShop4.png", "forgeShop5.png", "forgeShop6.png", "forgeShop7.png", "forgeShop8.png", "forgeShop9.png"}, {109, -60}, 2000, 0, {0, 0}}},
    {162, {{"build162.png", "build162a1.png", "build162a2.png", "build162a3.png", "build162a4.png"}, {0, 0}, 2000, 2, {0, 0}}},
})

FARM_BUILD = 0
HOUSE_BUILD = 1
DECOR_BUILD = 2
CASTLE_BUILD = 3
GOD_BUILD = 4
DRUG_BUILD = 5
FORGE_SHOP = 6
BUSI_SOL = 7
STATIC_BOARD = 8
MINE_KIND = 9
LOVE_TREE = 10
RING_FIGHTING = 11
CAMP = 12

buildFunc = dict({
{FARM_BUILD, {{"photo"}, {"acc", "sell"}}},
{HOUSE_BUILD, {{"photo"}, { "sell" }}},
{DECOR_BUILD, {{"photo"}, {"sell"}}},
{CASTLE_BUILD, {{"photo"}, {"tip"}}},
{GOD_BUILD, {{"photo"}, {"soldier"}}},
{DRUG_BUILD, {{"photo"}, {"allDrug"}}},
{FORGE_SHOP, {{"photo"}, {"allEquip"}}},
{MINE_KIND, {{"photo"}, {"acc"}}},
{LOVE_TREE, {{"photo", "invite"}, {"love", "loveRank"}}},
{RING_FIGHTING, {{}, {}}},
{CAMP, {{"photo"}, {"call"}}},
})


BUY_RES = dict({
    {"silver", "buySilver"},
    {"crystal", "buyCrystal"},
    {"gold", "buyGold"},
})

obstacleBlock = dict(
{
{260048, 1}, {250047, 1}, {240046, 1},  {260046, 1}, {250045, 1}, {270045, 1}, {270047, 1}, {280046, 1},
{330055, 1}, {330053, 1}, {330051, 1}, {650057, 1}, {620052, 1}, {650053, 1}, {640042, 1}, {660040, 1}, {300028, 1}, {640052, 1}, {290045, 1}, {290041, 1}, {290043, 1}, {650041, 1}, {610031, 1}, {640054, 1}, {660054, 1}, {660056, 1}, {320062, 1}, {280040, 1}, {280042, 1}, {320060, 1}, {630037, 1}, {620050, 1}, {650055, 1}, {630051, 1}, {630053, 1}, {280038, 1}, {600046, 1}, {600048, 1}, {280034, 1}, {280032, 1}, {630043, 1}, {610051, 1}, {310027, 1}, {640036, 1}, {640038, 1}, {600050, 1}, {650039, 1}, {610049, 1}, {610045, 1}, {610047, 1}, {600030, 1}, {300060, 1}, {300062, 1}, {630031, 1}, {600028, 1}, {270039, 1}, {270033, 1}, {310043, 1}, {310041, 1}, {310047, 1}, {310045, 1}, {310049, 1}, {330061, 1}, {300054, 1}, {300050, 1}, {300052, 1}, {270041, 1}, {290031, 1}, {290033, 1}, {650035, 1}, {650037, 1}, {290039, 1}, {310051, 1}, {310053, 1}, {310055, 1}, {310059, 1}, {320052, 1}, {300042, 1}, {320050, 1}, {300040, 1}, {300046, 1}, {320054, 1}, {300044, 1}, {300048, 1}, {290027, 1}, {290029, 1}, {330049, 1}, {660038, 1}, {670055, 1}, {670057, 1}, {310061, 1}, {660034, 1}, {320046, 1}, {320048, 1}, {590047, 1}, {300030, 1}, {590049, 1}}
)
