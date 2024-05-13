math.randomseed(tostring(os.time()):reverse():sub(1, 7))
-- 自定义的表包含方法
local contains = function (table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local table_equal =function (a, b)
    if #a ~= #b then
     return false
    end
    
    for i = 1, #a do
        if a[i] ~= b[i] then
         return false
        end
    end
    --两张表元素相等
    return true
end


--math.randomseed(os.time())

-- 套装类
local Set = {
    collected = {}
}
Set.__index = Set

function Set.new()
    local self = setmetatable({}, Set)
    return self
end

function Set:collect(item)
    table.insert(Set.collected, item)
end

--是否集齐套装所有部位
function Set:isComplete()
    local requiredItems = {"火焰剑", "火焰甲", "火焰盔", "火焰靴"}
    for _, requiredItem in ipairs(requiredItems) do
        if not contains(Set.collected, requiredItem) then
            return false
        end
    end
    return true
end

-- 掉落类
local Drop = {}
Drop.__index = Drop

function Drop.new()
    local self = setmetatable({}, Drop)
    self.items = {"火焰剑", "火焰甲", "火焰盔", "火焰靴","火焰戒指","火焰项链"}
    self.dropCount = 0
    return self
end
-- 掉落规则
function Drop:drop()
    self.dropCount = self.dropCount + 1
    
    --<=4次，正常随机掉落
    if self.dropCount <= 6 then
        local index = math.random(#self.items)
        print("第",self.dropCount,"次掉落:",self.items[index].."\n")
        return self.items[index]
    --触发保底机制
    else
        local missingItems = {}
        for _, item in ipairs(self.items) do
            if not contains(Set.collected, item) then
                table.insert(missingItems, item)
            end
        end
        print("由于掉落次数超过4次仍未集齐套装，本次掉落将触发保底机制，仅掉落如下装备中的一种:",table.concat(missingItems, " "))
        local index = math.random(#missingItems)
        print("第",self.dropCount,"次掉落:",missingItems[index].."\n")
        return missingItems[index]
    end
end



-- 主函数
local function main()
    local flameSet = Set.new()
    local fireDrop = Drop.new()
    

    for i = 1, 10000 do
        if math.random() > 0.5 then
            print("第", i,"轮: 成功击杀火焰怪并掉落装备！")
            --掉落装备！
            local droppedItem = fireDrop:drop()
           -- print(droppedItem.."\n")
            flameSet:collect(droppedItem)

            if flameSet:isComplete() then

                print("已经集齐了火焰套装！, 将退出循环。")
                -- 停止程序运行
                os.exit()
            end
        else
            print("第", i,"轮:脸也太黑了！什么都没掉落!\n")
        end
    end
end

-- 运行主函数
main()
