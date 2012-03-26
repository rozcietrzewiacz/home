local awful = require("awful")
local os = os
local image = image
local wibox = wibox
local widget = widget


-- rooty: web images drawn on the desktop, with post-processing (by ImageMagick etc.)
module("rooty")


function new(cmd, posx, posy, args)
    local imname
    local imwid = {}
    local wiboxes = {}
    local bg = "#12345600"
--    local bg = args.bg or "#12345600"
--    local border = args.border or 0
    local border = 0

    local curpos = 0
    local cmd = cmd -- XXXXXXX??
    for i = 1, #cmd do
        imname = os.tmpname()
--        cmd[i] = "curl -s -m" .. timeout[i] .. " '" .. url[i] .."' " .. pproc[i] .. " "
        os.execute( cmd[i] .. imname )
        imwid[i] = widget({type = "imagebox", align = "left"})
        wiboxes[i] = wibox({ position = "floating", bg = bg, ontop = false, border_width = border })
        imwid[i].image = image(imname)
        os.remove(imname)
        if imwid[i].image then
            wiboxes[i]:geometry({ width = imwid[i].image.width, 
                height = imwid[i].image.height,
                x = posx,
                y = posy + curpos})
            curpos = imwid[i].image.height
--        else
--            wiboxes[i] = nil
        end
        wiboxes[i].screen = 1  -- uzupelnic funkcjonalnosc!
        wiboxes[i].widgets = imwid[i]
    end
    return { imwid = imwid, wiboxes = wiboxes, cmd = cmd }
end

function update(rooty)
    local imname
    local imw = rooty.imwid
    local cmd = rooty.cmd
    local wib = rooty.wiboxes
    if imw[1].image  then
        for i = 1, #cmd do
            imname = os.tmpname()
            os.execute( cmd[i] .. imname )
            imw[i].image = image(imname)
            if imw[i].image then
                wib[i]:geometry({ width = imw[i].image.width, height = imw[i].image.height })
            end
            os.remove(imname)
        end
    end
end

