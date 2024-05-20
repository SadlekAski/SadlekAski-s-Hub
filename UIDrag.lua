--[[

(I know this thing already exist somewhere in devforum but who cares!! /j)

----------- HOW TO USE

How to run:
DraggableGUI(gui, false)

gui = Frame or ui element (buttons, labels)
true = Restrict gui to not go Off Screen, sometimes buggy.
false = Allow gui to go Off Screen.

]]

local makeDraggable = {}

local function makeDraggable(gui, restrictOffscreen)
	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

		if restrictOffscreen then
			--Makes the gui not go offscreen :)
			local screenSize = workspace.CurrentCamera.ViewportSize
			local guiSize = gui.AbsoluteSize

			newPosition = UDim2.new(
				0, math.clamp(newPosition.X.Offset, 0, screenSize.X - guiSize.X),
				0, math.clamp(newPosition.Y.Offset, 0, screenSize.Y - guiSize.Y)
			)
		end

		gui.Position = newPosition
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

return makeDraggable
