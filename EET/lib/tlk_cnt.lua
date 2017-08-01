--Exports first 14 bytes of the TLK file (workaround for WeiDU COPY size limit)
file = io.open('EET/bgee_dir.txt',"r")
bgee_dir = file:read("*all")
file:close()

file = io.open(bgee_dir .. '/weidu.conf',"r")
lang = file:read(16)
lang = lang:gsub('lang_dir = ', '')
file:close()

file = io.open(bgee_dir .. '/lang/' .. lang .. '/dialog.tlk',"rb")
str = file:read(14)
file:close()

file = io.open('EET/temp/tlk_cnt.txt',"w+")
file:write(str)
file:close()
