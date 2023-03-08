Config = {}

--set to true if not using ESX Legacy | 設定為true如果不是使用ESX Legacy
Config.oldESX = false
--set to true if using ox_inventory | 設定為true如果使用ox_inventory
Config.oxinv = true
--set to true if using weight inventory system | 設定為true如果使用重量系統
Config.weight = false

Config.Locale = 'en'

Config.Webhook = 'https://discord.com/api/webhooks/'

--marker settings | 光圈設定
Config.DrawDistance = 20.0

Config.Marker = {type = 1, x = 4.0, y = 4.0, z = 0.5, r = 255, g = 255, b = 0}

Config.Safezone = 10.0


--key to trigger, index and name should match | 觸發的按鍵, index 與 name 需要對上
--refer to | 請參考 https://docs.fivem.net/docs/game-references/controls/
Config.Control = {index = 38, name = '~INPUT_PICKUP~'} 

Config.cd = 5   --time until next trigger can be done (in sec) | 直到下次可以再次觸發的時間 (秒)

--setting for harvest/processing spots | 採集/加工點設定
Config.Harvest = {
    --tailor 裁縫
    {
        job = 'tailor', --job required, put nil to disable | 限定工作, 設定為nil來禁用
        blip = {    --map blip, put nil to disable | 地圖點, 設定為nil來禁用
            sprite = 366,   --blip sprite | 地圖點圖示
            color = 4,   --blip color | 地圖點顏色
            label = 'Wool'
        },
        coords = vec3(1978.92, 5171.70, 46.63), --position of the spot | 採集/加工點位置

        label = 'to harvest wool',   --hint in the help notification | 按鍵提示後面的文字
        material = nil, --item to be removed, can set multiple items, put nil to disable | 移除的物品, 可以設定多個物品, 設定為nil來禁用
        product = { --items to be given, can set multiple items | 給予的物品, 可以設定多個物品
            --chance: when a random 0-100 number falls into the range, item will be given | chance: 當隨機 0-100 的數字落在這個範圍時, 給予物品
            {name = 'wool', count = 1, chance = vec2(0, 100)} 
        },
        time = 3    --time interval for the harvest to happen (in sec.) | 採集發生的時間間隔 (秒)
    },

    {
        job = 'tailor', --job required, put nil to disable | 限定工作, 設定為nil來禁用
        blip = {    --map blip, put nil to disable | 地圖點, 設定為nil來禁用
            sprite = 366,   --blip sprite | 地圖點圖示
            color = 4,   --blip color | 地圖點顏色
            label = 'Tailor shop'
        },
        coords = vec3(715.95, -959.63, 29.39), --position of the spot | 採集/加工點位置

        label = 'to process fabric',   --hint in the help notification | 按鍵提示後面的文字
        material = {
            {name = 'wool', count = 1}
        }, --item to be removed, can set multiple items, put nil to disable | 移除的物品, 可以設定多個物品, 設定為nil來禁用
        product = { --items to be given, can set multiple items | 給予的物品, 可以設定多個物品
            --chance: when a random 0-100 number falls into the range, item will be given | chance: 當隨機 0-100 的數字落在這個範圍時, 給予物品
            {name = 'fabric', count = 2, chance = vec2(0, 100)} 
        },
        time = 5    --time interval for the harvest to happen (in sec.) | 採集發生的時間間隔 (秒)
    },

    {
        job = 'tailor', --job required, put nil to disable | 限定工作, 設定為nil來禁用
        blip = nil,  --map blip, put nil to disable | 地圖點, 設定為nil來禁用
        coords = vec3(712.92, -970.58, 29.39), --position of the spot | 採集/加工點位置

        label = 'to process clothe',   --hint in the help notification | 按鍵提示後面的文字
        material = {
            {name = 'fabric', count = 2}
        }, --item to be removed, can set multiple items, put nil to disable | 移除的物品, 可以設定多個物品, 設定為nil來禁用
        product = { --items to be given, can set multiple items | 給予的物品, 可以設定多個物品
            --chance: when a random 0-100 number falls into the range, item will be given | chance: 當隨機 0-100 的數字落在這個範圍時, 給予物品
            {name = 'clothe', count = 1, chance = vec2(0, 100)} ,
            --{name = 'something_rare', count = 1, chance = vec2(90, 100)} 
        },
        time = 5    --time interval for the harvest to happen (in sec.) | 採集發生的時間間隔 (秒)
    },

    --orange juice 柳橙汁
    {
        job = nil, --job required, put nil to disable | 限定工作, 設定為nil來禁用
        blip = {    --map blip, put nil to disable | 地圖點, 設定為nil來禁用
            sprite = 285,   --blip sprite | 地圖點圖示
            color = 17,   --blip color | 地圖點顏色
            label = 'Orange Harvest'
        },
        coords = vec3(-1862.72, 2145.03, 121.91), --position of the spot | 採集/加工點位置

        label = 'to harvest oranges',   --hint in the help notification | 按鍵提示後面的文字
        material = nil, --item to be removed, can set multiple items, put nil to disable | 移除的物品, 可以設定多個物品, 設定為nil來禁用
        product = { --items to be given, can set multiple items | 給予的物品, 可以設定多個物品
            --chance: when a random 0-100 number falls into the range, item will be given | chance: 當隨機 0-100 的數字落在這個範圍時, 給予物品
            {name = 'orange', count = 1, chance = vec2(0, 100)} 
        },
        time = 5    --time interval for the harvest to happen (in sec.) | 採集發生的時間間隔 (秒)
    },

    {
        job = nil, --job required, put nil to disable | 限定工作, 設定為nil來禁用
        blip = {    --map blip, put nil to disable | 地圖點, 設定為nil來禁用
            sprite = 285,   --blip sprite | 地圖點圖示
            color = 17,   --blip color | 地圖點顏色
            label = 'Orange Harvest'
        },
        coords = vec3(-440.67, 1595.11, 357.47), --position of the spot | 採集/加工點位置

        label = 'to harvest oranges',   --hint in the help notification | 按鍵提示後面的文字
        material = {
            {name = 'orange', count = 2}
        }, --item to be removed, can set multiple items, put nil to disable | 移除的物品, 可以設定多個物品, 設定為nil來禁用
        product = { --items to be given, can set multiple items | 給予的物品, 可以設定多個物品
            --chance: when a random 0-100 number falls into the range, item will be given | chance: 當隨機 0-100 的數字落在這個範圍時, 給予物品
            {name = 'orange_juice', count = 1, chance = vec2(0, 100)} 
        },
        time = 5    --time interval for the harvest to happen (in sec.) | 採集發生的時間間隔 (秒)
    },
}
