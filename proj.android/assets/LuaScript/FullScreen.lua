FullScreen = class()
function FullScreen:ctor()
    self.bg = CCMenu:create()
    local but = CCMenuItemImage:create("images/dark.png", "images/dark.png")
    self.bg:addChild(but)
    self.bg:setPosition(ccp(0, 0))
    but:setAnchorPoint(ccp(0, 0))
    local vs = CCDirector:sharedDirector():getVisibleSize()
    but:setScaleX(vs.width)
    but:setScaleY(vs.height)
    but:setOpacity(0)
    local function onBut()
        print("onFullScreen")
    end
    but:registerScriptTapHandler(onBut)
    --self.bg:setEnabled(false)
end