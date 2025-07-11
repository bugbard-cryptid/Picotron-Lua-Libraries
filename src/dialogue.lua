--[[pod_format="raw",author="bugbard",created="2025-06-11 23:39:10",icon=userdata("u8",16,16,"0001010101010101010101000000000000010707070707070707060100000000000107070707070707070606010000000001070707070707070706060601000000010707070707070707060606060100000107070707070707070707070701000001070707070707070707070707010000010707070707070707070707070100000107070707070707070707070701000001070d0d0d0d0d0d0d0d0d0d0701000001070d07070707070707070d0701000001070d070d0d0d070d0d070d0701000001070d07070707070707070d0701000001070d0d0d0d0d0d0d0d0d0d0701000001070707070707070707070707010000010101010101010101010101010100"),lowcol_icon=true,modified="2025-07-08 00:58:51",notes="a library to create dialogues by\nwriting the script in a table",revision=1235,title="dialogue.lua",version="v0.3"]]--[[
	make a new dialogue something like this:
		my_dialogue = dialogue.new{
			script = {
				{text = "this is a dialogue line!"},
				{text = "for more details, see the parameters shown below..."}
				{text = "enjoy!!!", anim="whirly"}
			}
		}
--]]

local dialogue = {
	script 		= {
		{
			text="placeholder!",
			spd = 1,
			anim="wavy",
			prepend = "~ ",
			append = " ~"
		},
		{text="use prepend to..."},
		{prepend="use prepend to...", text="make text pause for input!", anim="whirly"},
		{prepend="use prepend to...make text pause for input!", text=" isnt that neat!"},
		{text="i will probably figure out a good way to make it pause mid-line another time..."}
	},
	
	-- values that arent meant to be directly touched
	line_prog 	= 0,	-- progress of current text line
	script_prog = 1,	-- progress of entire script
	tick 			= 0,	-- progress of current letter (depends on line spd)
	
	-- default values for entire dialogue
	x 			= 0,		-- x position
	y 			= 200,	-- y position
	w 			= 479,	-- box width
	h 			= 69,		-- box height - this is 6 lines of text tall
	box 		= true,	-- whether to draw dialogue box or not
	advance 	= true	-- whether to draw button press indicator or not
}

local script_line = {
	-- default values for script lines
	text     = "placeholder! this line will disappear forever once read!",
	spd      = 1,      -- speed text is advanced in frames
	snd      = 0,      -- which sfx to play... make this false to play no sound
	noskip   = false,  -- prevents X to skip
	fast     = false,  -- advance dialogue automatically once end is reached
	anim     = "none", -- valid anims: {"shaky", "wavy", "whirly"}
	prepend  = "",     -- string to prepend to text
	append   = ""      -- string to append to text
}
script_line.__index = script_line

dialogue.__index = dialogue

local ofs = {"f","g","h"} -- used for shaking animation

function dialogue.new(tbl)
	local new = {}
	if tbl then new = tbl end
	
	setmetatable(new, dialogue)
	
	-- reset progress to start
	new.line_prog = 0
	new.script_prog = 1
	
	-- set default state for each line in the script
	for l in all(new.script) do
		if type(l) == "table" then
			setmetatable(l,script_line)
		end
	end
	
	return new
end

function dialogue:update()
	local current_line = self.script[self.script_prog]
	
	if type(current_line) == "table" then		
		-- type current dialogue line
		if self.line_prog < #current_line.text then
			if not current_line.noskip and keyp("x") then
				-- skip to end of current line
				self.line_prog = #current_line.text
				if current_line.snd then sfx(current_line.snd) end
			else
				-- add a letter
				self.tick += 1
				if not current_line.spd or self.tick > current_line.spd then
					self.tick = 0
					local char = sub(current_line.text,self.line_prog,true)
					self.line_prog += 1
					--[[
					repeat -- doing this makes control codes type slightly faster
						local old = sub(self.script[1], 1, self.text)
						self.progress += 1
						current_line.text = sub(current_line.text,2,#current_line.text)
					until #old != self.progress
					--]]
					
					-- play typing sound if character is not punctuation or space
					if count({"!","?",",","."," "},char) == 0 then
						if current_line.snd then sfx(current_line.snd) end
					else -- otherwise... slow down a little on punctuation
						if char == "." or char == "?" or char == "!" then
							self.tick = -current_line.spd * 10
						elseif char == "," then
							self.tick = -current_line.spd * 3
						end
					end
				end
			end
		else
			if keyp("z") or current_line.fast then 
				self.line_prog = 0
				self.script_prog += 1
			end
		end
	elseif type(current_line) == "function" then
		current_line()
	end
end

function dialogue:draw()
	local current_line = self.script[self.script_prog]
	if type(current_line) == "table" then
		if self.box then
			rectfill(
				self.x,
				self.y,
				self.x + self.w,
				self.y + self.h,
			0)
			rect(
				self.x,
				self.y,
				self.x + self.w,
				self.y + self.h,
			7)
		end
		-- print text
		local str = sub(current_line.text, 1, self.line_prog)
		if current_line.anim == "shaky" then
			local str_old = str
			str = ""
			
			while #str_old > 0 do
				local x = ceil(rnd(2))
				local y = ceil(rnd(2))
				str ..= "\+"..ofs[x]..ofs[y]
				str ..= sub(str_old,1,true)
				str_old = sub(str_old,2,#str_old)
				str ..= "\+"..ofs[#ofs-x+1]..ofs[#ofs-y+1]
			end
		elseif current_line.anim == "wavy" then
			local str_old = str
			str = ""
			
			local i = 0
			while #str_old > 0 do
				i += 1
				local y = ceil(sin(i/6 - t()*2))
				y = mid(0,y,1) + 1
				str ..= "\|"..ofs[y]
				str ..= sub(str_old,1,true)
				str_old = sub(str_old,2,#str_old)
				str ..= "\|"..ofs[#ofs-y+1]
			end
		elseif current_line.anim == "whirly" then
			local str_old = str
			str = ""
			
			local i = 0
			while #str_old > 0 do
				i += 1
				local x = ceil(cos(i/6 - t()*2))
				local y = ceil(sin(i/6 - t()*2))
				x = mid(0,x,1) + 1
				y = mid(0,y,1) + 1
				str ..= "\+"..ofs[x]..ofs[y]
				str ..= sub(str_old,1,true)
				str_old = sub(str_old,2,#str_old)
				str ..= "\+"..ofs[#ofs-x+1]..ofs[#ofs-y+1]
			end
		end
		print(current_line.prepend .. str .. current_line.append, self.x + 4,self.y + 4)
		
		if self.advance and self.line_prog >= #current_line.text then
			-- draw little arrow to indicate button press
			local x = self.x + self.w - 14
			local y = self.y + self.h + ceil(sin(time())/2) - 10
			
			line()
			line(x,y,x+5,y+5)
			line(x+5,y+5,x+10,y)
		end
	end
end

return dialogue