--Merge multiple TRA files into 1 (workaround for WeiDU APPEND_FILE size limit)
file = io.open('EET/temp/append.tra',"r")
str = file:read("*all")
file:close()

file = io.open('EET/base/blank.tra',"r")
str = str .. file:read("*all")
file:close()

file = io.open('EET/temp/bgee.tra',"r")
str = str .. file:read("*all")
file:close()

file = io.open('EET/temp/string_set.tra',"w+")
file:write(str)
file:close()
