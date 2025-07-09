# Picotron-Lua-Libraries
little libraries that i've written for myself in my time with picotron!
feel free to use these as you please - credit is not required at all, but will make me smile a little.

all of these are subject to change!

## menu.lua
allows you to create simple menus with `menu.new{}`. supports functionalities like:
- run a function when an option is selected
- enter a submenu when an option is selected
- prevent an option from being selected at all; behaving as a label of sorts

## dialogue.lua
a simple dialogue system. supports various parameters for each line:
- the text itself
- text speed
- text sound
- if the line can be skipped
- if the line proceeds automatically at the end
- a string to prepend/append to the entire line, such as control codes, or decorative text brackets

you can also place a function in the dialogue script, and it will run when that line is reached!
