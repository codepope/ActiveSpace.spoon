local ActiveSpace    = {}
ActiveSpace.__index  = ActiveSpace

-- Metadata
ActiveSpace.name     = "ActiveSpace"
ActiveSpace.version  = "0.1"
ActiveSpace.author   = "Michael Mogenson"
ActiveSpace.homepage = "https://github.com/mogenson/ActiveSpace.spoon"
ActiveSpace.license  = "MIT - https://opensource.org/licenses/MIT"

local function build_title()
    local title = {}
    local num_spaces = 0
    local spaces_layout = hs.spaces.allSpaces()
    local active_spaces = hs.spaces.activeSpaces()
    for _, screen in ipairs(hs.screen.allScreens()) do
        if screen:name()~="Built-in Retina Display" then
            table.insert(title, screen:name() .. ": ")
        end
        local screen_uuid = screen:getUUID()
        local active_space = active_spaces[screen_uuid]
        -- for i, space in ipairs(spaces_layout[screen_uuid]) do
        --     local space_title = tostring(i + num_spaces)
        --     if active_space and active_space == space then
        --         table.insert(title, "[" .. space_title .. "]")
        --     else
        --         table.insert(title, " " .. space_title .. " ")
        --     end
        -- end
        for i, space in ipairs(spaces_layout[screen_uuid]) do
            local space_title = tostring(i + num_spaces)
            local active = active_space and active_space == space
    
            if active then
                if i+num_spaces<10 then
                    table.insert(title,getUnicodeNumberIcon(i+num_spaces,true))
                else
                    table.insert(title, "[" .. space_title .. "]")
                end
            else
                if i+num_spaces<10 then
                    table.insert(title,getUnicodeNumberIcon(i+num_spaces,false))
                else
                    table.insert(title, " " .. space_title .. " ")
                end
            end
        end
        num_spaces = num_spaces + #spaces_layout[screen_uuid]
        table.insert(title, "  ")
    end
    table.remove(title)
    return table.concat(title)
end

function getUnicodeNumberIcon(number, darkBackground)
    if number < 1 or number > 9 then
        return nil, "Number must be between 1 and 9."
    end

    if darkBackground then
        -- Unicode characters for numbers 1 to 9 with a dark background
        local darkIcons = {
            "➊",  -- 1
            "➋",  -- 2
            "➌",  -- 3
            "➍",  -- 4
            "➎",  -- 5
            "➏",  -- 6
            "➐",  -- 7
            "➑",  -- 8
            "➒"   -- 9
        }
        return darkIcons[number]
    else
        -- Unicode characters for numbers 1 to 9 without a dark background
        local lightIcons = {
            "①",  -- 1
            "②",  -- 2
            "③",  -- 3
            "④",  -- 4
            "⑤",  -- 5
            "⑥",  -- 6
            "⑦",  -- 7
            "⑧",  -- 8
            "⑨"   -- 9
        }
        return lightIcons[number]
    end
end

function ActiveSpace:start()
    self.menu = hs.menubar.new()
    local title = build_title()
    -- print(title)
    self.menu:setTitle(title)

    self.space_watcher = hs.spaces.watcher.new(function()
        self.menu:setTitle(build_title())
    end):start()

    self.screen_watcher = hs.screen.watcher.new(function()
        self.menu:setTitle(build_title())
    end):start()
end

function ActiveSpace:stop()
    if self.space_watcher then
        self.space_watcher:stop()
        self.space_watcher = nil
    end

    if self.screen_watcher then
        self.screen_watcher:stop()
        self.screen_watcher = nil
    end

    if self.menu then
        self.menu:delete()
        self.menu = nil
    end
end

return ActiveSpace
