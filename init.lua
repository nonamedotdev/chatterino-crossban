-- Start Script
c2.log(c2.LogLevel.Warning, "Crossban script active")
c2.log(c2.LogLevel.Debug, "Please use /add {channel}")

local acc = c2.current_account()
print(acc:is_valid()) -- true unless user removed account
if(!acc:is_valid()) then
    c2.log(c2.LogLevel.Warning, "There is no account linked to your chatterino. Please add an account first and reload the plugin.")
	os.exit(-1)
end

-- Manually add channels by /add {channel.name}
function add_channel(args)
    local argcount = args.words.lenght()
    local chName = args.words[2]

    local newChannel = c2.Channel.by_name(args.words[2])
    if(newChannel == nil) then
        print("An error while adding channel.")
    end

    if (newChannel:is_mod() and newChannel:is_valid()) then
        local file = io.open("channels.txt", "a+")
        for line in io.lines("channels.txt") do
           if(chName == line) then
                print("User already exists")

                file:close("channels.txt")
            return
           end
        end

        file:write(chName .. "\n")
        file:close("channels.txt")
        print("Channel ", newChannel:get_display_name(), " is succesfully added.")
    end

end
c2.register_command("/add", add_channel)




function crossban_person(args)
    local person = args.words[2]

    for line in io.lines("channels.txt") do
        local currentChannel = c2.Channel.by_name(line)
        print(currentChannel)
        currentChannel:send_message("/ban " .. person, true)
        print(person .. "is banned from" .. currentChannel:get_display_name())
    end
end


c2.register_command("/cross", crossban_person)
