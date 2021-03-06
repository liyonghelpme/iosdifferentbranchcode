Touch = {}
do
	local function compareIndex(a, b)
		return a.index < b.index
	end
	
	local MultiTouch = {}
	MultiTouch.__index = MultiTouch
	
	function MultiTouch:onTouchBegan(id, x, y)
	--[[
		for _, pt in pairs(self.touches) do
			if pt.x == x and pt.y == y then
				self.index = self.index + 1
				pt.index = self.index
				return true
			end
		end
		--]]
		if isTouchInNode(self.view, x, y) then
			self.touchNum = self.touchNum + 1
			--self.index = id
			local touch = {bx=x, by=y, x=x, y=y, index=id}
			self.touches[id] = touch
			self.delegate:executeTouchBegan(self, touch)
			return true
		end
	end
	
	function MultiTouch:onTouchMoved(id, x, y)
		local touches = self.touches
		--[[
		if self.index ~= self.touchNum then
			table.sort(touches, compareIndex)
			for i=1, self.touchNum do
				touches[i].index = i
			end
			self.index = self.touchNum
		end
		--]]
		local touchIndex = (self.touchIndex or 0) + 1
		self.touchIndex = touchIndex
		local touch = touches[id]
		if not self.multi then
			if not touch.isMoved then
				local mov = math.abs(touch.bx - x)*self.XMOVE + math.abs(touch.by - y)*self.YMOVE
				if mov>20 or not isTouchInNode(self.view, x, y) then
					self.delegate:executeTouchMoved(touch, {x=x, y=y})
					touch.isMoved = true
				end
			else
				self.delegate:executeTouchMoved(touch, {x=x, y=y})
			end
		end
		touch.x, touch.y = x, y
		--if touchIndex == self.touchNum then
		--	self.touchIndex = nil
		if self.multi then
			self.delegate:executeTouchesMoved(self)
		end
		--end
	end
	
	function MultiTouch:onTouchEnded(id, x, y)
	--[[
		local rmKey, rmValue = nil
		local min = 1000
		for key, point in pairs(self.touches) do
            local dis = math.abs(point.x-x)+math.abs(point.y-y)
			if dis<min then
                min = dis
				rmKey = key
				rmValue = point
			end
		end
		--]]
		self.touchNum = self.touchNum - 1
		local touch = self.touches[id]
		self.touches[id] = nil
		
		if self.multi then
			self.delegate:executeTouchesEnded(self, touch)
		else
			self.delegate:executeTouchEnded(touch)
		end
	end
	
	function MultiTouch:onTouchCanceled()
		if not self.multi then
			for _, point in pairs(self.touches) do
				self.delegate:executeTouchCanceled(point)
			end
		end
		self.touches = {}
	end
	
	function MultiTouch:new(node, multi, priority, touchDelegate, setting)
		local self = {touches={}, touchNum=0, delegate=touchDelegate, view=node, multi=multi, index=0}
		local params = setting or {}
		self.XMOVE = params.XMOVE or 1
		self.YMOVE = params.YMOVE or 1
		setmetatable(self, MultiTouch)
		
		local layer = CCTouchLayer:create(priority, true)
		layer:setContentSize(node:getContentSize())
		node:addChild(layer)
		local function onTouch(eventType, id, x, y)
			if eventType == CCTOUCHBEGAN then
				return self:onTouchBegan(id, x, y)
			elseif eventType == CCTOUCHMOVED then
				return self:onTouchMoved(id, x, y)
			elseif eventType == CCTOUCHENDED then
				return self:onTouchEnded(id, x, y)
			else
				return self:onTouchCanceled()
			end
		end
		
		local function onEnterOrExit(event)
			if event=="exit" then
				self:onTouchCanceled()
			end
		end
		
		layer:registerScriptTouchHandler(onTouch)
		return self
	end
	
	function Touch.registerMultiTouch(node, multi, priority, touchDelegate, setting)
		return MultiTouch:new(node, multi, priority, touchDelegate, setting)
	end
end