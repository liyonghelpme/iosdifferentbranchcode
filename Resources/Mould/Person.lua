require "Util.Class"

Person = class()

PersonState = {STATE_FREE = 1, STATE_MOVING = 2, STATE_OTHER = 3}

function Person:ctor()
	self.state = PersonState.STATE_FREE
	self.stateInfo = {}
	self.stateTime = 0
	self.displayState = {direction=1}
	self.direction = 1
	self.viewInfo = {scale=1, x=0, y=0}
	self.moveScale = 1
    self.debug = false

    self.depthInfo = nil
end

function Person:setMoveScale(scale)
    local oldScale = self.moveScale
    self.moveScale = scale
    if self.state==PersonState.STATE_MOVING then
        self.displayState.duration = self.displayState.duration*oldScale/scale
        local stateInfo = self.stateInfo
        -- local leftTime = stateInfo.moveTime-(self.stateTime - (stateInfo.beginTime or 0))
        --if leftTime>0 and leftTime<stateInfo.moveTime then
        --    stateInfo.moveTime = stateInfo.moveTime + leftTime*(oldScale/scale-1)
        --end
        self:moveDirect(stateInfo.toPoint[1], stateInfo.toPoint[2], true)
    end
end

--moveArround 是一个build
function Person:getMoveArroundPosition(build)
	local gsize = build.buildData.gridSize
	local sspace = build.buildData.soldierSpace
	local e1, e2 = sspace/2, gsize-sspace/2
	local gx, gy = math.random()*gsize, math.random()*gsize
	if gx>e1 and gx<e2 and gy>e1 and gy<e2 then
		if math.random()>0.5 then
			gx = (gx-e1)/(e2-e1)*sspace
			if gx>e1 then
				gx = gx-e1+e2
			end
		else
			gy = (gy-e1)/(e2-e1)*sspace
			if gy>e1 then
				gy = gy-e1+e2
			end
		end
	end
	local grid = build.buildView.state.backGrid
	if not grid then grid = build.buildView.state.grid end
	local position = build.buildView.scene.mapGrid:convertToPosition(grid.gridPosX + gx, grid.gridPosY + gy)
	return position[1], position[2]
end

function Person:initWithInfo(personInfo)
	self.info = personInfo
end

function Person:changeDirection(dirx, diry)
	local dir = 0
	local t1, t2 = math.abs(dirx), math.abs(diry)
	local t3 
	if t1==0 then
		t3 = 3 - math.ceil(self.direction/3)*2
	else
		t3 = dirx/t1
	end
	if t2<=t1*0.4 then
		dir = 3.5 - 1.5 * t3
	else
		dir = 3.5 + (diry/t2 - 1.5) * t3
	end
	self.direction = dir
end

function Person:moveDirect(tx, ty, isInterupt)
	self.state = PersonState.STATE_MOVING
	local stateInfo = self.stateInfo or {}
	self.stateInfo = stateInfo
	stateInfo.toPoint = {tx, ty}
	local fx, fy = self.view:getPosition()
	stateInfo.fromPoint = {fx, fy}
	local ox, oy = tx-fx, ty-fy
	if isInterupt then
		stateInfo.beginTime = (self.stateTime or 0)
	else
		stateInfo.beginTime = (stateInfo.beginTime or 0) + (stateInfo.moveTime or 0)
	end
	stateInfo.moveTime = self.scene.mapGrid:getGridDistance(ox, oy) * 10/(self.info.moveSpeed*self.moveScale)
	self:changeDirection(ox, oy)
	self:resetPersonView()
end

function Person:getFrameEspecially(i)
	return nil
end

function Person:getFrameName(i, dir, displayState)
	if i<0 then
		i=0
	end
	local ni = self:getFrameEspecially(i)
	if ni then
		i = ni
	else
		if i>=displayState.num then
			if displayState.isRepeat then
				i = i % displayState.num
			elseif displayState.reverse then
				i = 0
			else
				i = displayState.num-1
			end
		end
	end
	if self.onChange and (self.direction ~= displayState.direction or i ~= displayState.frameNumber) then
		self:onChange(self.direction, i)
	end
	displayState.direction = self.direction
	displayState.frameNumber = i
	return displayState.prefix .. dir .. "_" .. i .. ".png"
end

function Person:resetPersonSpriteFrame()
	local flip = false
	local tempDir = self.direction
	if tempDir > 3 then
		tempDir = 7-tempDir
		flip = true
	end
	local displayState = self.displayState
	local t = self.stateTime
	local p = displayState.duration/displayState.num
	self.frameName = self:getFrameName(math.floor(t/p), tempDir, displayState)
	local frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(self.frameName)
	if not frame then
	    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
		CCSpriteFrameCache:sharedSpriteFrameCache():addSpriteFramesWithFile(self.plistFile)
	    CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
		frame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(self.frameName)
	end
	if not frame then
		print(self.frameName)
		while true do
		
		end
	end
	if not self.personView then
		self.personView = CCSprite:createWithSpriteFrame(frame)
		self.personView:setScale(self.viewInfo.scale or 1)
		screen.autoSuitable(self.personView, {nodeAnchor=General.anchorCenter, x=self.viewInfo.x, y=self.viewInfo.y})
		self.view:addChild(self.personView)
		
        if self.nightMode then
            self.personView:setColor(General.nightColor)
        end
	elseif self.frameName ~= self.displayState.frameName then
		self.personView:setDisplayFrame(frame)
	end
	self.displayState.frameName = self.frameName
	self.personView:setFlipX(flip)
end

function Person:resetPersonView()
	local displayState = self.displayState
	local needReset = false
	if self.state ~= displayState.state then
		needReset = true
		displayState.state = self.state
	elseif self.state==PersonState.STATE_OTHER and displayState.action~=self.stateInfo.action then
		needReset = true
		display.action = self.stateInfo.action
	end
	
	if needReset then
		if self.state == PersonState.STATE_FREE then
			self:resetFreeState()
		elseif self.state == PersonState.STATE_MOVING then
			self:resetMoveState()
			self.displayState.duration = self.displayState.duration/self.moveScale
		elseif self.state == PersonState.STATE_OTHER then
			self:resetOtherState()
		end
	end
end

--检测非相邻点之间是否存在障碍物
--将坐标从affine网格坐标转化成笛卡尔坐标
function Person:getTruePath(path, world, mapGrid, fx, fy, tx, ty)
    local newWorld = self.scene.newWorld
    local oldPath = path
	local i = 1
    local j = 3
    local info = {path[1][1], path[1][2], 1}
	local tempPath = {info}
    while j <= #path do
        local ray = Ray.new(path[i], path[j], newWorld)
        local ret = ray:checkCollision()
        if not ret then
            j = j + 1
        else --该位置j发生碰撞 则前一个位置是可以到达的
            i = j-1
            j = i + 2
            --路径的网格坐标 以及在path中的编号
            local info = {path[i][1], path[i][2], i}
            table.insert(tempPath, info)
        end
    end

    local info = {path[#path][1], path[#path][2], #path}
    table.insert(tempPath, info)

    path = tempPath
    --关闭调试功能不调用该函数
    --[[
    if world.debug then
        --设定world中网格属性用于调试
        for i=1, #path, 1 do
            world.cells[world:getKey(path[i][1], path[i][2])]['isReal'] = true
        end
    end
    --]]
	    
	local truePath = {}
    --当返回的路径长度 = 0 需要clearPathCount 中检测路径
	if #path==0 then
		return {{tx, ty, 1}}
	end
	--local curGrid = path[1]
	for i=2, #path-1 do
		local grid = path[i]
		local position = mapGrid:convertToPosition(grid[1]/2, grid[2]/2)
		table.insert(truePath, {position[1], position[2]+mapGrid.sizeY/4, grid[3]})
	end
    --last path position
	table.insert(truePath, {tx, ty, #oldPath})
	return truePath
end
	
function Person:setMoveTarget(tx, ty)
	local fx, fy = self.view:getPosition()
	local mapGrid = self.scene.mapGrid
	local grid = mapGrid:convertToGrid(fx, fy, nil, 2)
	local startPoint = {grid.gridPosX, grid.gridPosY}
	local agrid = mapGrid:convertToGrid(tx, ty, nil, 2)
	local endPoint = {agrid.gridPosX, agrid.gridPosY}
	if self.info.unitType==1 and (startPoint[1]~=endPoint[1] or startPoint[2]~=endPoint[2]) then
		--local w = self.scene.mapWorld
        --[[
		--w:clearWorld()
		w:putStart(startPoint[1], startPoint[2])
		w:putEnd(endPoint[1], endPoint[2])
		local path = w:search(startPoint, endPoint)
        --]]

        local newWorld = self.scene.newWorld
        newWorld.startPoint = ccp(startPoint[1], startPoint[2])
        newWorld.endPoint = ccp(endPoint[1], endPoint[2])
        --经营士兵有移动的目标军旗
        local bid = -1
        if self.moveArround ~= nil then
            bid = self.moveArround.buildView.tempBuildId
        end
        --经营路径复用编号
        newWorld.tempBuildId = bid

        local result = newWorld:searchBusiness()
        if result.path == nil then
            return
        end
        local path = {}
        local len = result.path:getLength() 
        --print("path length is", len)
        for i=0, len-1 do
            local p = result.path:objectAt(i)
            table.insert(path, {p.x, p.y})
        end
        result:delete()

        --local truePath = path
		local truePath = self:getTruePath(path, w, self.scene.mapGrid, fx, fy, tx, ty)

        --设定路径点逻辑 开始下次寻路之前 清理当前的路径点信息
        self:clearAllPath()
        self.gridPath = path
        self.truePath = truePath
        --第一个顶点
        self.setFromToGrid({0, 0, 1}, self.truePath[1])
        self:setPathCount()
        --w:showGrid()



		local firstPoint = table.remove(truePath, 1)
		self.stateInfo = {movePath = truePath}
		self.state = PersonState.STATE_MOVING
		self:moveDirect(firstPoint[1], firstPoint[2], true)
    --空军单位直接移动到目的位置即可
	else
		self:moveDirect(tx, ty, true)
	end
end

--士兵 searchAttack 寻找攻击目标 设定网格gridPath路径 和 真实路径truePath
--setPathCount
--每次移动两个相邻网格 清理网格之间的所有gridPath 的pathCount 计数
--clearPathCount
--当移动到目的地
--finishPath
--当中途突然改变方向
--clearAllPath 清理所有的路径
function Person:setFromToGrid(f, t)
    if f ~= nil and t ~= nil then
        if self.debug then
            print("setFromToGrid"..f[3].." "..t[3])
        end
        self.curGrid = f
        self.nextGrid = t
    end
end

function Person:clearPathCount(from, to)
    --中间不清理路径信息 直到走到目的地才清理
    --[[
    local w = self.scene.mapWorld
    if self.gridPath ~= nil then
        local start = from[3]
        local finish = to[3]
        --print("clearPathCount "..start.." "..finish)
        for i = start, finish, 1 do
            if i <= #self.gridPath then
                w:minusPathCount(self.gridPath[i][1], self.gridPath[i][2])
            end
        end
    end
    ]]--
end

function Person:setPathCount() 
    if self.debug then
        print("setPathCount")
    end
    --local w = self.scene.mapWorld
    --只设定最后一个位置的path count
    local l = #self.gridPath
    --w:addPathCount(self.gridPath[l][1], self.gridPath[l][2])

    local newWorld = self.scene.newWorld
    if newWorld then
        newWorld:addPathCount(self.gridPath[l][1], self.gridPath[l][2])
    end
    --[[
    for k, v in ipairs(self.gridPath) do
        w:addPathCount(v[1], v[2]) 
    end
    ]]--

end
--清理所有的路径信息
function Person:clearAllPath()
    --print("clearAllPath")
    --local w = self.scene.mapWorld
    if self.gridPath ~= nil then
        local l = #self.gridPath
        --w:minusPathCount(self.gridPath[l][1], self.gridPath[l][2])

        local newWorld = self.scene.newWorld
        if newWorld then
            newWorld:minusPathCount(self.gridPath[l][1], self.gridPath[l][2])
        end

        self:finishPath()
    end
end
function Person:finishPath()
    --print("finishPath")
    self.gridPath = nil
    self.truePath = nil
end

function Person:update(diff)
	local stateInfo = self.stateInfo
	if stateInfo.state == "dead" then
	end
    --士兵移动 普通经营页面人物移动
	if self.state == PersonState.STATE_MOVING then
		local moveEnd = true
		if stateInfo.toPoint then
			if not stateInfo.beginTime then
				print("moveStateError")
				while true do end
			end
			if self.stateTime-stateInfo.beginTime < stateInfo.moveTime then
				self.stateTime = self.stateTime + diff
				local delta = (self.stateTime-stateInfo.beginTime)/stateInfo.moveTime
				if delta>1 then delta = 1 end
				if delta<0 then
					print("delta", delta)
				end
				local tempY = stateInfo.fromPoint[2] + delta*(stateInfo.toPoint[2]-stateInfo.fromPoint[2])
				self.view:setPosition(stateInfo.fromPoint[1] + delta*(stateInfo.toPoint[1]-stateInfo.fromPoint[1]), tempY)
					
				self.updateEntry.pause = true
				self.view:retain()
				local parent = self.view:getParent()
                --zorder 决定绘制顺序 来便于alpha 混合
				self.view:removeFromParentAndCleanup(false)
				parent:addChild(self.view,self.maxZorder - tempY)

				self.view:release()
				self.updateEntry.pause = false
				if delta<1 then moveEnd = false end
			end
		end
        --fromPoint toPoint 
        --clearFromPoint to toPoint pathCount--
		if moveEnd then
			if stateInfo.movePath and #(stateInfo.movePath)>0 then
                --清理当前开始到结束为止的网格状态
                self:clearPathCount(self.curGrid, self.nextGrid)
				local point = table.remove(stateInfo.movePath, 1)
                if self.debug then
                    print("point is ")
                    print(point)
                end
                self:setFromToGrid(self.nextGrid, point)
				self:moveDirect(point[1], point[2])
			else --最后一个移动网格
                --在下次移动开始的时候清理路径信息 则能保证防止攻击建筑物的路径冲突
                --self:clearPathCount(self.curGrid, self.nextGrid)
                --self:finishPath()

				self.state = PersonState.STATE_FREE
				self.backStateInfo = self.stateInfo
				self.backTime = self.stateTime
				self.stateInfo = {}
				self.direction = 1
				self.stateTime = 0
			end
		end
	else
		self.stateTime = self.stateTime + diff
	end
	if not self:updateState(diff) then
		self:resetPersonView()
	end
	-- TEST
	if not self.deleted then
		self:resetPersonSpriteFrame()
	end
end

function Person:addShadow()
	local temp = UI.createSpriteWithFile("images/personShadow.png")
	temp:setScale(self.shadowScale or 0.68)
	if self.info.unitType==2 then
	    temp:setOpacity(230)
	end
	screen.autoSuitable(temp, {nodeAnchor=General.anchorCenter})
	self.view:addChild(temp)
end

function Person:addToScene(scene, pos)
    self.scene = scene
	if not pos then
		pos = self:getInitPos()
	end
	
	self.view = CCExtendNode:create(CCSizeMake(0,0), false)
	screen.autoSuitable(self.view, {x=pos[1], y=pos[2]})
    --地面单位
	if self.info.unitType==1 then
		self.maxZorder = scene.SIZEY
		scene.soldierBuildingLayer:addChild(self.view, self.maxZorder-pos[2])
	else
		self.maxZorder = scene.SIZEY+self.viewInfo.y*100
		scene.sky:addChild(self.view, self.maxZorder-pos[2])
	end
	
	self:addShadow()
	
	self.updateEntry = {inteval=0, callback=self.update}
	
	self:resetPersonView()
	simpleRegisterEvent(self.view, {update = self.updateEntry}, self)
	self:updateState(0)
	self:resetPersonSpriteFrame()
end
