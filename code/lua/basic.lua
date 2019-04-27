--[[
    截取table的一部分
    @param tb1 
	@param first
	@param last 
	@param step	 
    @return 截取的table
]]
function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

--[[
  合并两个table
  @param table1
@param table2
  @return table1
]]
function table.merge(table1, table2)
  for i = 1, #table2 do
      table1[#table1 + 1] = table2[i]
  end
  return table1
end


--[[
  获取字符串长度 由于编码问题
  @param string
  @return length
]]
function string.get_mixed_string_length(str)
  local len_in_byte = #str    
  local width = 0
  local i = 1
  while(i<=len_in_byte)
  do
      local cur_byte = string.byte(str, i)
      local byte_count = 1
      if cur_byte > 0 and cur_byte < 192 then
          byte_count = 1
      elseif cur_byte >= 192 and cur_byte <= 223 then
          byte_count = 2
      elseif cur_byte >= 224 and cur_byte <= 239 then
          byte_count = 3
      elseif cur_byte >= 240 and cur_byte <= 247 then
          byte_count = 4
      elseif cur_byte >= 248 and cur_byte <= 251 then
        byte_count = 5    
      elseif cur_byte >= 252 then
        byte_count = 6    
      end

      i = i + byte_count
      width = width + 1
  end
  return width
end

--[[
  字符串转时间戳
  @param time_str 形如yyyy-mm-dd[ hh:mm[:ss]
  @return unix秒级时间戳
]]
util.str2time = function(time_str)
  local date = ngx.re.match(tostring(time_str), "^(\\d{4})-(\\d{2})-(\\d{2}).*$")
  -- 格式不符合
  if not date then
      return 0
  end
  -- 年月日
  local Y = date[1]
  local m = date[2]
  local d = date[3]

  local hour = ngx.re.match(tostring(time_str), "^.* (\\d{2}):(\\d{2})(:(\\d{2})|)$") or {}
  -- 时分秒
  local H = hour[1] or 0
  local M = hour[2] or 0
  local S = hour[4] or 0

  return os.time({year = Y, month = m, day = d, hour = H, min = M, sec = S})
end

--[[
  时间戳转字符串
  @param uninx秒级时间戳
  @return 时间字符串，形如yyyy-mm-dd hh:mm:ss
]]
util.time2str = function(time)
  return os.date("%Y-%m-%d %H:%M:%S", tonumber(time))
end