--[[
	Matrix (CR Basis with Tension!)
	
	-T,         2.0 - T,    T - 2.0,           T,
	2.0 * T,    T - 3.0,    3.0 - 2.0 * T,    -T,
	-T,         0.0,        T,               0.0,
	0.0,        1.0,        0.0,             0.0
	
]]

--[[ 
	Tension T, 0.5 is default.
	Lower than 0.5 = sharper edges. 
	Higher than 0.5 = produces curlier lines.
]]

local T = 0.5 

local function interpolate(X, A, B, C, D)
	return X * (X * (X * A + B) + C) + D
end

local function CRCoeffAndMatrix(G1, G2, G3, G4)
	-- I wrote the centripetal catmull-rom matrix (cr basis) directly into this but the matrix can be seen above.
	local A = G1 * -T + G2 * (2.0 - T) + G3 * (T - 2.0) + G4 * T
	local B = G1 * (2.0 * T) + G2 * (T - 3.0) + G3 * (3.0 - 2.0 * T) + G4 * -T
	local C = G1 * -T + G2 * 0. + G3 * T + G4 * 0.
	local D = G1 * 0. + G2 * 1.0 + G3 * 0. + G4 * 0.
	return A, B, C, D
end

local function gr()
	return Random.new():NextNumber(3, 30)
end

local function make(size, name, pos, col, tp)
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = size
	part.Name = name
	part.Position = pos
	part.Shape = Enum.PartType.Ball
	part.BrickColor = col
	part.Parent = game.Workspace
	part.Transparency = tp
	return part
end

local start = Vector3.new(0,0,0)
local points = {}

--Makes the control points.
local controlPoints = 10
for count = 1, controlPoints do
	local transform = Vector3.new(start.X + gr(), start.Y + gr(), start.Z + gr())
	local control_point = make(Vector3.new(3,3,3), "controlpoint", transform, BrickColor.new("Pink"), .4)
	table.insert(points, control_point.Position)
end

local ball = make(Vector3.new(2,2,2), "catmull", start, BrickColor.new("Really blue"), 0)
local size = #points

for i = 1,size-1 do
	local b = points[i]
	local a = points[i-1] or b
	local c = points[i+1] or b
	local d = points[i+2] or c

	a,b,c,d = CRCoeffAndMatrix(a,b,c,d)

	for x = 0, 1.0, 0.05 do
		wait()
		ball.Position = interpolate(x,a,b,c,d)
	end
end
ball.Position = points[size] -- due to end offset problem we just put it to its end location.
