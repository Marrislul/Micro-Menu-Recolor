--Buttons and their chosen color. Color chosen is based on old icon colors.
local colorSet = {
	-- {0/255, 94/255, 135/255, CharacterMicroButton}, --just a blue
	-- {146/255, 113/255, 155/255, PlayerSpellsMicroButton}, --taken from spellbook icon
	-- {219/255, 50/255, 41/255, TalentMicroButton}, --target center of old icon and increased brightness
	{220/255, 179/255, 24/255, AchievementMicroButton}, --center lower mid of old icon
	{255/255, 227/255, 82/255, QuestLogMicroButton}, --center left of an older icon
	{177/255, 144/255, 80/255, GuildMicroButton}, --center of old guildfinder icon
	{109/255, 162/255, 35/255, LFDMicroButton}, --right of the old icon
	{156/255, 98/255, 77/255, CollectionsMicroButton}, --part of the horse's face
	{206/255, 169/255, 184/255, EJMicroButton}, --part of the skull on the book
	{235/255, 188/255, 42/255, StoreMicroButton}, --center of the icon
	{228/255, 47/255, 40/255, MainMenuMicroButton}, --center of an older icon
}

--Local function to set the variables
local function setButtonColors(self, event, ...)
	--looping through all buttons with colors
	for _, colorData in pairs(colorSet) do
		local r, g, b = colorData[1], colorData[2], colorData[3]
		local button = colorData[4]
		
		local normalTexture = button:GetNormalTexture()
		local pushedTexture = button:GetPushedTexture()
		local highlightTexture = button:GetHighlightTexture()
		local disabledTexture = button:GetDisabledTexture()

		-- Check if the textures exist before trying to set their colors
		if normalTexture then
			normalTexture:SetVertexColor(r, g, b)
		end
		if pushedTexture then
			pushedTexture:SetVertexColor(r, g, b)
		end
		if highlightTexture then
			highlightTexture:SetVertexColor(r, g, b)
		end
		if disabledTexture then
			disabledTexture:SetVertexColor(r, g, b)
		end
	end
end

--Create frame, needed for trigger & changing the variables.
local frame = CreateFrame("Frame")
--Trigger for event, entering the world in this case.
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
--Loads settings one the event is triggered.
frame:SetScript("OnEvent", setButtonColors)



