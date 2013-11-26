require "Miao.PressMenu"
require "Miao.MiaoMap"
TMXMenu = class()
function TMXMenu:ctor(s)
    self.scene = s
    local vs = getVS()
    self.bg = CCNode:create()
    local temp = display.newScale9Sprite("bottom.png")
    self.bg:addChild(temp)
    temp:setContentSize(CCSizeMake(vs.width, 100))
    setAnchor(temp, {0, 0})
    
    local backbut = ui.newButton({image="tabbut.png", conSize={108, 36}, text="地图", size=20, callback=self.onBack, delegate=self})
    setPos(backbut.bg, {135, 45})
    temp:addChild(backbut.bg)

    local vs = getVS()
    local stateLabel = ui.newBMFontLabel({text="state", size=15, font="bound.fnt"})
    self.bg:addChild(stateLabel)
    setAnchor(setPos(stateLabel, {vs.width-200, vs.height-10}), {0, 1})
    self.stateLabel = stateLabel

    local menubut = ui.newButton({image="tabbut.png", conSize={108, 36}, text="菜单", size=20, callback=self.onMenu, delegate=self})
    setPos(menubut.bg, {vs.width-135, 45})
    setScriptTouchPriority(menubut.bg, -256)
    temp:addChild(menubut.bg)
    self.mbut = menubut
    --local function adp()
    --end
    --调整touch 优先级需要在touch处理结束之后 进行 touch中调整没有效果
    --delayCall(1, adp)

    local year = display.newScale9Sprite("yearboard.jpg")
    setAnchor(setPos(setContentSize(year, {268, 39}), {40, vs.height-10}), {0, 1})
    self.bg:addChild(year)
    local t = ui.newTTFLabel({text="0年0月0天", size=20, color={10, 10, 102}})
    setPos(t, {134, 20})
    year:addChild(t)
    self.year = t

    local money = display.newScale9Sprite("numboard.jpg")
    setAnchor(setPos(setContentSize(money, {268, 39}), {vs.width-10, vs.height-10}), {1, 1})
    self.bg:addChild(money)

    local t = ui.newTTFLabel({text="100贯", size=20, color={10, 10, 10}})
    setAnchor(setPos(t, {245, 20}), {1, 0.5})
    money:addChild(t)
    self.money = t

    local season = setSize(setPos(addSprite(self.bg, "spring.png"), {19, fixY(vs.height, 27)}), {30, 30})

    local info = display.newScale9Sprite("info.jpg")
    setAnchor(setPos(setContentSize(info, {vs.width-10, 30}), {vs.width/2, 110}), {0.5, 0.5})
    self.bg:addChild(info)

    local iw = ui.newTTFLabel({text="建筑物", size=20, color={240, 240, 230}})
    setAnchor(setPos(iw, {41, 20}), {0, 0.5})
    info:addChild(iw)
    
    self.infoWord = iw
    self.passTime = 0
    registerEnterOrExit(self)
end
function TMXMenu:enterScene()
    registerUpdate(self)
end
function TMXMenu:onBack()
    local mm = MiaoMap.new()
    global.director:pushScene(mm)
end
function TMXMenu:onMenu()
    if self.menu == nil then
        self.menu = PressMenu.new(self.scene)
        global.director:pushView(self.menu, 1, 0)
        self.mbut.text:setString("返回")
    else
        self.menu = nil
        global.director:popView()
        self.mbut.text:setString("菜单")
    end
end
function TMXMenu:initDataOver()
    self:updateText()
    self:updateYear()
end
function TMXMenu:update(diff)
    self.passTime = self.passTime + diff
    if self.passTime > 1 then
        self.passTime = 0
        self:updateYear()
    end
end
function TMXMenu:updateYear()
    local y, m, w = getDate()
    self.year:setString(str(y).."年"..str(m).."月"..w..'周')
end
function TMXMenu:updateText()
    self.money:setString(Logic.resource.silver.."贯")
end
function TMXMenu:clearMenu()
    self.menu = nil
    self.mbut.text:setString("菜单")
end


