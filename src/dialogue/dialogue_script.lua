--[[pod_format="raw",created="2025-07-14 23:40:00",modified="2025-07-15 01:07:58",revision=48]]
-- here is an example script for a dialogue!
-- try making a new dialogue and using this as the script, like this:
--[[

my_dialogue = dialogue.new{
	script = include("dialogue_script.lua")
}

]]


local script = {
	{text="choices with seeking"},

	"query",
	{
		text="pick one of these choices ok",
		choices = {
			{text="choice 1 (correct)", func = function (self)
				self:advance("correct")
			end},
			{text="choice 2 (wrong)", func = function (self)
				self:advance("wrong")
			end},
			{text="choice 3 (go to start)", func = function (self)
				self:advance(1, true)
			end},
		},
	},

	"correct",
	{text="you selected 1!"},
	{text="that is the \fccorrect one\f7!"},
	function (self) self:advance("end") end,
	
	"wrong",
	{text="you selected 2!"},
	{text="that is the \fuwrong one\f7!"},
	function (self) self.box = false self:advance(1) end,
	{text="because you selected wrong,\ni am taking your box away"},
	function (self) self:advance("query") end,
	
	"end",
	{text = "the end!"},
}

return script