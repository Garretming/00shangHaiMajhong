
local AppMessage = class("AppMessage")

function AppMessage:ctor()

	dump("初始化应用信息", "-----AppMessage:ctor-----")

	---------------------------------------------------乐趣棋牌---------------------------------------------------
	-- --应用名称
	-- appName = "乐趣娱乐"

	-- --资源目录
	-- resFolder = "lequ"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到乐趣娱乐!"

	-- --下载页地址
	-- appDownLoadAddress = "http://www.doudougame.cn/app/lqqp.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AK0r"

	-- --是否包含代理功能
	-- isAgentMode = true

	-- --是否包含购买功能
	-- isBuyCardMode = true

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = false

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false

	-- --是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false

	---------------------------------------------------和谐号棋牌---------------------------------------------------
	--应用名称
	--[[ms
	appName = "和谐号棋牌"

	--资源目录
	resFolder = "168"

	--走马灯默认显示
	braodComponentDefaulMessage = "欢迎来到和谐号棋牌!"

	--下载页地址
	appDownLoadAddress = "http://www.doudougame.cn/app/hexiehao.html"

	--魔窗链接
	moChuanMLink = "https://appiqy.mlinks.cc/AKtV"

	--是否包含代理功能
	isAgentMode = false

	--是否包含购买功能
	isBuyCardMode = true

	--是否不显示购买房卡
	isNotShowBuyCard = true

	--是否显示地图logo
	isShowMapLogo = false

	--是有显示互动表情
	isShowAnimView = true

	--是否显示聊天室
	isShowChatRoom = false

	--是否显示赠送房卡
	isShowGiveCard = false

	--是否显示绑定代理
	isShowBindAgent = false

	---------------------------------------------------139测试---------------------------------------------------
	-- --应用名称
	-- appName = "139测试"

	-- --资源目录
	-- resFolder = "168"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "139测试"

	-- --下载页地址
	-- appDownLoadAddress = "https://fir.im/139test"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKb2"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = true

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = true

	-- --是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = true

	---------------------------------------------------佰晟棋牌---------------------------------------------------
	-- --应用名称
	-- appName = "佰晟棋牌"

	-- --资源目录
	-- resFolder = "168"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到佰晟棋牌!"

	-- --下载页地址
	-- appDownLoadAddress = "http://www.doudougame.cn/app/bsmj.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKP0"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = true

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = false

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = true

	-- --是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false

	---------------------------------------------------汇友棋牌---------------------------------------------------
	-- --应用名称
	-- appName = "汇友棋牌"

	-- --资源目录
	-- resFolder = "lequ"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到汇友棋牌!"

	-- --下载页地址
	-- appDownLoadAddress = "http://www.doudougame.cn/app/huiyou.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKJP"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false

	-- 是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false

	---------------------------------------------------金德棋牌---------------------------------------------------
	-- --应用名称
	-- appName = "金德棋牌"

	-- --资源目录
	-- resFolder = "lequ"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到金德棋牌!"

	-- --下载页地址
	-- appDownLoadAddress = "http://www.doudougame.cn/app/jdqp.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKDe"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = false

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false

	-- 是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false

	---------------------------------------------------微友棋牌---------------------------------------------------
	-- --应用名称
	-- appName = "微友麻将"

	-- --资源目录
	-- resFolder = "lequ"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到微友麻将!"

	-- --下载页地址
	-- appDownLoadAddress = "http://120.76.97.91:8080/app/wy.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKJ3"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = false

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false

	-- 是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false
	
	-- -------------------------------------------------微友浙江娱乐---------------------------------------------------
	-- --应用名称
	-- appName = "微友浙江娱乐"

	-- --资源目录
	-- resFolder = "lequ"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到微友浙江娱乐!"

	-- --下载页地址
	-- appDownLoadAddress = "http://120.76.97.91:8080/app/wy.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKJ3"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = false

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false

	-- 是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false
	
	-------------------------------------------------789game---------------------------------------------------
	-- 	--应用名称
	-- 	appName = "789棋牌游戏"

	-- 	--资源目录
	-- 	resFolder = "lequ"

	-- 	--走马灯默认显示
	-- 	braodComponentDefaulMessage = "欢迎来到789棋牌游戏!"

	-- 	--下载页地址
	-- 	appDownLoadAddress = "http://download.789youxi.com/"

	-- 	--魔窗链接
	-- 	moChuanMLink = "https://appiqy.mlinks.cc/AK3b"

	-- 	--是否包含代理功能
	-- 	isAgentMode = false

	-- 	--是否包含购买功能
	-- 	isBuyCardMode = true

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false

	-- 是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false
	
	-------------------------------------------------凑角---------------------------------------------------
	-- --应用名称
	-- appName = "凑角棋牌"

	-- --资源目录
	-- resFolder = "168"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到凑角棋牌!"

	-- --下载页地址
	-- appDownLoadAddress = "https://www.doudougame.cn/app/coujiao.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AKb6"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = true

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = false

	-- --是否显示地图logo
	-- isShowMapLogo = true

	-- --是有显示互动表情
	-- isShowAnimView = true

	-- -- 是否显示聊天室
	-- isShowChatRoom = true

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = true
	
	---------------------------------------------玩得疯---------------------------------------------------
	-- --应用名称
	-- appName = "玩的疯棋牌"

	-- --资源目录
	-- resFolder = "lequ"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到玩的疯棋牌"

	-- --下载页地址
	-- appDownLoadAddress = "https://www.doudougame.cn/app/wdfqp.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AK3m"

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = false

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false
	
	-- --是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false

	---------------------------------------------带控---------------------------------------------------
	-- --应用名称
	-- appName = "玩的疯棋牌"

	-- --资源目录
	-- resFolder = "168"

	-- --走马灯默认显示
	-- braodComponentDefaulMessage = "欢迎来到玩的疯棋牌"

	-- --下载页地址
	-- appDownLoadAddress = "https://www.doudougame.cn/app/wdfqp.html"

	-- --魔窗链接
	-- moChuanMLink = "https://appiqy.mlinks.cc/AK3m"

	-- --是否带控
	-- isControl = true

	-- --是否包含代理功能
	-- isAgentMode = false

	-- --是否包含购买功能
	-- isBuyCardMode = false

	-- --是否不显示购买房卡
	-- isNotShowBuyCard = true

	-- --是否显示地图logo
	-- isShowMapLogo = false

	-- --是有显示互动表情
	-- isShowAnimView = false
	
	-- --是否显示聊天室
	-- isShowChatRoom = false

	-- --是否显示赠送房卡
	-- isShowGiveCard = false

	-- --是否显示绑定代理
	-- isShowBindAgent = false
	]]

	-- --是有显示互动表情
	isShowAnimView = true



end

return AppMessage