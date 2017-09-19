CARD_PLAYERTYPE_MY = 1
CARD_PLAYERTYPE_LEFT = 2
CARD_PLAYERTYPE_RIGHT = 3
CARD_PLAYERTYPE_TOP = 4

CARD_TYPE_INHAND = 1
CARD_TYPE_OUTHAND = 2
CARD_TYPE_LEFTHAND = 3

CARD_DISPLAY_TYPE_OPPOSIVE = 1
CARD_DISPLAY_TYPE_SHOW = 2
CARD_DISPLAY_TYPE_HIDE = 3

CARDNODE_TYPE_NORMAL = 1
CARDNODE_TYPE_LAIZI = 2
CARDNODE_TYPE_CAISHEN = 3
--听牌移除牌
CARDNODE_TYPE_TINGMOVE = 4

SCREEN_WIDTH = 1280

dump("define test")
D3_CHUPAI = 0
D3_CONTROLLER = nil


--胡类型
HU_TYPE_H = 0x040
HU_TYPE_GH = 0x080
HU_TYPE_HH = 0x100
HU_TYPE_ZM = 0x800


--杠类型
GANG_TYPE_PG = 0x010
GANG_TYPE_HUA = 0x020
GANG_TYPE_AN = 0x200
GANG_TYPE_BU = 0x400

--碰类型
PENG_TYPE_P = 0x008

--吃类型
CHI_TYPE_RIGHT = 0x001
CHI_TYPE_MIDDLE = 0x002
CHI_TYPE_LEFT = 0x004

--听
TING_TYPE_T = 0x1000  ---用于亮杠牌

--界面操作类型
CONTROL_TYPE_HU = bit.bor(bit.bor(bit.bor(HU_TYPE_H, HU_TYPE_GH), HU_TYPE_HH), HU_TYPE_ZM)
CONTROL_TYPE_GANG = bit.bor(bit.bor(bit.bor(GANG_TYPE_PG, GANG_TYPE_HUA), GANG_TYPE_AN), GANG_TYPE_BU)
CONTROL_TYPE_PENG = PENG_TYPE_P
CONTROL_TYPE_CHI = bit.bor(bit.bor(CHI_TYPE_RIGHT, CHI_TYPE_MIDDLE), CHI_TYPE_LEFT)
CONTROL_TYPE_TING = TING_TYPE_T  --用于亮杠牌
CONTROL_TYPE_NONE = 0