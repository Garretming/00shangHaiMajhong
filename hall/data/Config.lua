
local Config = class("Config")

function Config:ctor()

	dump("初始化配置", "-----Config:ctor-----")
 
	--是否打开红屏
	isShowErrorScene = false

	--是否显示网络信息
    isShowNetLog = false

    --是否显示调试信息
    showDumpData = true
 
    --是否显示协议解析信息（要显示解析信息必须先开启dump）
    isDumpProtocol_str = true

    --是否为iOS审核包
	isiOSVerify = false

	--语音视频通过什么发送，1为呀呀，2为游戏服
	mediaSendMode = 2

	--http请求失败，重新请求间隔时间
	request_delayTime = 3

	self:initPath()

	tbErrorCode = {
		[0] = "成功创建新连接",
		[1] = "重连成功",
		[2] = "成功踢其他玩家",
		[3] = "玩家密匙错误",
		[4] = "数据库连接错误",
		[5] = "无此房间",
		[6] = "玩家登录房间错误",
		[7] = "无房间分配",
		[8] = "没有空桌子",
		[9] = "玩家余额不足",
		[10] = "未知错误",
		[11] = "牌型错误",
		[12] = "验证码错误",
		[13] = "比赛房间不存在",
		[14] = "相同IP",
	}

end


resFolder = "168"

function Config:initPath()

	dump("初始化文件访问路径", "-----Config:initPath-----")

	--@zc fir统一地址接口
	local firPath="pm2d"
	COMMON_FIR_PATH="https://fir.im/"..firPath

	-----------------------------------------------------------------------------------------------------------------------------

	--网络相关

	--大厅http请求文件路径
	Request_filePath = "hall.network.http.Request"

	--大厅Socket相关文件路径
	ServerBase_filePath = "hall.ScoketGame"
	HallServer_filePath = "hall.HallServer"
	HallHandle_filePath = "hall.HallHandle"
	HallProtocol_filePath = "hall.HALL_PROTOCOL"

	------------------------------------------------------------------------------------------------------------------------------

	--数据相关

	--应用设置操作
	GameSetting_filePath = "hall.GameSetting"

	--用户数据处理
	GameData_filePath = "hall.GameData"

	--游戏通用操作
	GameCommon_filePath = "hall.GameCommon"

	--游戏列表
	GameList_filePath = "hall.GameList"

	------------------------------------------------------------------------------------------------------------------------------

	--控件相关

	--加载圈
	NetworkLoadingView_filePath = "hall.NetworkLoadingView.NetworkLoadingView"

	--提示弹框(普通)
	CommonTips_filePath = "hall.GameTips"
	CommonTipsCsb_filePath = "hall/scene/res/" .. resFolder .."/tips/LayerTips_new.csb"
	--@zc 20170718  实名认证界面 问题反馈页面
	shiming_CsbPath="hall/scene/res/" .. resFolder .."/shimingrenzheng/shimingrenzheng.csb"
	wenti_CsbPath= "hall/scene/res/" .. resFolder .."/shimingrenzheng/wentifankui.csb"
	--@zc 20170708  --活动页面的滑动效果
	Buy_Card_CsbPath="hall/scene/res/" .. resFolder .."/activity/Activity_buyCard.csb"
	Activity_CsbPath="hall/scene/res/" .. resFolder .."/activity/Activity_Scene.csb"
	Activity_DailiCsbPath="hall/scene/res/" .. resFolder .."/activity/Activity_message.csb"
	Text_csb ="hall/scene/res/" .. resFolder .."/activity/MainScene.csb"
	--@zc 20710711  所有道具的动画文件
	animation_PlistPath="hall/scene/res/" .. resFolder .."/animation/"
	--解散弹框
	DisbandTipsCsb_filePath = "hall/scene/res/" .. resFolder .."/tips/LayerTips_disband.csb"
	NewDisbandTipsCsb_filePath = "hall/scene/res/" .. resFolder .."/tips/LayerTips_disband_new.csb"
	DisbandPlayerCsb_filePath = "hall/scene/res/" .. resFolder .."/tips/Disband_Player_Layer.csb"
	NewDisbandTips_wait_filePath = "hall/scene/res/" .. resFolder .."/image/tip/ic_wait.png"
	NewDisbandTips_agree_filePath = "hall/scene/res/" .. resFolder .."/image/tip/ic_agree.png"
	--@zc 20170727 关于牛牛新加功能的路径
	NiuNiu_CuoPai_Path="niuniu/CuopaiScene.csb"
	------------------------------------------------------------------------------------------------------------------------------

	--资源相关

	--图片
	--默认头像
	DefaultHead_filePath = "hall/scene/res/common/image/defaulthead.png"
	

	--头像外边框
	HeadFrame_filePath = "hall/scene/res/common/image/head_box1.png"

	--头像圆遮罩
	Stnecil_filePath = "hall/scene/res/common/image/head_lord_man.png"

	--iOS分享小图标
	iOSShareIcon_filePath = "hall/scene/res/common/image/shareicon.png"

	--大厅游戏按钮存放目录
	MoreGameButtons_filePath = "hall/scene/res/" .. resFolder .."/image/hall/moregame/"

	--音乐
	--大厅背景音乐
	HallBgm_filePath = "hall/scene/res/common/music/bg_hall.mp3"

	--大厅按钮点击音乐
	HallButtonClickVoice_filePath = "hall/scene/res/common/music/Audio_Button_Click.mp3"

	------------------------------------------------------------------------------------------------------------------------------

	--界面相关
	--结算页面@zc
	GameResult_CommonPuKe_Path="hall/scene/res/" .. resFolder .."/gameResult/GameResult_puke.csb"
	--登录
	LoginScene_filePath = "hall.scene.login.LoginScene"
	LoginSceneCsb_filePath = "hall/scene/res/" .. resFolder .."/login/Login.csb"

	--大厅
	GameScene_filePath = "hall.gameScene"
	GameSceneCsb_filePath = "hall/scene/res/" .. resFolder .."/hall/room_lequ.csb"
	GameSceneIOSVerifyCsb_filePath = "hall/scene/res/" .. resFolder .."/hall/room_lequ_verify.csb"

	--排行榜
	RankCellCsb_filePath = "hall/scene/res/" .. resFolder .."/rank/rankLayer.csb"
	RankListCsb_filePath = "hall/scene/res/" .. resFolder .."/rank/rankingList.csb"
	--创建组局
	CreateGroup_filePath = "hall.scene.group.create.group_create"
	CreateGroupCsb_filePath = "hall/scene/res/" .. resFolder .."/group/create/group_create.csb"
	CreateGroupButtonPic_filePath = "hall/scene/res/" .. resFolder .."/image/hall/hall_creat_tb.png"
	BackGroupButtonPic_filePath = "hall/scene/res/" .. resFolder .."/image/hall/hall_creat_tb.png"

	CreateGroup_TabType_Csb_filePath = "hall/scene/res/" .. resFolder .."/group/create/tab_typeLayer.csb"
	CreateGroup_TabGame_Csb_filePath = "hall/scene/res/" .. resFolder .."/group/create/tab_gameLayer.csb"
	CreateGroup_TabItem_Csb_filePath = "hall/scene/res/" .. resFolder .."/group/create/tab_item_ly.csb"
	CreateGroup_CircleSelect_Csb_filePath = "hall/scene/res/" .. resFolder .."/group/create/circle_select.csb"
	CreateGroup_TickSelect_Csb_filePath = "hall/scene/res/" .. resFolder .."/group/create/tick_select.csb"
	CreateGroup_ConfigShowName_Csb_filePath = "hall/scene/res/" .. resFolder .."/group/create/configShowNameLayer.csb"

	CreateGroup_TabTypeBg_n_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_tab01.png"
	CreateGroup_TabTypeBg_s_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_tab02.png"
	CreateGroup_TabGameBg_n_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_tab03.png"
	CreateGroup_TabGameBg_s_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_tab04.png"
	CreateGroup_Tab_blank_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_tab_blank.png"

	CreateGroup_TabItemBg_n_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_small_tab01.png"
	CreateGroup_TabItemBg_s_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_small_tab02.png"
	CreateGroup_TabItemBg_blank_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/btn_small_blank.png"

	CreateGroup_ConfigRadio_n_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/creat_point_n.png"
	CreateGroup_ConfigRadio_s_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/creat_point_p.png"

	CreateGroup_ConfigCheck_n_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/point01_n.png"
	CreateGroup_ConfigCheck_s_filePath = "hall/scene/res/" .. resFolder .."/image/group/create/point01_p.png"

	--@zc 勾选按钮
	CreateGroup_ConfigCheck_G_filePath ="hall/scene/res/" .. resFolder .."/image/group/create/cjfj_22.png"
	CreateGroup_ConfigCheck_K_filePath ="hall/scene/res/" .. resFolder .."/image/group/create/cjfj_20.png"
	Name_PicPath="hall/scene/res/" .. resFolder .."/image/group/create/name/"
	--加入组局
	JoinGroup_filePath = "hall.scene.group.join.group_join"
	JoinGroupCsb_filePath = "hall/scene/res/" .. resFolder .."/group/join/enter_room.csb"

	--组局管理
	GroupSetting_filePath = "hall.scene.group.GroupSetting"

	--分享
	Share_filePath = "hall.common.ShareLayer"
	ShareCsb_filePath = "hall/scene/res/" .. resFolder .."/share/shareLayer.csb"

	--玩家介绍
	Introduce_filePath = "hall.scene.introduce.introduceScene"
	IntroduceCsb_filePath = "hall/scene/res/" .. resFolder .."/introduce/InstructionLayer.csb"

	--战绩
	Result_filePath = "hall.scene.result.HistoryLayer"
	ResultCsb_filePath = "hall/scene/res/" .. resFolder .."/result/HistoryLayer.csb"

	--设置
	Setting_filePath = "hall.scene.setting.settingScene"
	SettingCsb_filePath = "hall/scene/res/" .. resFolder .."/setting/LayerSetting.csb"

	--单盘结算
	RoundResultCsb_filePath = "hall/scene/res/" .. resFolder .."/gameResult/roundEndingLayer.csb"
    
	--总结算
	TotalResultCsb_filePath = "hall/scene/res/" .. resFolder .."/gameResult/GameResult.csb"
	ResultItemCsb_filePath = "hall/scene/res/" .. resFolder .."/gameResult/GameResult_Item.csb"

	------------------------------------------------------------------------------------------------------------------------------

end

return Config