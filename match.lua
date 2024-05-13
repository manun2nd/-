math.randomseed(os.time())

--set_difference 函数接受两个表作为输入，并返回第一个表中存在但第二个表中不存在的元素。
function set_difference(set1, set2)
    local difference = {}
    local set2_elements = {}

    -- 将set2的元素存储到一个表中，以便进行快速查找
    for _, v in ipairs(set2) do
        set2_elements[v] = true
    end

    -- 遍历set1，如果元素不在set2中，则将其添加到差集中
    for _, v in ipairs(set1) do
        if not set2_elements[v] then
            table.insert(difference, v)
        end
    end

    return difference
end

-- --检查两个玩家是否属于同一组
-- local function sameGroup(player1, player2)
--     return math.ceil(player1 / 2) == math.ceil(player2 / 2)
-- end


--匹配函数： 1v1随机匹配，返回匹配后的表
local function generateMatches()
    local playerstmp = {1,2,3,4,5,6,7,8,9,10}
    local already = {} --已经匹配过的，也是最终返回的匹配结果
    
    for i = 1, 4 do
        local illegal = {} --同组的
        --从未匹配过的元素中随机找一个(players本身就是未匹配的，每次我们都会把本轮匹配的2个从players中删除)
        local index1 = math.random(#playerstmp)
        local match1 = playerstmp[index1]
        --print("第",i,"次随机到玩家",match1,"匹配对手------")
        --0、开始找本轮匹配的非法元素（同组的2个 、已经匹配过的）
    
        --寻找它的同组元素
        local sameGroup = 0
    
        if match1%2 ~= 0 then
            sameGroup = match1 + 1 -- 奇数的同组是+1
        else
            sameGroup = match1 - 1--偶数的同组是-1
        end
        --print("该组的玩家为：(", match1 , sameGroup.." )，准备剔除掉同组玩家\n")
        
        --2、完善非法表（添加同组的）
        table.insert(illegal,match1)
        table.insert(illegal,sameGroup)
        --print("illegal table = ",table.concat(illegal,", "))
      
        --3、那么本轮可以选择匹配的表就得出了！players中已经是还未匹配的数据，后面会去除
        local available = set_difference(playerstmp, illegal)
       
        --print('剔除掉同组和已经匹配过的，能匹配的对手只有：',table.concat(available,", "))
    
        --随机挑选对手
        --最后一轮避免留下两个同组的
        local match2 = 0
        local same = {} --如果available出现特殊情况，将两个同组的存入这里

       
        --print("now available = {",table.concat(available,", "),"}")
        match2 = available[math.random(#available)]
      

        if (i == 4) and (#available==3) then
            
            --print("now available = {",table.concat(available,", "),"}")
            
            
            local a1 = available[1]
            local a2 = available[2]
            local a3 = available[3] 
            
            if (  ( (a1+1) == a2 ) and (math.ceil(a1/2) == math.ceil(a2/2)) ) then
                --print("第四次特殊匹配的match1 = ",match1)
                --print("紧急情况！目前available中存在同组的！，本次必须选到这两个同组的其中一个")
                
                table.insert(same , a1)
                table.insert(same , a2)
                print("now match2 must chose one：",table.concat(same,", "))
                match2 = same[math.random(#same)]
                print("第四轮触发特殊匹配：",match1,"--》",match2)
                           
            end
        
            if (  ((a2+1) == a3 ) and (math.ceil(a2/2) == math.ceil(a3/2)) ) then
                --print("第四次特殊匹配的match1 = ",match1)
                --print("紧急情况！目前available中存在同组的！，本次必须选到这两个同组的其中一个")
                
                table.insert(same , a2)
                table.insert(same , a3)
                print("now match2 must chose one：",table.concat(same,", "))
                match2 = same[math.random(#same)]
                print("第四轮发生紧急匹配：",match1,"=》",match2)
                
            
            end

            
            
            
           
        end 
    
        
        --print("随机挑一个吧！！\n--挑选完毕，随机到的对手是：", match2,", 本次匹配结果为：----------(",match1,"-->",match2.." )")
        --4、将本轮匹配过的两个数加入already 、同时在players中去除
        --print("准备插入match1：",match1)
        table.insert(already, match1)
        --print("准备插入match2：",match2)
        table.insert(already, match2)
    
        --print("-----准备从players中剔除本轮成功匹配的2个玩家，他们是：",match1,match2)
        playerstmp = set_difference(playerstmp, already)
        --print('下一轮进行匹配的玩家池为：',table.concat(players,", "),"\n---------------")
       
        
        --print('本轮匹配结束后，已经完成匹配的玩家有：',table.concat(already,", ").."\n")
       
    end--这是for4的end

    --最后剩下的2个玩家不用再匹配了，直接加入already表就行
    for _, value in ipairs(playerstmp) do
            table.insert(already,value)
    end
    print("本轮匹配结果：",table.concat(already,", "))
    return already 
end

-- 自检函数
local function selfCheck(matches)
    --print("正在进行自检：-----------")
    -- 1、检测匹配后的玩家 不属于 预设中同组
    for i = 1, 9, 2 do
        local group1 = math.ceil(matches[i] / 2)
        local group2 = math.ceil(matches[(i+1)] / 2)
        --自检遍历返回的匹配数组
        --print("selfCheckGroup:",matches[i],"--",matches[(i+1)])
        if group1 == group2 then
            print("自检结果1：此组匹配玩家属于同一组！")
            return false
        end
    end
    --print("自检结果1：匹配成功后不存在同组玩家")

    -- 2、检查是否有玩家轮空
    if #matches < 10 then
        print(table.concat(matches,", "))
        print("自检结果2：存在玩家轮空!")
        return false
    end
    --print("自检结果2：无玩家轮空")

    return true,"自检通过"
end

--主函数：
local function main()
    --math.randomseed(os.time())
    --循环100000次保证次都能匹配成功，自检也通过
    for _ = 1, 100000 do
        print("第",_,"轮匹配中：")
        -- 1、1v1匹配
        local matches = generateMatches()
        
        --2、自检：
        local istrue = selfCheck(matches)
        if  istrue then
            print("自检通过！匹配成功！！，生成匹配结果：-----------\n")
            for i = 1, 10, 2 do
                print("匹配结果: ",matches[i],"-->",matches[i+1])
            end

            print("-----------进行下一轮匹配-------------\n")
        else
            print("自检不通过！匹配失败！\n")
            break
        end
        
    end

end
--启动
main()