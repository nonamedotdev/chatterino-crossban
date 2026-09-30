-- Start Script
c2.log(c2.LogLevel.Warning, "Crossban script active")
c2.log(c2.LogLevel.Debug, "Please use /add {channel}")

Acc = c2.current_account()

if (not Acc:is_valid()) then
    c2.log(c2.LogLevel.Warning,
        "There is no account linked to your chatterino. Please add an account first and reload the plugin.")
    os.exit(-1)
end

-- Information channel
-- tbd. choosing your own channel
InformationCh = c2.Channel.by_name("/whispers")

-- Load modded channels
ModdedChannels = {}

for lines in io.lines("channels.txt") do
    ModdedChannels[lines] = lines
end



for k, v in pairs(ModdedChannels) do
    InformationCh:add_system_message(v)
end

-- Manually add channels by /add {channel.name}
function add_channel(ctx)
    local chName = ctx.words[2]

    InformationCh:add_system_message(chName)
    if(not c2.Channel.by_name(chName)) then
        InformationCh:add_system_message("Channel " .. chName .. " could not be found.")
        return
    end

    local newChannel = c2.Channel.by_name(chName)

    if (newChannel:is_mod()) then
        if ModdedChannels[chName] ~= nil then
            InformationCh:add_system_message("Channel " .. chName .. " already exists.")
            return
        end
        local file = io.open("channels.txt", "w")
        io.output(file)
        table.insert(ModdedChannels, chName)

        for k, v in pairs(ModdedChannels) do
            io.write(v .. "\n")

            InformationCh:add_system_message("Channel " .. chName)
        end
        io.close(file)
        InformationCh:add_system_message("Channel ", chName, " is succesfully added.")
    end

end
c2.register_command("/add", add_channel)




function crossban_person(args)
    local person = args.words[2]

    for index, value in pairs(ModdedChannels) do
        local currentChannel = c2.Channel.by_name(value)
        currentChannel:send_message("/ban " .. person, true)
        InformationCh:add_system_message(person .. " is banned from " .. value)
    end
end
c2.register_command("/cross", crossban_person)

--[[
function remove_channel(args)
    local channel = args.words[2]
    local lineNumber = 0
    for line in io.lines("channels.txt") do
        lineNumber = lineNumber + 1
        if (line == channel) then

        end
    end
end
c2.register_command("/remove", remove_channel)
]]
