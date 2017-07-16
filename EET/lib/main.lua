--weidu can't handle regexp in large files (1 MB+) without significant memory usage spikes which can lead to 'out of memory' error
--below code is a direct port of EET_PCU_match macro from lib/macros.tph into pure LUA code which hopefully will fix this problem
--in case of D files also D_DLG_replace and D_traifyDLG_replace patching from macros.tph is implemented
--EET/temp/tables.lua is a temporary file with LUA tables (exactly the same data as weidu EET_PCU_match macro uses + list of files for conversion)

assert(loadfile('EET/temp/tables.lua'))()

function D_traifyDLG_replace(tmp, strref)
	strref = tonumber(strref)
	if strref > 0 and strref < 2999999 then
		strref = tostring(strref + 200000)
	else
		strref = '-1'
	end
	return tmp .. strref
end

function D_DLG_replace(tmp, source)
	source_case = source:upper()
	if remapped_dlg[source_case] ~= nil then
		dest = remapped_dlg[source_case]
		print('Patching ' .. SOURCE_FILESPEC .. ': ' .. source .. ' => ' .. dest .. ' - dlg\n')
		log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. source .. ' => ' .. dest .. ' - dlg\n'
		source = dest
	end
	return tmp .. source
end

log_var = ''
for i=1, #filelist do
	SOURCE_FILESPEC = filelist[i]
	file = io.open(SOURCE_FILESPEC,"r")
	str = file:read("*all")
	file:close()
	if SOURCE_FILESPEC:match('%.[Dd]$') then
		str = str:gsub('EET/TEMP/PATCH/DLG/', '')
		--D_traifyDLG_replace
		str = str:gsub('(SAY #)([0-9]+)', function(m1, m2) return D_traifyDLG_replace(m1, m2) end)
		str = str:gsub('(REPLY #)([0-9]+)', function(m1, m2) return D_traifyDLG_replace(m1, m2) end)
		str = str:gsub('(JOURNAL #)([0-9]+)', function(m1, m2) return D_traifyDLG_replace(m1, m2) end)
		--D_DLG_replace
		str = str:gsub('(BEGIN%s+[~"]?)([A-Za-z0-9#_%-]+)', function(m1, m2) return D_DLG_replace(m1, m2) end)
		str = str:gsub('(EXTERN%s+[~"]?)([A-Za-z0-9#_%-]+)', function(m1, m2) return D_DLG_replace(m1, m2) end)
	end
	str = str:gsub('("[^"\n]+")', function(var)
		var = var:gsub(' ', '#AOspace#')
		return var
	end)
	str = str:gsub('(ActionOverride%([^,]+),([^%s]+)%)%)', '%1) #AOcomma# %2) #AObracket#')
	str = str:gsub('(TriggerOverride%([^,]+),([^%s]+)%)%)', '%1) #AOcomma# %2) #AObracket#')	
	str = str:gsub('([%s~"!])([A-Za-z]+)%(([^%s]+)%)', function(init, cmd, arg)
		cmd_case = cmd:upper()
		array = _G['array_' .. cmd_case] --evaluate table name computed dynamically
		if array ~= nil then
			splRes = false
			chapterUp = 0
			cnt = 0
			arg = arg:gsub('([^,]+)', function(source)
				cnt = cnt + 1
				for i=1, #array do
					if array[i][cnt] ~= nil then
						res = array[i][cnt]
						if tonumber(source) then
							sourceNum = tonumber(source)
						else
							sourceNum = source
						end
						if res == 'tra' and type(sourceNum) == 'number' then
							if sourceNum > 0 and sourceNum < 2999999 then
								source = tostring(sourceNum + 200000)
							else
								source = '-1'
							end
						else--if res ~= 'tra' then
							resref = false
							tmp, tmp2, tmp3 = source:match('^("?)([^"]-)("?)$')
							if tmp == '"' and tmp3 == '"' then
								source = tmp2
								resref = true
							end
							if source ~= '' then
								source_case = source:upper()
								if res == 'var' and source_case == 'CHAPTER' then
									chapterUp = 1
								end
								if res == 'dv' then
									--EnemyAlly<-General<-Race<-Class<-Specifics
									if source_case:match('%[[A-Z0-9]+%.[A-Z0-9]+%.') then
										source = source:gsub('(%[[A-Z0-9]+%.[A-Z0-9]+%.)([A-Z0-9]*)(%.?)([A-Z0-9]*)(%.?)([A-Z0-9]*)', function(m1, m2, m3, m4, m5, m6)
											if m2 ~= '' and m2 ~= '0' and remapped_race[m2] ~= nil then
												dest = remapped_race[m2]
												print('Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m2 .. ' => ' .. dest .. ' - race')
												log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m2 .. ' => ' .. dest .. ' - race\n'
												m2 = dest
											end
											if m4 ~= '' and m4 ~= '0' and remapped_class[m4] ~= nil then
												dest = remapped_class[m4]
												print('Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m4 .. ' => ' .. dest .. ' - class')
												log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m4 .. ' => ' .. dest .. ' - class\n'
												m4 = dest
											end
											if m6 ~= '' and m6 ~= '0' and remapped_spec[m6] ~= nil then
												dest = remapped_spec[m6]
												print('Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m6 .. ' => ' .. dest .. ' - spec')
												log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m6 .. ' => ' .. dest .. ' - spec\n'
												m6 = dest
											end
											return m1 .. m2 .. m3 .. m4 .. m5 .. m6
										end)
									--object.ids
									elseif source_case:match('^(.+%(")') then
										print(source_case)
										source = source:gsub('^(.+%(")([^"]+)(")', function(m1, m2, m3)
											if remapped_dv[m2] ~= nil then
												dest = remapped_dv[m2]
												print('Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m2 .. ' => ' .. dest .. ' - dv')
												log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. m2 .. ' => ' .. dest .. ' - dv\n'
												m2 = dest
											end
											return m1 .. m2 .. m3
										end)
									--normal DV
									elseif remapped_dv[source_case] ~= nil then
										dest = remapped_dv[source_case]
										print('Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. source .. ' => ' .. dest .. ' - dv')
										log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. source .. ' => ' .. dest .. ' - dv\n'
										source = dest
									end
								else
									subarray = _G['remapped_' .. res]
									if subarray[source_case] ~= nil and (res ~= 'chapter' or chapterUp == 1) then
										dest = subarray[source_case]
										print('Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. source .. ' => ' .. dest .. ' - ' .. res)
										log_var = log_var .. 'Patching ' .. SOURCE_FILESPEC .. ': ' .. cmd .. ' - ' .. source .. ' => ' .. dest .. ' - ' .. res .. '\n'
										source = dest
										if res == 'splRes' then
											splRes = true
											resref = true
										end
									end
								end
							end
							if resref then
								source = '"' .. source .. '"'
							end
						end
					end
				end
				return source
			end)
			if splRes then
				arg = arg:gsub('([^,]+),([^,]+)', '%2,%1')
				cmd = cmd .. 'RES'
			end
		end
		return init .. cmd .. '(' .. arg .. ')'
	end)
	str = str:gsub('%) #AOcomma# ([^ ]+) #AObracket#', ',%1)')
	str = str:gsub('#AOspace#', ' ')
	file = io.open(SOURCE_FILESPEC,"w+")
	file:write(str)
	file:close()
end

file = io.open('EET/temp/bash.debug',"w+")
file:write(log_var)
file:close()
