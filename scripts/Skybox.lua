local Lighting = game:GetService("Lighting")

local Skybox = {}
Skybox.Folder = "Roblox/Skyboxes"
Skybox.Selected = nil
Skybox.Locked = false
Skybox.Connection = nil
Skybox.Applying = false
Skybox.Downloading = false
Skybox.AgeGate = nil
Skybox.Dropdown = nil
Skybox.AgeButton = nil
Skybox.AllProgress = nil
Skybox.CurrentProgress = nil
Skybox.CustomInputs = { Lf = "", Rt = "", Up = "", Dn = "", Ft = "", Bk = "" }

Skybox.Tags = {
    SFW = { Text = "SFW", Color = Color3.fromRGB(34, 197, 94) },
    NSFW = { Text = "NSFW", Color = Color3.fromRGB(239, 68, 68) },
    Mature = { Text = "Mature", Color = Color3.fromRGB(245, 158, 11) },
}

Skybox.Skyboxes = {
    ["Waguri"] = {
        Tag = "SFW",
        Folder = "sfwWaguri",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_ft.png", File = "sfwWaguri_Bk.png", Size = 800583 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_bk.png", File = "sfwWaguri_Ft.png", Size = 843573 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_rt.png", File = "sfwWaguri_Lf.png", Size = 518741 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_lf.png", File = "sfwWaguri_Rt.png", Size = 875338 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_up.png", File = "sfwWaguri_Up.png", Size = 1481145 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_dn.png", File = "sfwWaguri_Dn.png", Size = 1333228 },
        },
    },
    ["Reynai"] = {
        Tag = "SFW",
        Folder = "sfwReynai",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/back.png", File = "sfwReynai_Bk.png", Size = 774151 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/front.png", File = "sfwReynai_Ft.png", Size = 680422 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/left.png", File = "sfwReynai_Lf.png", Size = 1228280 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/right.png", File = "sfwReynai_Rt.png", Size = 972336 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/top.png", File = "sfwReynai_Up.png", Size = 91186 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/down.png", File = "sfwReynai_Dn.png", Size = 65411 },
        },
    },
    ["Cryene"] = {
        Tag = "Mature",
        Folder = "matureCryene",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/back.png", File = "matureCryene_Bk.png", Size = 2797030 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/front.png", File = "matureCryene_Ft.png", Size = 3504207 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/left.png", File = "matureCryene_Lf.png", Size = 1451566 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/right.png", File = "matureCryene_Rt.png", Size = 1144469 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/Top.png", File = "matureCryene_Up.png", Size = 3153990 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/down.png", File = "matureCryene_Dn.png", Size = 2532154 },
        },
    },
    ["Rio Tsukatsuki"] = {
        Tag = "Mature",
         Folder = "RioTsukatsuki",
         ResetHaze = true,
         Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rio-Tsukatsuki/Rio-Tsukatsuki-Back.png", File = "Rio TsukatsukiBack.png", Size = 3788486 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rio-Tsukatsuki/Rio-Tsukatsuki-Front.png", File = "Rio TsukatsukiFront.png", Size = 4219156 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rio-Tsukatsuki/Rio-Tsukatsuki-Left.png", File = "Rio TsukatsukiLeft.png", Size = 1409066 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rio-Tsukatsuki/Rio-Tsukatsuki-Right.png", File = "Rio TsukatsukiRight.png", Size = 4959765 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rio-Tsukatsuki/Rio-Tsukatsuki-Top.png", File = "Rio TsukatsukiTop.png", Size = 1902376 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rio-Tsukatsuki/Rio-Tsukatsuki-Down.png", File = "Rio TsukatsukiDown.png", Size = 3404572 },
        },
    },
    ["Yue"] = {
        Tag = "SFW",
        Folder = "sfwYue",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Back.png", File = "sfwYue_Bk.png", Size = 1703078 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Front.png", File = "sfwYue_Ft.png", Size = 1705808 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Left.png", File = "sfwYue_Lf.png", Size = 2049195 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Right.png", File = "sfwYue_Rt.png", Size = 1821145 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Top.png", File = "sfwYue_Up.png", Size = 1809057 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Down.png", File = "sfwYue_Dn.png", Size = 1821422 },
        },
    },
    ["miku"] = {
        Tag = "SFW",
        Folder = "sfwmiku",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Back.png", File = "sfwmiku_Bk.png", Size = 834593 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Front.png", File = "sfwmiku_Ft.png", Size = 813653 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Left.png", File = "sfwmiku_Lf.png", Size = 1089146 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Right.png", File = "sfwmiku_Rt.png", Size = 956279 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Top.png", File = "sfwmiku_Up.png", Size = 1008975 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Down.png", File = "sfwmiku_Dn.png", Size = 1375928 },
        },
    },
    ["Rias Gremory"] = {
        Tag = "Mature",
        Folder = "nsfwRiasGremory",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Back.png", File = "nsfwRiasGremory_Bk.png", Size = 1266820 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Front.png", File = "nsfwRiasGremory_Ft.png", Size = 1287576 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Left.png", File = "nsfwRiasGremory_Lf.png", Size = 1346998 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Right.png", File = "nsfwRiasGremory_Rt.png", Size = 1514368 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Top.png", File = "nsfwRiasGremory_Up.png", Size = 1088169 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Down.png", File = "nsfwRiasGremory_Dn.png", Size = 1654109 },
        },
    },
    ["Elbe"] = {
        Tag = "NSFW",
        Folder = "nsfwElbe",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Back.png", File = "nsfwElbe_Bk.png", Size = 1020363 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Front.png", File = "nsfwElbe_Ft.png", Size = 1176985 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Left.png", File = "nsfwElbe_Lf.png", Size = 1007949 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Right.png", File = "nsfwElbe_Rt.png", Size = 1002786 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Top.png", File = "nsfwElbe_Up.png", Size = 1020776 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Down.png", File = "nsfwElbe_Dn.png", Size = 485481 },
        },
    },
    ["Mitsuri"] = {
        Tag = "NSFW",
        Folder = "nsfwMitsuri",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Back.png", File = "nsfwMitsuri_Bk.png", Size = 1273435 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Front.png", File = "nsfwMitsuri_Ft.png", Size = 1242761 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Left.png", File = "nsfwMitsuri_Lf.png", Size = 587958 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Right.png", File = "nsfwMitsuri_Rt.png", Size = 874635 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Top.png", File = "nsfwMitsuri_Up.png", Size = 1041593 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Down.png", File = "nsfwMitsuri_Dn.png", Size = 1091727 },
        },
    },
    ["Ellen Joe"] = {
        Tag = "SFW",
        Folder = "sfwEllenJoe",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Back.png", File = "sfwEllenJoe_Bk.png", Size = 1400432 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Front.png", File = "sfwEllenJoe_Ft.png", Size = 1335909 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Left.png", File = "sfwEllenJoe_Lf.png", Size = 1042575 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Right.png", File = "sfwEllenJoe_Rt.png", Size = 1768449 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Top.png", File = "sfwEllenJoe_Up.png", Size = 675957 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Down.png", File = "sfwEllenJoe_Dn.png", Size = 1287008 },
        },
    },
    ["Lucoa"] = {
        Tag = "Mature",
        Folder = "nsfwLucoa",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Back.png", File = "nsfwLucoa_Bk.png", Size = 456997 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Front.png", File = "nsfwLucoa_Ft.png", Size = 444207 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Left.png", File = "nsfwLucoa_Lf.png", Size = 434234 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Right.png", File = "nsfwLucoa_Rt.png", Size = 470119 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Top.png", File = "nsfwLucoa_Up.png", Size = 441477 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Down.png", File = "nsfwLucoa_Dn.png", Size = 476979 },
        },
    },
    ["Furina"] = {
        Tag = "Mature",
        Folder = "nsfwFurina",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Furina/Furina-Back.png", File = "nsfwFurina_Bk.png", Size = 3852392 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Furina/Furina-Front.png", File = "nsfwFurina_Ft.png", Size = 3999415 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Furina/Furina-Left.png", File = "nsfwFurina_Lf.png", Size = 4162612 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Furina/Furina-Right.png", File = "nsfwFurina_Rt.png", Size = 4246350 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Furina/Furina-Top.png", File = "nsfwFurina_Up.png", Size = 5018419 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Furina/Furina-Down.png", File = "nsfwFurina_Dn.png", Size = 4273711 },
        },
    },
    ["Castorice"] = {
        Tag = "Mature",
        Folder = "nsfwCastorice",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/back.png", File = "nsfwCastorice_Bk.png", Size = 3408698 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/front.png", File = "nsfwCastorice_Ft.png", Size = 2883168 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/left.png", File = "nsfwCastorice_Lf.png", Size = 2318462 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/right.png", File = "nsfwCastorice_Rt.png", Size = 2210047 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/top.png", File = "nsfwCastorice_Up.png", Size = 3025724 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/down.png", File = "nsfwCastorice_Dn.png", Size = 4143844 },
        },
    },
    ["Iochi Mari"] = {
        Tag = "SFW",
        Folder = "sfwIochiMari",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/back.png", File = "sfwIochiMari_Bk.png", Size = 2137520 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/front.png", File = "sfwIochiMari_Ft.png", Size = 2070615 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/left.png", File = "sfwIochiMari_Lf.png", Size = 2116535 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/right.png", File = "sfwIochiMari_Rt.png", Size = 1853850 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/top.png", File = "sfwIochiMari_Up.png", Size = 1967249 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/down.png", File = "sfwIochiMari_Dn.png", Size = 1984335 },
        },
    },
    ["Hoshimachi"] = {
        Tag = "Mature",
        Folder = "sfwHoshimachi",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/back.png", File = "sfwHoshimachi_Bk.png", Size = 6750624 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/front.png", File = "sfwHoshimachi_Ft.png", Size = 5870036 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/left.png", File = "sfwHoshimachi_Lf.png", Size = 5965296 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/right.png", File = "sfwHoshimachi_Rt.png", Size = 6403177 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/top.png", File = "sfwHoshimachi_Up.png", Size = 6378953 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/down.png", File = "sfwHoshimachi_Dn.png", Size = 6368453 },
        },
    },
    ["Rossweisse"] = {
        Tag = "Mature",
        Folder = "nsfwRossweisse",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/back.png", File = "nsfwRossweisse_Bk.png", Size = 3550238 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/front.png", File = "nsfwRossweisse_Ft.png", Size = 3561124 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/left.png", File = "nsfwRossweisse_Lf.png", Size = 3732564 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/right.png", File = "nsfwRossweisse_Rt.png", Size = 3198005 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/top.png", File = "nsfwRossweisse_Up.png", Size = 3176896 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/down.png", File = "nsfwRossweisse_Dn.png", Size = 3852738 },
        },
    },
    ["Itsuki Nakano"] = {
        Tag = "SFW",
        Folder = "sfwItsukiNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Bk.png", File = "sfwItsukiNakano_Bk.png", Size = 1174671 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Ft.png", File = "sfwItsukiNakano_Ft.png", Size = 1185794 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Lf.png", File = "sfwItsukiNakano_Lf.png", Size = 631681 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Rt.png", File = "sfwItsukiNakano_Rt.png", Size = 1399559 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Up.png", File = "sfwItsukiNakano_Up.png", Size = 462092 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Dn.png", File = "sfwItsukiNakano_Dn.png", Size = 861391 },
        },
    },
    ["Itsuki Nakano2"] = {
        Tag = "SFW",
        Folder = "sfwItsukiNakano2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Bk.png", File = "sfwItsukiNakano2_Bk.png", Size = 1340376 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Ft.png", File = "sfwItsukiNakano2_Ft.png", Size = 1274828 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Lf.png", File = "sfwItsukiNakano2_Lf.png", Size = 1088022 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Rt.png", File = "sfwItsukiNakano2_Rt.png", Size = 1021346 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Up.png", File = "sfwItsukiNakano2_Up.png", Size = 1109987 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Dn.png", File = "sfwItsukiNakano2_Dn.png", Size = 1054128 },
        },
    },
    ["Mai Sakurajima"] = {
        Tag = "SFW",
        Folder = "sfwMaiSakurajima",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/top.png", File = "sfwMaiSakurajima_Up.png", Size = 2807358 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/down.png", File = "sfwMaiSakurajima_Dn.png", Size = 2209906 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/left.png", File = "sfwMaiSakurajima_Lf.png", Size = 2754166 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/right.png", File = "sfwMaiSakurajima_Rt.png", Size = 3179785 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/front.png", File = "sfwMaiSakurajima_Ft.png", Size = 3066756 },
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/back.png", File = "sfwMaiSakurajima_Bk.png", Size = 3100087 },
        },
    },
    ["Nakiri Ayame"] = {
        Tag = "SFW",
        Folder = "matureNakiriAyameHeavy50mb",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Back.png", File = "matureNakiriAyameHeavy50mb_Bk.png", Size = 12471432 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Front.png", File = "matureNakiriAyameHeavy50mb_Ft.png", Size = 13096294 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Left.png", File = "matureNakiriAyameHeavy50mb_Lf.png", Size = 13544923 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Right.png", File = "matureNakiriAyameHeavy50mb_Rt.png", Size = 11792084 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Top.png", File = "matureNakiriAyameHeavy50mb_Up.png", Size = 13553461 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Down.png", File = "matureNakiriAyameHeavy50mb_Dn.png", Size = 13558464 },
        },
    },
    ["Miku Nakano"] = {
        Tag = "Mature",
        Folder = "matureMikuNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Bk.png", File = "matureMikuNakano_Bk.png", Size = 1145382 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Ft.png", File = "matureMikuNakano_Ft.png", Size = 939486 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Lf.png", File = "matureMikuNakano_Lf.png", Size = 969541 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Rt.png", File = "matureMikuNakano_Rt.png", Size = 1615849 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Up.png", File = "matureMikuNakano_Up.png", Size = 922278 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Dn.png", File = "matureMikuNakano_Dn.png", Size = 978795 },
        },
    },
    ["Tohka Yatogami"] = {
        Tag = "Mature",
        Folder = "sfwTohkaYatogami",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_BK.png", File = "sfwTohkaYatogami_Bk.png", Size = 1737646 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_FT.png", File = "sfwTohkaYatogami_Ft.png", Size = 1667935 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_LF.png", File = "sfwTohkaYatogami_Lf.png", Size = 804185 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_RT.png", File = "sfwTohkaYatogami_Rt.png", Size = 761363 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_UP.png", File = "sfwTohkaYatogami_Up.png", Size = 782511 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_DN.png", File = "sfwTohkaYatogami_Dn.png", Size = 743937 },
        },
    },
    ["Tohka Yatogami2"] = {
        Tag = "SFW",
        Folder = "sfwTohkaYatogami2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_BK.png", File = "sfwTohkaYatogami2_Bk.png", Size = 1059548 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_FT.png", File = "sfwTohkaYatogami2_Ft.png", Size = 963508 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_LF.png", File = "sfwTohkaYatogami2_Lf.png", Size = 1646279 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_RT.png", File = "sfwTohkaYatogami2_Rt.png", Size = 1093867 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_UP.png", File = "sfwTohkaYatogami2_Up.png", Size = 908599 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_DN.png", File = "sfwTohkaYatogami2_Dn.png", Size = 1523384 },
        },
    },
    ["Lilith Asami"] = {
        Tag = "Mature",
        Folder = "matureLilithAsami",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_BK.png", File = "matureLilithAsami_Bk.png", Size = 1163227 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_FT.png", File = "matureLilithAsami_Ft.png", Size = 1073559 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_LF.png", File = "matureLilithAsami_Lf.png", Size = 643432 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_RT.png", File = "matureLilithAsami_Rt.png", Size = 1406976 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_UP.png", File = "matureLilithAsami_Up.png", Size = 796684 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_DN.png", File = "matureLilithAsami_Dn.png", Size = 870654 },
        },
    },
    ["Evernight"] = {
        Tag = "SFW",
        Folder = "sfwEvernight",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_RT.png", File = "sfwEvernight_Bk.png", Size = 1178516 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_LF.png", File = "sfwEvernight_Rt.png", Size = 1254494 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_BK.png", File = "sfwEvernight_Lf.png", Size = 937767 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_FT.png", File = "sfwEvernight_Ft.png", Size = 1107513 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_UP.png", File = "sfwEvernight_Up.png", Size = 725240 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_DN.png", File = "sfwEvernight_Dn.png", Size = 467610 },
        },
    },
    ["Rem"] = {
        Tag = "Mature",
        Folder = "nsfwRem",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Back.png", File = "nsfwRem_Bk.png", Size = 2028563 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Right.png", File = "nsfwRem_Rt.png", Size = 2081131 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Left.png", File = "nsfwRem_Lf.png", Size = 1935482 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Front.png", File = "nsfwRem_Ft.png", Size = 2010375 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Top.png", File = "nsfwRem_Up.png", Size = 2028209 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Down.png", File = "nsfwRem_Dn.png", Size = 1817457 },
        },
    },
    ["Xenovia Quarta"] = {
        Tag = "NSFW",
        Folder = "matureXenoviaQuarta",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjM0ODhf/if.png", File = "matureXenoviaQuarta_Lf.png", Size = 1593918 },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjM0ODlf/ft.png", File = "matureXenoviaQuarta_Bk.png", Size = 1071618 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjM0OTBf/dn.png", File = "matureXenoviaQuarta_Dn.png", Size = 1109997 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjM0OTFf/bk.png", File = "matureXenoviaQuarta_Ft.png", Size = 1067359 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjM0ODZf/up.png", File = "matureXenoviaQuarta_Up.png", Size = 1163627 },
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjM0ODdf/rt.png", File = "matureXenoviaQuarta_Rt.png", Size = 1586782 },
        },
    },
    ["Nino Nakano"] = {
        Tag = "SFW",
        Folder = "sfwNinoNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyODNf/right1.png", File = "sfwNinoNakano_Rt.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNzhf/back.png", File = "sfwNinoNakano_Lf.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyODBf/front.png", File = "sfwNinoNakano_Ft.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyODJf/left1.png", File = "sfwNinoNakano_Bk.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNzlf/down.png", File = "sfwNinoNakano_Dn.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyODFf/up.png", File = "sfwNinoNakano_Up.png" },
        },
    },
    ["Nino Nakano 2"] = {
        Tag = "Mature",
        Folder = "sfwNinoNakano2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyNTJf/rt.png", File = "sfwNinoNakano2_Rt.png", Size = 225442 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyNTBf/up.png", File = "sfwNinoNakano2_Up.png", Size = 466968 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNTVf/dn.png", File = "sfwNinoNakano2_Dn.png", Size = 442974 },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyNTNf/if.png", File = "sfwNinoNakano2_Bk.png", Size = 216234 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyNTZf/bk.png", File = "sfwNinoNakano2_Ft.png", Size = 206421 },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNTRf/ft.png", File = "sfwNinoNakano2_Lf.png", Size = 1275855 },
        },
    },
    ["Saki Saki"] = {
        Tag = "Mature",
        Folder = "sfwSakiSaki",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyNzNf/right.png", File = "sfwSakiSaki_Rt.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNzBf/left.png", File = "sfwSakiSaki_Lf.png", Size = 1166082 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyNjhf/front1.png", File = "sfwSakiSaki_Ft.png", Size = 863337 },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyNjZf/back1.png", File = "sfwSakiSaki_Bk.png", Size = 884515 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNjdf/down1.png", File = "sfwSakiSaki_Dn.png", Size = 792317 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyNjlf/Up1.png", File = "sfwSakiSaki_Up.png" },
        },
    },
    ["Rias Gremory"] = {
        Tag = "Mature",
        Folder = "matureRiasGremory",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkyOTFf/RightRias.png", File = "matureRiasGremory_Rt.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkyOTNf/leftRias.png", File = "matureRiasGremory_Bk.png", Size = 815115 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkyOTVf/front%20Rias.png", File = "matureRiasGremory_Ft.png", Size = 724048 },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkyOTRf/BackRias.png", File = "matureRiasGremory_Lf.png", Size = 1215285 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkyOThf/downRias.png", File = "matureRiasGremory_Dn.png", Size = 682042 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkyOTJf/UpRias.png", File = "matureRiasGremory_Up.png", Size = 642454 },
        },
    },
    ["Yotsuba Nakano"] = {
        Tag = "Mature",
        Folder = "sfwYotsubaNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMzdf/YotsubaRt.png", File = "sfwYotsubaNakano_Rt.png", Size = 1772378 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMzhf/YotsubaUp.png", File = "sfwYotsubaNakano_Up.png", Size = 1046129 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMzNf/YotsubaDn.png", File = "sfwYotsubaNakano_Dn.png", Size = 1028434 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMzRf/YotsubaFt.png", File = "sfwYotsubaNakano_Ft.png", Size = 1003395 },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMzFf/YotsubaBk.png", File = "sfwYotsubaNakano_Bk.png", Size = 997851 },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMzZf/YotsubaLeft.png", File = "sfwYotsubaNakano_Lf.png", Size = 1399256 },
        },
    },
    ["Hakari Hananozo"] = {
        Tag = "SFW",
        Folder = "sfwHakariHananozo",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjEzMTVf/SkyBk.tex", File = "sfwHakariHananozo_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/s/NjNfOTg0NjEzMTdf/SkyFt.tex", File = "sfwHakariHananozo_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/s/NjNfOTg0NjEzMThf/SkyIf.tex", File = "sfwHakariHananozo_Lf.png", Size = 481130 },
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjEzMTlf/SkyRt.tex", File = "sfwHakariHananozo_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjEzMjBf/SkyUp.tex", File = "sfwHakariHananozo_Up.png", Size = 586812 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjEzMTZf/Skydn.tex", File = "sfwHakariHananozo_Dn.png", Size = 660717 },
        },
    },
    ["Alya"] = {
        Tag = "SFW",
        Folder = "sfwAlya",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMTZf/Rt.png", File = "sfwAlya_Rt.png", Size = 634910 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMTVf/Up.png", File = "sfwAlya_Up.png", Size = 471821 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMTJf/dn.png", File = "sfwAlya_Dn.png", Size = 455639 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMTNf/ft.png", File = "sfwAlya_Ft.png", Size = 1144463 },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMTFf/bk.png", File = "sfwAlya_Bk.png", Size = 953080 },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMTRf/if.png", File = "sfwAlya_Lf.png", Size = 333075 },
        },
    },
    ["Alya 2"] = {
        Tag = "SFW",
        Folder = "sfwAlya2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMjRf/AlyaRt.png", File = "sfwAlya2_Rt.png", Size = 410546 },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMjVf/AlyaUp.png", File = "sfwAlya2_Up.png", Size = 870510 },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMjFf/alyaDn.png", File = "sfwAlya2_Dn.png", Size = 1012834 },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMjJf/AlyaFt.png", File = "sfwAlya2_Ft.png", Size = 800204 },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMjBf/AlyaBk.png", File = "sfwAlya2_Bk.png", Size = 873320 },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMjNf/AlyaLf.png", File = "sfwAlya2_Lf.png", Size = 429031 },
        },
    },
    ["Yor Forger"] = {
        Tag = "Mature",
        Folder = "sfwYorForger",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yor-Forger/Yor-Forger-Back.png", File = "Yor-Forger-Back.png", Size = 353340 },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yor-Forger/Yor-Forger-Front.png", File = "Yor-Forger-Front.png", Size = 375018 },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yor-Forger/Yor-Forger-Left.png", File = "Yor-Forger-Left.png", Size = 354597 },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yor-Forger/Yor-Forger-Right.png", File = "Yor-Forger-Right.png", Size = 399633 },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yor-Forger/Yor-Forger-Top.png", File = "Yor-Forger-Top.png", Size = 68979 },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yor-Forger/Yor-Forger-Down.png", File = "Yor-Forger-Down.png", Size = 10829 },
        },
    },
    ["Iteration 3.2.0"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://111969418190645",
            SkyboxFt = "rbxassetid://86300370158690",
            SkyboxRt = "rbxassetid://90660761614046",
            SkyboxBk = "rbxassetid://94155581950702",
            SkyboxDn = "rbxassetid://74377450776557",
            SkyboxUp = "rbxassetid://110123630908028",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
    ["IterationT Remake"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://131895067742893",
            SkyboxFt = "rbxassetid://139394863985793",
            SkyboxRt = "rbxassetid://93313124175539",
            SkyboxBk = "rbxassetid://93271230842735",
            SkyboxDn = "rbxassetid://72142305760362",
            SkyboxUp = "rbxassetid://86656757951125",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
    ["Solas"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://114101438300462",
            SkyboxFt = "rbxassetid://81853755030851",
            SkyboxRt = "rbxassetid://105249527747322",
            SkyboxBk = "rbxassetid://74791000689563",
            SkyboxDn = "rbxassetid://116875029841325",
            SkyboxUp = "rbxassetid://100091829278615",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
    ["Black Storm"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://15502511288",
            SkyboxDn = "rbxassetid://15502508460",
            SkyboxFt = "rbxassetid://15502510289",
            SkyboxLf = "rbxassetid://15502507918",
            SkyboxRt = "rbxassetid://15502509398",
            SkyboxUp = "rbxassetid://15502511911",
        },
    },
    ["HD"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://16553658937",
            SkyboxDn = "rbxassetid://16553660713",
            SkyboxFt = "rbxassetid://16553662144",
            SkyboxLf = "rbxassetid://16553664042",
            SkyboxRt = "rbxassetid://16553665766",
            SkyboxUp = "rbxassetid://16553667750",
        },
    },
    ["Snow"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://155657655",
            SkyboxDn = "rbxassetid://155674246",
            SkyboxFt = "rbxassetid://155657609",
            SkyboxLf = "rbxassetid://155657671",
            SkyboxRt = "rbxassetid://155657619",
            SkyboxUp = "rbxassetid://155674931",
        },
    },
    ["Blue Space"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://15536110634",
            SkyboxDn = "rbxassetid://15536112543",
            SkyboxFt = "rbxassetid://15536116141",
            SkyboxLf = "rbxassetid://15536114370",
            SkyboxRt = "rbxassetid://15536118762",
            SkyboxUp = "rbxassetid://15536117282",
        },
    },
    ["Realistic"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://653719502",
            SkyboxDn = "rbxassetid://653718790",
            SkyboxFt = "rbxassetid://653719067",
            SkyboxLf = "rbxassetid://653719190",
            SkyboxRt = "rbxassetid://653718931",
            SkyboxUp = "rbxassetid://653719321",
        },
    },
    ["Stormy"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://18703245834",
            SkyboxDn = "rbxassetid://18703243349",
            SkyboxFt = "rbxassetid://18703240532",
            SkyboxLf = "rbxassetid://18703237556",
            SkyboxRt = "rbxassetid://18703235430",
            SkyboxUp = "rbxassetid://18703232671",
        },
    },
    ["Pink"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://12216109205",
            SkyboxDn = "rbxassetid://12216109875",
            SkyboxFt = "rbxassetid://12216109489",
            SkyboxLf = "rbxassetid://12216110170",
            SkyboxRt = "rbxassetid://12216110471",
            SkyboxUp = "rbxassetid://12216108877",
        },
    },
    ["Sunset"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://600830446",
            SkyboxDn = "rbxassetid://600831635",
            SkyboxFt = "rbxassetid://600832720",
            SkyboxLf = "rbxassetid://600886090",
            SkyboxRt = "rbxassetid://600833862",
            SkyboxUp = "rbxassetid://600835177",
        },
    },
    ["Arctic"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://225469390",
            SkyboxDn = "rbxassetid://225469395",
            SkyboxFt = "rbxassetid://225469403",
            SkyboxLf = "rbxassetid://225469450",
            SkyboxRt = "rbxassetid://225469471",
            SkyboxUp = "rbxassetid://225469481",
        },
    },
    ["Space"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://166509999",
            SkyboxDn = "rbxassetid://166510057",
            SkyboxFt = "rbxassetid://166510116",
            SkyboxLf = "rbxassetid://166510092",
            SkyboxRt = "rbxassetid://166510131",
            SkyboxUp = "rbxassetid://166510114",
        },
    },
    ["Roblox Default"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex",
            SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex",
            SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex",
            SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex",
            SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex",
            SkyboxUp = "rbxasset://textures/sky/sky512_up.tex",
        },
    },
    ["Red Night"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://401664839",
            SkyboxDn = "rbxassetid://401664862",
            SkyboxFt = "rbxassetid://401664960",
            SkyboxLf = "rbxassetid://401664881",
            SkyboxRt = "rbxassetid://401664901",
            SkyboxUp = "rbxassetid://401664936",
        },
    },
    ["Deep Space 1"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://149397692",
            SkyboxDn = "rbxassetid://149397686",
            SkyboxFt = "rbxassetid://149397697",
            SkyboxLf = "rbxassetid://149397684",
            SkyboxRt = "rbxassetid://149397688",
            SkyboxUp = "rbxassetid://149397702",
        },
    },
    ["Pink Skies"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://151165214",
            SkyboxDn = "rbxassetid://151165197",
            SkyboxFt = "rbxassetid://151165224",
            SkyboxLf = "rbxassetid://151165191",
            SkyboxRt = "rbxassetid://151165206",
            SkyboxUp = "rbxassetid://151165227",
        },
    },
    ["Purple Sunset"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://264908339",
            SkyboxDn = "rbxassetid://264907909",
            SkyboxFt = "rbxassetid://264909420",
            SkyboxLf = "rbxassetid://264909758",
            SkyboxRt = "rbxassetid://264908886",
            SkyboxUp = "rbxassetid://264907379",
        },
    },
    ["Blue Night"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://12064107",
            SkyboxDn = "rbxassetid://12064152",
            SkyboxFt = "rbxassetid://12064121",
            SkyboxLf = "rbxassetid://12063984",
            SkyboxRt = "rbxassetid://12064115",
            SkyboxUp = "rbxassetid://12064131",
        },
    },
    ["Blossom Daylight"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://271042516",
            SkyboxDn = "rbxassetid://271077243",
            SkyboxFt = "rbxassetid://271042556",
            SkyboxLf = "rbxassetid://271042310",
            SkyboxRt = "rbxassetid://271042467",
            SkyboxUp = "rbxassetid://271077958",
        },
    },
    ["Blue Nebula"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://135207744",
            SkyboxDn = "rbxassetid://135207662",
            SkyboxFt = "rbxassetid://135207770",
            SkyboxLf = "rbxassetid://135207615",
            SkyboxRt = "rbxassetid://135207695",
            SkyboxUp = "rbxassetid://135207794",
        },
    },
    ["Blue Planet"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://218955819",
            SkyboxDn = "rbxassetid://218953419",
            SkyboxFt = "rbxassetid://218954524",
            SkyboxLf = "rbxassetid://218958493",
            SkyboxRt = "rbxassetid://218957134",
            SkyboxUp = "rbxassetid://218950090",
        },
    },
    ["Deep Space 2"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://159248188",
            SkyboxDn = "rbxassetid://159248183",
            SkyboxFt = "rbxassetid://159248187",
            SkyboxLf = "rbxassetid://159248173",
            SkyboxRt = "rbxassetid://159248192",
            SkyboxUp = "rbxassetid://159248176",
        },
    },
    ["Summer"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://16648590964",
            SkyboxDn = "rbxassetid://16648617436",
            SkyboxFt = "rbxassetid://16648595424",
            SkyboxLf = "rbxassetid://16648566370",
            SkyboxRt = "rbxassetid://16648577071",
            SkyboxUp = "rbxassetid://16648598180",
        },
    },
    ["Galaxy"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://15983968922",
            SkyboxDn = "rbxassetid://15983966825",
            SkyboxFt = "rbxassetid://15983965025",
            SkyboxLf = "rbxassetid://15983967420",
            SkyboxRt = "rbxassetid://15983966246",
            SkyboxUp = "rbxassetid://15983964246",
        },
    },
    ["Stylized"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://18351376859",
            SkyboxDn = "rbxassetid://18351374919",
            SkyboxFt = "rbxassetid://18351376800",
            SkyboxLf = "rbxassetid://18351376469",
            SkyboxRt = "rbxassetid://18351376457",
            SkyboxUp = "rbxassetid://18351377189",
        },
    },
    ["Minecraft"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://8735166756",
            SkyboxDn = "rbxassetid://8735166707",
            SkyboxFt = "rbxassetid://8735231668",
            SkyboxLf = "rbxassetid://8735166755",
            SkyboxRt = "rbxassetid://8735166751",
            SkyboxUp = "rbxassetid://8735166729",
        },
    },
    ["Cloudy Rain"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://4498828382",
            SkyboxDn = "rbxassetid://4498828812",
            SkyboxFt = "rbxassetid://4498829917",
            SkyboxLf = "rbxassetid://4498830911",
            SkyboxRt = "rbxassetid://4498830417",
            SkyboxUp = "rbxassetid://4498831746",
        },
    },
    ["Black Cloudy Rain"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://149679669",
            SkyboxDn = "rbxassetid://149681979",
            SkyboxFt = "rbxassetid://149679690",
            SkyboxLf = "rbxassetid://149679709",
            SkyboxRt = "rbxassetid://149679722",
            SkyboxUp = "rbxassetid://149680199",
        },
    },
}

function Skybox:SetFolder(Folder)
    self.Folder = Folder
    self:BuildFolderTree()
end

function Skybox:SetLibrary(Library)
    self.Library = Library
end

function Skybox:BuildFolderTree()
    local Paths = {}
    local Parts = self.Folder:split("/")
    for Index = 1, #Parts do
        Paths[#Paths + 1] = table.concat(Parts, "/", 1, Index)
    end
    table.insert(Paths, self.Folder .. "/Custom")

    for Index = 1, #Paths do
        local Path = Paths[Index]
        if not isfolder(Path) then
            makefolder(Path)
        end
    end
end

function Skybox:SetAgeGate(Gate)
    self.AgeGate = Gate
end

function Skybox:IsAllowed(Data)
    local Tag = Data.Tag or "SFW"

    if Tag == "SFW" then
        return true
    end

    return self.AgeGate ~= nil and self.AgeGate:Allows(Tag)
end

function Skybox:GetNames(AllowedOnly)
    local Names = {}
    for Name, Data in pairs(self.Skyboxes) do
        if not AllowedOnly or self:IsAllowed(Data) then
            table.insert(Names, Name)
        end
    end
    table.sort(Names)
    return Names
end

function Skybox:GetItemTags()
    local Map = {}
    for Name, Data in pairs(self.Skyboxes) do
        if Data.Tag then
            Map[Name] = Data.Tag
        end
    end
    return Map
end

function Skybox:Notify(Content)
    if not self.Library then return end
    self.Library:Notify({
        Title = "Skybox",
        Content = Content,
        Duration = 3,
    })
end

function Skybox:FacePath(Data, Face)
    return self.Folder .. "/" .. Data.Folder .. "/" .. Face.File
end

function Skybox:Download(Url, Path)
    local Success, Body = pcall(game.HttpGet, game, Url, true)

    if not Success or type(Body) ~= "string" or #Body == 0 then
        return nil
    end

    if not pcall(writefile, Path, Body) then
        return nil
    end

    return #Body
end

function Skybox:GetAverageSize()
    local Sum, Count = 0, 0

    for _, Data in pairs(self.Skyboxes) do
        for _, Face in ipairs(Data.Faces or {}) do
            if Face.Size then
                Sum = Sum + Face.Size
                Count = Count + 1
            end
        end
    end

    return Count > 0 and Sum / Count or 2 * 1048576
end

function Skybox:IsGitHub(Data)
    for _, Face in ipairs(Data.Faces) do
        if not Face.Url:find("raw.githubusercontent.com", 1, true) then
            return false
        end
    end

    return true
end

function Skybox:GetQueue()
    local Queue = {}

    for _, Name in ipairs(self:GetNames(true)) do
        local Data = self.Skyboxes[Name]
        local Faces = {}

        for _, Face in ipairs(Data.Faces or {}) do
            local Path = self:FacePath(Data, Face)

            if not isfile(Path) then
                table.insert(Faces, { Face = Face, Path = Path })
            end
        end

        if #Faces > 0 then
            table.insert(Queue, { Name = Name, Data = Data, Faces = Faces, GitHub = self:IsGitHub(Data) })
        end
    end

    table.sort(Queue, function(A, B)
        if A.GitHub ~= B.GitHub then
            return A.GitHub
        end

        return A.Name < B.Name
    end)

    return Queue
end

function Skybox:FormatSize(Bytes)
    return string.format("%.1f", Bytes / 1048576)
end

function Skybox:FormatProgress(Done, Total, Estimated)
    return string.format("%s / %s%s MB", self:FormatSize(Done), Estimated and "~" or "", self:FormatSize(Total))
end

function Skybox:SetProgressVisible(Visible)
    if not self.AllProgress then
        return
    end

    self.AllProgress:SetVisible(Visible)
    self.CurrentProgress:SetVisible(Visible)
end

function Skybox:DownloadAll()
    if self.Downloading then
        return self:Notify("A download is already in progress.")
    end

    local Queue = self:GetQueue()

    if #Queue == 0 then
        return self:Notify("All skybox images are already downloaded.")
    end

    self:BuildFolderTree()
    self.Downloading = true

    local Average = self:GetAverageSize()
    local Estimated = 0
    local AllTotal = 0

    for _, Item in ipairs(Queue) do
        for _, Entry in ipairs(Item.Faces) do
            Entry.Size = Entry.Face.Size or Average
            AllTotal = AllTotal + Entry.Size

            if not Entry.Face.Size then
                Estimated = Estimated + 1
            end
        end
    end

    local Session = { Cancelled = false, InSection = false }

    local Dialog = self.Library.Window:Dialog({
        Title = "Downloading Skyboxes",
        Content = "",
        Bars = {
            { Title = "All Skyboxes", Value = self:FormatProgress(0, AllTotal, Estimated > 0) },
            { Title = "Current Skybox", Value = "" },
        },
        Buttons = {
            {
                Title = "Move to Section",
                Variant = "Tonal",
                Callback = function()
                    Session.InSection = true
                    self:SetProgressVisible(true)
                end,
            },
            {
                Title = "Cancel",
                Variant = "Danger",
                Callback = function()
                    Session.Cancelled = true
                end,
            },
        },
    })

    local function Report(Index, Alpha, Value, Title)
        if Session.InSection then
            local Row = Index == 1 and self.AllProgress or self.CurrentProgress

            if Title then
                Row:SetTitle(Title)
            end

            Row:SetValue(Alpha * 100)
            Row:SetDisplay(Value)
        else
            pcall(Dialog.SetBar, Dialog, Index, Alpha, Value, Title)
        end
    end

    task.spawn(function()
        local AllDone = 0
        local Failed = 0
        local Finished = 0

        for Position, Item in ipairs(Queue) do
            if Session.Cancelled then
                break
            end

            local SkyTotal = 0
            local SkyDone = 0

            for _, Entry in ipairs(Item.Faces) do
                SkyTotal = SkyTotal + Entry.Size
            end

            pcall(makefolder, self.Folder .. "/" .. Item.Data.Folder)

            for _, Entry in ipairs(Item.Faces) do
                if Session.Cancelled then
                    break
                end

                Report(
                    2,
                    SkyDone / SkyTotal,
                    self:FormatProgress(SkyDone, SkyTotal, not Entry.Face.Size),
                    string.format("%s  %d / %d", Item.Name, Position, #Queue)
                )

                local Bytes = self:Download(Entry.Face.Url, Entry.Path)

                if Bytes then
                    AllTotal = AllTotal - Entry.Size + Bytes
                    SkyTotal = SkyTotal - Entry.Size + Bytes
                    AllDone = AllDone + Bytes
                    SkyDone = SkyDone + Bytes
                else
                    Failed = Failed + 1
                    AllTotal = AllTotal - Entry.Size
                    SkyTotal = SkyTotal - Entry.Size
                end

                if not Entry.Face.Size then
                    Estimated = Estimated - 1
                end

                Report(1, AllDone / math.max(AllTotal, 1), self:FormatProgress(AllDone, AllTotal, Estimated > 0))
                Report(2, SkyDone / math.max(SkyTotal, 1), self:FormatProgress(SkyDone, SkyTotal, false))
                task.wait()
            end

            Finished = Position
        end

        self.Downloading = false

        if Session.Cancelled then
            self:SetProgressVisible(false)
            return self:Notify(string.format("Download cancelled. %d of %d skyboxes finished.", Finished, #Queue))
        end

        Report(1, 1, self:FormatProgress(AllDone, AllDone, false))
        task.wait(0.5)

        if Session.InSection then
            self:SetProgressVisible(false)
        else
            pcall(Dialog.Close, Dialog)
        end

        if Failed > 0 then
            self:Notify(string.format("Download finished with %d failed images.", Failed))
        else
            self:Notify("All skyboxes downloaded.")
        end
    end)
end

function Skybox:ClearSky()
    for _, Child in pairs(Lighting:GetChildren()) do
        if Child:IsA("Sky") then Child:Destroy() end
    end
end

function Skybox:Apply(Data)
    if not self:IsAllowed(Data) then
        error("Age verification required")
    end

    self:ClearSky()

    local NativeSky = Instance.new("Sky")
    NativeSky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
    NativeSky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
    NativeSky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
    NativeSky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
    NativeSky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
    NativeSky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
    NativeSky.Parent = Lighting
    NativeSky:Destroy()

    for _, Child in pairs(Lighting:GetChildren()) do
        if Child:IsA("Atmosphere") then Child.Haze = 0 end
    end

    local SkyInstance = Instance.new("Sky")
    SkyInstance.Name = "Sky"
    SkyInstance.CelestialBodiesShown = false
    SkyInstance.StarCount = Data.StarCount or 0
    if Data.SunAngularSize then SkyInstance.SunAngularSize = Data.SunAngularSize end
    if Data.MoonAngularSize then SkyInstance.MoonAngularSize = Data.MoonAngularSize end

    if Data.RbxAssetIds then
        for Prop, Id in pairs(Data.RbxAssetIds) do
            SkyInstance[Prop] = Id
        end
    elseif Data.Faces then
        local Folder = self.Folder .. "/" .. Data.Folder
        self:BuildFolderTree()
        pcall(makefolder, Folder)
        for _, Face in ipairs(Data.Faces) do
            local Path = self:FacePath(Data, Face)
            if not isfile(Path) and not self:Download(Face.Url, Path) then
                error("Failed to download " .. Face.File)
            end
            SkyInstance[Face.Prop] = getcustomasset(Path)
        end
    end

    SkyInstance.Parent = Lighting
end

function Skybox:ApplySelected()
    local Data = self.Skyboxes[self.Selected]
    if not Data then return false end
    return pcall(self.Apply, self, Data)
end

function Skybox:ApplySelectedSafely()
    if not self.Skyboxes[self.Selected] then return end
    self.Applying = true
    self:ApplySelected()
    task.wait(0.2)
    self.Applying = false
end

function Skybox:SetLock(State)
    self.Locked = State
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if not State then return end

    self:ApplySelectedSafely()
    self.Connection = Lighting.ChildAdded:Connect(function(Child)
        if not self.Locked then return end
        if self.Applying then return end
        if Child:IsA("Sky") then
            task.wait(0.1)
            self:ApplySelectedSafely()
        end
    end)
end

function Skybox:ResolveInput(Value, FaceName)
    Value = tostring(Value or ""):gsub("^%s*(.-)%s*$", "%1")
    if Value == "" then return nil end
    if Value:match("^rbxassetid://") then
        return Value
    elseif Value:match("^%d+$") then
        return "rbxassetid://" .. Value
    elseif Value:match("^https?://") then
        self:BuildFolderTree()
        local Path = self.Folder .. "/Custom/" .. FaceName .. ".png"
        local Ok = pcall(function() writefile(Path, game:HttpGet(Value, true)) end)
        if Ok then return getcustomasset(Path) end
    end
    return nil
end

function Skybox:ApplyCustom()
    local PropMap = { Lf = "SkyboxLf", Rt = "SkyboxRt", Up = "SkyboxUp", Dn = "SkyboxDn", Ft = "SkyboxFt", Bk = "SkyboxBk" }

    self:ClearSky()

    local SkyInstance = Instance.new("Sky")
    SkyInstance.Name = "Sky"
    SkyInstance.CelestialBodiesShown = false
    SkyInstance.StarCount = 0

    local AppliedAny = false
    for Face, Prop in pairs(PropMap) do
        local Resolved = self:ResolveInput(self.CustomInputs[Face], Face)
        if Resolved then
            SkyInstance[Prop] = Resolved
            AppliedAny = true
        end
    end

    if AppliedAny then
        SkyInstance.Parent = Lighting
        self:Notify("Custom skybox applied.")
    else
        SkyInstance:Destroy()
        self:Notify("No valid inputs provided.")
    end
end

function Skybox:RefreshNames()
    if not self.Dropdown then
        return
    end

    local Names = self:GetNames(true)
    local Current = self.Skyboxes[self.Selected]

    self.Dropdown:SetValues(Names)

    if not Current or not self:IsAllowed(Current) then
        self.Selected = Names[1]
        self.Dropdown:SetValue(Names[1])
    end
end

function Skybox:GetAgeText()
    local Status = self.AgeGate and self.AgeGate:GetStatus() or "Restricted"

    if Status == "Adult" then
        return "Verified 18+. All skyboxes unlocked"
    end

    if Status == "Teen" then
        return "Mature unlocked. Verify to unlock NSFW"
    end

    local Hint = self.AgeGate and self.AgeGate:GetHint() or "Age verification is not available."

    return "Restricted. " .. Hint
end

function Skybox:UpdateAgeButton()
    if not self.AgeButton then
        return
    end

    self.AgeButton:SetDesc(self:GetAgeText())
    self.AgeButton:SetVisible(not (self.AgeGate and self.AgeGate:GetLevel() == 2))
end

function Skybox:VerifyAge()
    if not self.AgeGate then
        return self:Notify("Age verification is not available.")
    end

    self.AgeGate:Refresh()
    self:RefreshNames()
    self:UpdateAgeButton()

    self.AgeGate:Confirm(function()
        self:RefreshNames()
        self:UpdateAgeButton()
        self:Notify("NSFW skyboxes unlocked.")
    end)
end

function Skybox:RecheckAge()
    if not self.AgeGate then
        return
    end

    self.AgeGate:Refresh()
    self:RefreshNames()
    self:UpdateAgeButton()
end

function Skybox:BuildSkyboxSection(Tab)
    assert(self.Library, "Must set Skybox.Library")

    local Names = self:GetNames(true)
    self.Selected = self.Selected or Names[1]

    local Changer = Tab:AddSection("Skybox Changer")

    self.Dropdown = Changer:AddDropdown("Skybox_BuiltIn", {
        Title = "Skybox",
        Icon = "cloud",
        Values = Names,
        Default = self.Selected,
        Searchable = true,
        Variant = "Compact",
        Width = 190,
        Tags = self.Tags,
        ItemTags = self:GetItemTags(),
        Callback = function(Value) self.Selected = Value end
    })

    Changer:AddButton({
        Title = "Apply Skybox",
        Icon = "check",
        Variant = "Accent",
        Callback = function()
            local Data = self.Skyboxes[self.Selected]
            if not Data then return end
            if not self:IsAllowed(Data) then
                return self:Notify("Verify your age to use this skybox.")
            end
            if self:ApplySelected() then
                self:Notify(self.Selected .. " applied.")
            else
                self:Notify("Failed to apply skybox.")
            end
        end
    })

    self.AgeButton = Changer:AddButton({
        Title = "Age Verification",
        Description = self:GetAgeText(),
        Variant = "Tonal",
        ButtonText = "Verify",
        ButtonIcon = "shield-check",
        Callback = function() self:VerifyAge() end
    })

    self:UpdateAgeButton()

    task.delay(5, function()
        self:RecheckAge()
    end)

    Changer:AddButton({
        Title = "Download All",
        Description = "Cache every skybox image so they apply instantly",
        Variant = "Tonal",
        ButtonText = "Download",
        ButtonIcon = "download",
        Callback = function() self:DownloadAll() end
    })

    self.AllProgress = Changer:AddProgress({ Title = "All Skyboxes", Value = 0 })
    self.CurrentProgress = Changer:AddProgress({ Title = "Current Skybox", Value = 0 })
    self:SetProgressVisible(false)

    Changer:AddToggle("Skybox_Lock", {
        Title = "Lock Skybox",
        Icon = "lock",
        Variant = "Radio",
        Default = false,
        Callback = function(State) self:SetLock(State) end
    })

    Changer:AddParagraph({
        Title = "Skybox Info",
        Icon = "info",
        Variant = "Note",
        Content = "Apply custom skyboxes. Some may take a moment to load. Use Lock/force mode to keep it Forever."
    })

    local Custom = Tab:AddSection("Custom Skybox")
    local Faces = {
        { Key = "Lf", Title = "Left (Lf)" },
        { Key = "Rt", Title = "Right (Rt)" },
        { Key = "Up", Title = "Top (Up)" },
        { Key = "Dn", Title = "Down (Dn)" },
        { Key = "Ft", Title = "Front (Ft)" },
        { Key = "Bk", Title = "Back (Bk)" },
    }

    for _, Face in ipairs(Faces) do
        Custom:AddInput("Skybox_" .. Face.Key, {
            Title = Face.Title,
            Variant = "Field",
            Placeholder = "rbxassetid or URL",
            Finished = false,
            Callback = function(Value) self.CustomInputs[Face.Key] = Value end
        })
    end

    Custom:AddButton({
        Title = "Apply Custom Skybox",
        Icon = "check",
        Variant = "Accent",
        Callback = function() self:ApplyCustom() end
    })

    Custom:AddParagraph({
        Title = "Custom Skybox Info",
        Icon = "info",
        Variant = "Note",
        Content = "Upload 6 cube skybox faces to Roblox or use direct download links, then enter the URL or rbxassetid into the 6 inputs in the correct cube directions."
    })
end

Skybox:BuildFolderTree()

return Skybox
