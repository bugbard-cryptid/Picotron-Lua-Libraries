--[[pod_format="raw",author="bugbard",created="2025-07-23 03:57:59",icon=userdata("u8",16,16,"00010101010101010101010000000000000107070707070707070601000000000001070707071212120706060100000000010707120712071207060606010000000107070707121212070606060601000001070707070707070707070707010000010707070707070707070707070100000107070707070707070707070701000001071207121207120707070707010000010707070707070707070707070100000107120712120712070707070701000001071207121207120707070707010000010707070707070707070707070100000107120712120712070707070701000001070707070707070707070707010000010101010101010101010101010100"),modified="2025-07-23 06:16:31",notes="cuts a given sprite into 3x3 slices,\nthen draws it as a rectangle\n\nallows for pretty decorative boxes!!!",revision=141,title="sprrect",version="v0.1"]]function sprrect(x, y, w, h, s)
	s = get_spr(s)
	local slice_w, slice_h = s:attribs()
	slice_w = slice_w\3
	slice_h = slice_h\3
	local slices = {}
	
	-- split into 3x3 slices
	for _y = 0,2 do
		local row = {}
		for _x = 0,2 do
			local slice = userdata("u8", slice_w, slice_h)
			s:blit(slice, _x*slice_w,_y*slice_h,0,0, slice_w, slice_h)
			add(row, slice)
		end
		add(slices, row)
	end
	
	-- draw corners
	spr(slices[1][1], x, y)
	spr(slices[1][3], x + w + slice_w, y)
	spr(slices[3][1], x, y + h + slice_h)
	spr(slices[3][3], x + w + slice_w, y + h + slice_h)
	
	-- draw edges
	---- top
		clip(x + slice_w, y, w, slice_h)
		for _x = slice_w, w + slice_w, slice_w do
			spr(slices[1][2], x + _x, y)
		end
	---- bottom
		clip(x + slice_w, y + h + slice_h, w, slice_h)
		for _x = slice_w, w + slice_w, slice_w do
			spr(slices[3][2], x + _x, y + h + slice_h)
		end
	---- left
		clip(x, y + slice_h, slice_w, h)
		for _y = slice_h, h + slice_h, slice_h do
			spr(slices[2][1], x, y + _y)
		end
	---- right
		clip(x + w + slice_w, y + slice_h, slice_w, h)
		for _y = slice_h, h + slice_h, slice_h do
			spr(slices[2][3], x + w + slice_w, y + _y)
		end
		
	-- draw center
		clip(x + slice_w, y + slice_h, w, h)
		for _x = slice_w, w + slice_w, slice_w do
			for _y = slice_h, h + slice_h, slice_h do
				spr(slices[2][2], x + _x, y + _y)
			end
		end
	clip()
end