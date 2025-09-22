local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local clashxpro = sbar.add("item", "widgets.clashxpro", {
    position = "right",
    icon = {
        string = icons.clashxpro.default,
        color = colors.blue,
        font = {
            style = settings.font.style_map["Regular"],
            size = 16.0,
        },
    },
    label = { drawing = true},
    update_freq = 30,
})

clashxpro:subscribe({ "routine" }, function()
    sbar.exec("pgrep -f 'ClashX Pro'", function (out)
        if out == "" then
            clashxpro:set({ icon = { color = colors.red } })
        else
            clashxpro:set({ icon = { color = colors.green } })
        end
    end)
end)

clashxpro:subscribe("mouse.clicked", function(env)
    sbar.exec("open 'http://127.0.0.1:53450/ui'")
end)

sbar.add("bracket", "widgets.clashxpro.bracket", { clashxpro.name }, {
    background = { color = colors.bg1 },
})

sbar.add("item", "widgets.clashxpro.padding", {
    position = "right",
    width = settings.group_paddings,
})
