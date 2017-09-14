local MyApp = class("MyApp")
--3780
function MyApp:ctor()

   
    MyApp.super.ctor(self)
end

function MyApp:run()
    collectgarbage("collect")
    USER_INFO  = {}
    SCENENOW   = {}
    SCENE={}
    bm = {}
    TABLE={}
    WinSize=cc.Director:getInstance():getWinSize()

    display_scene("app.scenes.MainScene")
end


function display_scene(name,flag)

    if not SCENE[name] or flag == 1 then
        local next = require(name).new()
        SCENENOW["scene"] = next
        SCENENOW["name"]  = name
    else
        SCENENOW["scene"] = SCENE[name]
        SCENENOW["name"]  = name
    end
    display.replaceScene(SCENENOW["scene"])
end



return MyApp
