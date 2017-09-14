--
-- Author: tao
-- Date: 2016-03-16 12:39:22
-- 
--

require("cocos.framework.extends.UIWidget")
local Widget = ccui.Widget

function Widget:onTouch(callback)
    self:addTouchEventListener(function(sender, state)
        local event = {x = 0, y = 0}
        if state == 0 then
            event.name = "began"
        elseif state == 1 then
            event.name = "moved"
        elseif state == 2 then
            event.name = "ended"
        else
            event.name = "cancelled"
        end
        event.target = sender
        callback(event)
    end)
    return self
end



local Node=cc.Node
function Node:gsize()
    -- body
    return {width=self:getContentSize().width,height=self:getContentSize().height}
end
function Node:ssize(width,height)
    -- body
    return self:setContentSize(width,height)
end

function Node:getWidth()
    return self:gsize().width
end

function Node:getHeight()
    return self:gsize().height
end

function Node:getPosition()
    return {x=self:getPositionX(),y=self:getPositionY()}
end

--点击的处理
local playdefine_sound=""--默认播放的声音
local btnsoundoff=false --按钮声音的开关
function Node:onClick(callback,playSound)
    --if  not self.noScale then 
        --todo
            self:setAnchorPoint(cc.p(0.5,0.5))
    --end

    local isWidget=false

    self:setTouchEnabled(true);
    playSound=playSound or playdefine_sound

    local function clickCallfun(event)
        print("click onClick")

        if event.name=="began" then --按下
            --todo
            if not self.noScale then
                self:setScale(0.8)
            end
            if self.isNetClick then
                --todo
                self:setTouchEnabled(false)
            end
    
        end
        
        if event.name=="ended" then
            --todo
            if btnsoundoff then
                --todo
                audio.playEffectSound(playSound, false)
            end

            if not tolua.isnull(self) then
                --todo
                if not self.noScale then
                    self:setScale(1)
                end
                event.target=event.target or self;
                callback(event.target)
            end
            
        end

        if not isWidget then
            --todo
            print("notISWidget")
            return true-- false吞噬事件   true   不吞噬事件  
        end

    end

  
    if self.onTouch then -- is widget
        --todo
        isWidget=true
        self:onTouch(clickCallfun)
       
    else --is node quick 
        isWidget=false 
        self:setTouchSwallowEnabled(false)  
        self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)  
        self:addNodeEventListener(cc.NODE_TOUCH_EVENT, clickCallfun)  
    end
end


cct=cct or {}
local isFirst=false
function cct.luataoPrint(...)
    -- body
    if device.platform~="windows" then
    	return;
    end

    local tbpri={...}
    local str=""
    for i,v in ipairs(tbpri) do
        if type(v)=="table" then
            dump(v)
        else
            str=str..v.."  "
        end
    end

    local file
    if not isFirst then
        --todo
        file = io.open("./taoLog.log","w")
        isFirst=true
    else
        file = io.open("./taoLog.log","a")
    end
    io.output(file)
    io.write(str.."\n")
    io.close(file)
end


--创建一个http请求
function cct.httpReq1(parm)
    local url=parm.url;
    local date=parm.date or parm.data or  {}
    local callBack=parm.callBack 
    local type_=parm.type_ or "POST"
    local arg=parm.arg or {}
    -- body
    local function reqCallback(event)
        -- body
        local ok = (event.name == "completed")
        local request = event.request
     
        if not ok then
            -- 请求失败，显示错误代码和错误消息
            print(request:getErrorCode(), request:getErrorMessage())
            if request:getErrorCode()~=0 then
                --todo
                local function call(code)
                    if code=="canle" then
                            --todo
                        -- cc.Director:getInstance():endToLua()
                        -- os.exit(0);
                    else
                        cct.httpReq1(parm)
                    end
                end
                require("app.HallUpdate"):showTips("接口"..parm.urls.."请求异常，请检查网络",1,call)

                --callBack(parm,request:getErrorMessage())
            end
            --
            return
        end

     
        local code = request:getResponseStatusCode()

        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            print("getHttp error",code,url)
            local function call(code)
                    if code=="canle" then
                            --todo
                        -- cc.Director:getInstance():endToLua()
                        -- os.exit(0);
                    else
                        cct.httpReq1(parm)
                    end
                end
                require("app.HallUpdate"):showTips("接口"..parm.urls.."请求异常，请检查网络",1,call)

                --callBack(parm,request:getErrorMessage())

            return
        end
     
        -- 请求成功，显示服务端返回的内容
        local response = request:getResponseString()
        arg.net=event
        arg.netData=response

        callBack(arg,parm)

        --xpcall(callBack, cct.runErrorScene,arg)
        --callBack(json.decode(response))

    end

    print(type_)
    if type_=="GET" then
        local str="?"
        for k,v in pairs(date) do
            str=str..k.."="..v.."&"
        end
        url=url..str
    end
    print("getHttpUrl",url);
    local request = network.createHTTPRequest(reqCallback, url, type_)
    request:addRequestHeader ( cc.XMLHTTPREQUEST_RESPONSE_STRING)
   -- request:addRequestHeader('Content-Type:application/x-www-form-urlencoded')
    if type_=="POST" then
        for k,v in pairs(date) do
            request:addPOSTValue(k, v)
        end
    end
    request:setTimeout(30)
    -- 开始请求。当请求完成时会调用 callback() 函数
    request:start()
    return request
end

--local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
function cct.httpReq2(parm)
    --req.new(parm)
    --local httpAre=HttpAddr

    --if parm.isnew then
        --todo
    --    httpAre=NewHttpAddr
   -- end
    parm.urls=parm.url
    --parm.url=httpAre..parm.url

    cct.httpReq(parm)
end

function cct.httpReq(parm)
    local url=parm.url;
    local date=parm.data or parm.date or  {}
    local callBack=parm.callBack 
    local type_=parm.type_ or "POST"
    local arg=parm.arg or {}
    local requType=parm.requType or cc.XMLHTTPREQUEST_RESPONSE_JSON
    --local timeOut=parm.timeOut
    local oldapi=parm.oldapi

    local handle = 1

    local xhr = cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON

    url=url.."?"
    for k,v in pairs(date) do
        url=url..k.."="..v.."&"
    end
    xhr:open(type_, url)

    print("send http require",url)

    local function onReadyStateChanged()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            -- if timeOut then
            --     --todo
            --     scheduler.unscheduleGlobal(handle);
            -- end
            local response   = xhr.response
            local output = response 
            if oldapi then
                --todo
                arg.net=xhr
                arg.netData=response
                callBack(arg)
            else
                if requType==cc.XMLHTTPREQUEST_RESPONSE_JSON then
                    --todo
                    output = json.decode(response,1)
                end

                callBack(output,parm)
            end
            

        else
            print("xhr.readyState is:", xhr.readyState, "xhr.status is: ",xhr.status)

            cct.httpReq(parm)

        end

        xhr:unregisterScriptHandler()

    end

    xhr:registerScriptHandler(onReadyStateChanged)
    xhr:send()

end

cct.createHttRq=function(parm)
     parm.oldapi=true
    -- --req.new(args)
    -- local httpAre=HttpAddr

    -- if parm.isnew then
    --     --todo
    --     httpAre=NewHttpAddr
    -- end

    parm.urls=parm.url
  --  parm.url=httpAre..parm.url


    cct.httpReq2(parm)
end

function cct.seekNode(root,seekVal)
    if not root then
        --todo
        return null
    end
    local t=type(seekVal)
    if t=="string" then
        --todo
        if root:getName()==seekVal then
            return root;
        end
    else
        if root:getTag()==seekVal then
            return root;
        end
    end
    local rootChildren=root:getChildren()
    for k,v in pairs(rootChildren) do
        local _root=v
        if _root then
            --todo
            local node=nil
            if t=="string" then
                node=cct.seekNode(_root,seekVal)
            else
                node=cct.seekNode(_root,seekVal)
            end
            if node then
                return node
            end
        end

    end

    return nil;
end

function Node:getNode(name)
    local node=nil
    local t=type(name)
    if t=="string"  then
        --todo
        if name=="" then
            --todo
            return node;
        end
        node=self:getChildByName(name)
    else
        node=self:getChildByTag(name)
    end
    
    if not node then
        node=cct.seekNode(self,name)
    end
    return node;
end

-- function Node:getChildByName(name)
--     return self:getNode(name);
-- end

function cct.getTabMax(tb,key)
    -- body
    local max=0
    for k,v in pairs(tb) do
        if key then
           v=v[key]
        end
        if type(v)=="number" then
            --todo
            if v>max then
                --todo
                max=v;
            end
        end 
    end
    return max
end


--quick date save callback 
--gamestate is save game 
--GameState.save(GameData)
if not GameState then
    --todo
    GameState = require(cc.PACKAGE_NAME .. ".cc.utils.GameState")
    GameState.init(function(parm)
        local returnVal=nil
        if parm.name=="load" then --载入
            -- {
            -- name   = "load",
            -- values = values,
            -- encode = encode,
            -- time   = os.time()
            -- }
            --todo

            if parm.errorCode  then --载入异常
                --todo
                --GameState.ERROR_INVALID_FILE_CONTENTS //不合法的文件内容，即取出来的内容不是一个table 
                -- GameState.ERROR_HASH_MISS_MATCH //文件被人为更改过 
                -- GameState.ERROR_STATE_FILE_NOT_FOUND //文件不存在 
                return returnVal
            end
            returnVal=parm.values
        elseif parm.name=="save" then
            --values = newValues,
            returnVal=parm.values 
            -- {
            --     name   = "save",
            --     values = newValues,
            --     encode = type(secretKey) == "string"
            -- }
        end
        return returnVal;
    end)
    GameData={}
    GameData=GameState.load() or {};
end


--从App获取数据

function cct.getDataForApp(method,args,sig)

    if type(method) ~="string" then
        --todo
        return;
    end
    local retval
    if device.platform=="ios" then
        --todo
        -- local args = args or {}
        local luaoc = require "cocos.cocos2d.luaoc"
        local className =ios_class

        local ok,ret
        if table.nums(args) > 0 then
            --todo
            ok,ret  = luaoc.callStaticMethod(className,method,args)
        else
            ok,ret  = luaoc.callStaticMethod(className,method)
        end
        if not ok then
            cc.Director:getInstance():resume()
        else
            retval=ret
        end
    elseif device.platform=="android" then
        --todo
        local args =args or {}
        local luaj = require "cocos.cocos2d.luaj"
        local className =luaJniClass

         local sigs="("
         for k,v in pairs(args) do
             local t=type(v)
             if t=="string" then
                 --todo
                 sigs=sigs.."Ljava/lang/String;"
             elseif t=="number" then
                 sigs=sigs.."I"
             end
         end
         sigs=sigs..")"
         sigs=sigs..sig


        local ok,ret  = luaj.callStaticMethod(className,method,args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            retval = ret
        end
    else

    end

    return retval
end

cct.getDateForApp=cct.getDataForApp

cct.display_scenes = function(path)
    SCENENOW=SCENENOW or {}
    SCENES_NOW=SCENES_NOW or {}
    SCENENOW["name"]  = path;
    local scene=require(path).new()
    SCENENOW["scene"] = scene
    display.replaceScene(scene)
end

-- Compatibility: Lua-5.1
function cct.split(str, pat)


   -- local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   -- local fpat = "(.-)" .. pat
   -- local last_end = 1
   -- local s, e, cap = str:find(fpat, 1)
   -- while s do
   --    if s ~= 1 or cap ~= "" then
   --   table.insert(t,cap)
   --    end
   --    last_end = e+1
   --    s, e, cap = str:find(fpat, last_end)
   -- end
   -- if last_end <= #str then
   --    cap = str:sub(last_end)
   --    table.insert(t, cap)
   -- end
   -- return t
    return string.split(str,pat);
end

---- 通过日期获取秒 yyyy-MM-dd HH:mm:ss
function cct.GetTimeByDate(r)
    local a = cct.split(r, " ")
    local b = cct.split(a[1], "-")
    local c = cct.split(a[2], ":")
    local t = os.time({year=b[1],month=b[2],day=b[3], hour=c[1], min=c[2], sec=c[3]})
    return t;
end

--设置当前表只读
function cct.setTableOnRead(t)
    local temp= t or {} 
    local mt = {
        __index = function(t,k) return temp[k] or printError("error seek table %s not found", k) end;--查key
        __newindex = function(t, k, v) --设置表值
            error("attempt to update a read-only table!")
        end
    }
    setmetatable(temp, mt) 
    return temp
end




-- 移除表中的值
function cct.tableremovevalue(array,value,removeall)
    return table.removebyvalue(array, value, removeall)
end

-- tiemr 秒 返回 str00:00:00
--v 显示的数目
function cct.timerstostr(times,v)

    --timer is sec
    local h=0
    local m=0
    local s=0
    local function toStr(m_)
        local str=""
        if m_==0 or m_=="0" then
            --todo
            str="00"
        elseif m_<10 then
            --todo
            str="0"..m_
        elseif m_>99 then
            str="99"
        else
            str=m_
        end

        return str
    end
    if times>60*60 then
            --todo
        h=math.floor(times/(60*60))
        times=times-h*(60*60)
    end
    
    if times>60 then
            --todo
        m=math.floor(times/(60))
        times=times-m*(60)
    end
    s=math.floor(times)

    local str=""

    if v==1 then
        --todo
        str=toStr(s);
    elseif v==2 then
        str=toStr(m)..":"..toStr(s)
    else
        str=toStr(h)..":"..toStr(m)..":"..toStr(s)
    end
    

    return str;
end

--从内存中卸载没有使用 Sprite Sheets 删除材质 
--  purgeCachedData  删除所有的缓存
function cct.removeUnusedSpriteFrames()
    display.removeUnusedSpriteFrames()
end

--裁剪规则的图片
--通过自定义字典
function cct.addSpriteFrames(dict,png)
    display.addImageAsync(png, function()end)
    for k,v in pairs(dict) do
       local spr = cc.SpriteFrame:create(png,v)
       cc.SpriteFrameCache:getInstance():addSpriteFrame(spr,k);
    end
    cc.TextureCache:getInstance():removeTextureForKey(png)
end


function cct.nodeActionRepeat(node,callBack,delay)
    node:runAction(cc.RepeatForever:create(
            cc.Sequence:create(
                    cc.DelayTime:create(delay or 1),
                    cc.CallFunc:create(callBack)
                )
        ))
end


local ListView = ccui.ListView
function ListView:onEvent(callback)
    self:addEventListener(function(sender, eventType)
        local event = {}
        if eventType == 0 then
            event.name = "ON_SELECTED_ITEM_START"
        else
            event.name = "ON_SELECTED_ITEM_END"
        end
        event.target = sender
        callback(event)
    end)
    return self
end


cct.runErrorScene=function (msg)
    if not isShowErrorScene then --不显示错误的提示
        --todo
        print("监听到错误")
        -- print("App  is error");
        -- require("app.MyApp").new():run()
        return
    end
    
    --display.removeUnusedSpriteFrames()

    local lab=display.newTTFLabel({
        text = msg,
        font = "Arial",
        size = 18,
        color = cc.c3b(255, 0, 0), -- 使用纯红色
        align = cc.TEXT_ALIGNMENT_LEFT,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
        dimensions = cc.size(960, 540)}
    )

    print("runErrorScene by tao")
    lab:setAnchorPoint(0,0)
    local scene=cc.Scene:create()
    scene:addChild(lab)
    display.replaceScene(scene)
   
    if bm.SocketService then
        --todo
        bm.SocketService:disconnect();
    end

    cc.Director:getInstance():pause();
    --pause thread
    --os.execute("ping -n " .. tonumber(1+1) .. " localhost > NUL")

 end


function cct.tableSplice(table,start,endin)
    endin=endin or #table
    start=start or 1
    local tab={}
    for i=start,endin do
        table.insert(tab,table[i])
    end
    return tab
end



function cct.getScreenPic(png_name)
    print("luaCall 截屏",png_name)
    local function afterCaptured(succeed,sp_png)
        if succeed then
            print("截屏success",sp_png)
            cct.getDataForApp("captureScreen_success",{sp_png},"V")
        end
    end
    cc.utils:captureScreen(afterCaptured,"gameScreen.png")
end

-- ´òÓ¡table
function print_lua_table (lua_table, indent)
    if lua_table == nil or type(lua_table) ~= "table" then
        return
    end

    local function print_func(str)
        print("[Dongyuxxx] " .. tostring(str))
    end
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print_func(formatting)
            print_lua_table(v, indent + 1)
            print_func(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print_func(formatting..szValue..",")
        end
    end

end

function _LOG(str)
    print(str)

    if device.platform == "android" then
        local args = { str , Lua_Log }
        local sigs = "(Ljava/lang/String;I)V"
        local luaj = require "cocos.cocos2d.luaj"
        local className = luaJniClass

        local ok,ret  = luaj.callStaticMethod(className,"Lua_Log",args,sigs)
        if not ok then
            print("Lua_Log luaj error:", ret)
        end
    end
end
