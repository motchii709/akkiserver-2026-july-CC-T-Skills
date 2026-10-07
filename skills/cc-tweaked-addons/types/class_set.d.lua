---@meta

return {
    ---@class Modem
    modem = {
        ---@param channel integer
        open = function(channel) end,
        ---@param channel integer
        isOpen = function(channel) end,
        ---@param channel integer
        close = function(channel) end,
        closeAll = function() end,
        ---@param channel integer
        ---@param replyChannel integer
        ---@param payload number|integer|string|boolean|table
        transmit = function(channel, replyChannel, payload) end,
        iswireless = function() end,
        ---@return ...
        getNamesRemote = function() end,
        ---@param name string
        isPresentRemote = function(name) end,
        ---@return string|nil
        ---@param name string
        getTypeRemote = function(name) end,
        ---@param name string
        ---@param type string
        hasTypeRemote = function(name, type) end,
        ---@param name string
        ---@return ...
        getMethodsRemote = function(name) end,
        ---@param remotename string
        ---@param method string
        ---@param ... string
        callRemote = function(remotename, method, ...) end,
        ---@return string|nil
        getNameLocal = function() end,
    },
    ---@class PlayerDetector
    playerDetector = {
        ---@param username string
        ---@return {dimension: string,eyeHeight: number,pitch: number,health: number,maxHealth: number,airSupply: number,respawnPosition: number,respawnDimension: number,respawnAngle: number,yaw: number,x: number,y: number,z: number}
        getPlayerPos = function(username) end,
        ---@return string[]
        getOnlinePlayers = function() end,
        ---@param range number
        ---@return string[]
        getPlayersInRange = function(range) end,
        ---@param posOne {x:number,y:number,z:number}
        ---@param posTwo {x:number,y:number,z:number}
        ---@return string[]
        getPlayersInCoords = function(posOne, posTwo) end,
        ---@return boolean
        ---@param w number
        ---@param h number
        ---@param d number
        getPlayersInCubic = function(w, h, d) end,
        ---@param range number
        ---@param username string
        ---@return boolean
        isPlayerInRange = function(range, username) end,
        ---@param posOne {x:number,y:number,z:number}
        ---@param posTwo {x:number,y:number,z:number}
        ---@param username string
        ---@return boolean
        isPlayerInCoords = function(posOne, posTwo, username) end,
        ---@return boolean
        ---@param w number
        ---@param h number
        ---@param d number
        isPlayerInCubic = function(w, h, d) end,
        ---@param range number
        ---@return boolean
        isPlayersInRange = function(range, username) end,
        ---@param posOne {x:number,y:number,z:number}
        ---@param posTwo {x:number,y:number,z:number}
        ---@return boolean
        isPlayersInCoords = function(posOne, posTwo, username) end,
        ---@return boolean
        ---@param w number
        ---@param h number
        ---@param d number
        isPlayersInCubic = function(w, h, d) end,
    },
    ---@class ChatBox
    chatBox = {
        ---@return true|nil,string?
        ---@param message string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendMessage = function(message, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param message string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendMessageToPlayer = function(message, username, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param json string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendFormattedMessage = function(json, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param json string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendFormattedMessageToPlayer = function(json, username, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param message string
        ---@param title string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendToastToPlayer = function(message, title, username, prefix, brackets, bracketColor, range) end,
        ---@return true|nil,string?
        ---@param json string
        ---@param title string
        ---@param username string
        ---@param prefix string?
        ---@param brackets string?
        ---@param bracketColor string?
        ---@param range number?
        sendFormattedToastToPlayer = function(json, title, username, prefix, brackets, bracketColor, range) end,
    },
    ---@class ReadStream
    readStream = {
        close = function() end,
        ---@return string
        read = function() end,
        ---@return string
        readAll = function() end,
        ---@return string
        readLine = function() end,

        seek = function() end
    },
    ---@class WriteStream
    writeStream = {
        close = function() end,
        ---@param str string
        write = function(str) end,
        seek = function() end,
        flush = function() end,
        ---@param line string
        writeLine = function(line) end,
    },
    ---@class Inventory
    inventory = {
        size = function() end,
        ---@return {name:string,count:number}[]
        list = function() end,
        ---@param slot number
        getItemDetail = function(slot) end,
        ---@param slot number
        getItemLimit = function(slot) end,
        ---@param toName string
        ---@param fromSlot number
        ---@param limit? number
        ---@param toSlot? string
        ---@return integer
        pushItems = function(toName, fromSlot, limit, toSlot) end,
        ---@param fromName string
        ---@param fromSlot number
        ---@param limit number
        ---@param toSlot string
        ---@return integer
        pullItems = function(fromName, fromSlot, limit, toSlot) end,
    },
    ---@class TrainStation Create_Station
    trainStation = {
        assemble = function() end,
        disassemble = function() end,
        ---@param assemblyMode boolean
        setAssemblyMode = function(assemblyMode) end,
        ---@return boolean
        isInAssemblyMode = function() end,
        ---@return string
        getStationName = function() end,
        ---@param name string
        setStationName = function(name) end,
        ---@return boolean
        isTrainPresent = function() end,
        ---@return boolean
        isTrainImminent = function() end,
        ---@return boolean
        isTrainEnroute = function() end,
        ---@return string
        getTrainName = function() end,
        ---@param name string
        setTrainName = function(name) end,
        ---@return table
        hasSchedule = function() end,
        ---@return table
        getSchedule = function() end,
        ---@param schedule string
        setSchedule = function(schedule) end,
    },
    ---@class Frogport Create_Frogport
    frogport = {
        ---@return string
        getAddress = function() end,
        ---@return "send_recieve"|"send"
        getConfiguration = function() end,
        ---@return {name:string,count:number}[]
        list = function() end,
        ---@param slot number
        getItemDetail = function(slot) end,
        ---@param addr string
        setAddress = function(addr) end,
        ---@param configration "send_recieve"|"send"
        setConfiguration = function(configration) end,
    }, ---@class StockTicker Create_StockTicker
    stockTicker = {
        ---@return {name:string,count:number}[]
        stock = function() end,
        ---@param address string
        ---@param ... {name:string,count?:number}
        ---@return number
        requestFiltered = function(address, ...) end
    },
    ---@class InventoryManager inventoryManager
    inventoryManager = {
        ---@return number
        ---@param direction string
        ---@param item ItemInterface
        addItemToPlayer = function(direction, item) end,
        ---@return number
        ---@param direction string
        ---@param item ItemInterface
        removeItemFromPlayer = function(direction, item) end,
        ---@return ItemInterface[]
        getArmor = function() return {} end,
        ---@return ItemInterface[]
        getItems = function() return {} end,
        ---@return string?
        getOwner = function() end,
        ---@return boolean
        isPlayerEquipped = function() end,
        ---@return boolean
        ---@param slot number
        isWearing = function(slot) end,
        ---@return ItemInterface
        getItemInHand = function() return {} end,
        ---@return ItemInterface
        getItemInOffHand = function() return {} end,
        ---@return number
        getFreeSlot = function() end,
        ---@return boolean
        isSpaceAvailable = function() end,
        ---@return number
        getEmptySpace = function() end,
        ---@return ItemInterface[]
        ---@param direction string
        listChest = function(direction) end,
        ---@return ItemInterface[]
        list = function() return {} end,
    },
    ---@class ItemInterface
    item = {
        ---@type string
        name = "",
        ---@type number?
        count = 0,
        ---@type number?
        toSlot = 0,
        ---@type number?
        fromSlot = 0,
        ---@type string?
        fingerprint = "",
        ---@type number?
        maxStackSize = 0,
        ---@type string?
        displayName = "",
        ---@type number?
        slot = 0,
        ---@type string[]?
        tags = {}
    },
    ---@class DisplayLink Create_DisplayLink
    displayLink = {
        clear = function() end,
        clearLine = function() end,
        ---@return number x,number y
        getCursorPos = function() end,
        ---@return number lines, number chars
        getSize = function() end,
        ---@return boolean
        isColor = function() end,
        ---@return boolean
        isColour = function() end,
        ---@param x number
        ---@param y number
        setCursorPos = function(x, y) end,
        update = function() end,
        ---@param content string
        write = function(content) end,
        ---@param content string|number[]
        writeBytes = function(content) end,
    },
    colonies = {
        ---@class ColonyIntegrator
        colonyIntegrator = {
            ---@return ColonyCitizen[]
            getCitizens = function() end,
            ---@return ColonyVisitor[]
            getVisitors = function() end,
            ---@return ColonyBuilding[]
            getBuildings = function() end,
            ---@return ColonyResearch[]
            getResearch = function() end,
            ---@return ColonyRequest[]
            getRequests = function() end,
            ---@return ColonyWorkOrder[]
            getWorkOrders = function() end,
            ---@return ColonyWorkOrderResource[]
            ---@param workOrderId number
            getWorkOrderResources = function(workOrderId) end,
            ---@return ColonyBuilderResource[]
            getBuilderResources = function() end,
            ---@return number
            getColonyID = function() end,
            ---@return string
            getColonyName = function() end,
            ---@return "Ancient Athens"|"Caledonia"|"Cavern"|"Colonial"|"Dark Oak Treehouse"|"Desert Oasis"|"Fortress"|"Incan"|"Jungle Treehouse"|"Lost Mesa City"|"Minecolonies Classic"|"Medieval Birch"|"Medieval Dark Oak"|"Medieval Oak"|"Medieval Spruce"|"Nordic Spruce"|"Pagoda"|"Shire"|"Space Wars"|"Stalactite Caves"|"Urban Birch"|"Urban Savanna"|"Warped"
            getColonyStyle = function() end,
            ---@return {x:number,y:number,z:number}
            getLocation = function() end,
            ---@return number
            getHappiness = function() end,
            ---@return boolean
            isActive = function() end,
            ---@return boolean
            isUnderAttack = function() end,
            ---@return boolean
            isInColony = function() end,
            ---@param pos {x:number,y:number,z:number}
            ---@return boolean
            isWithin = function(pos) end,
            ---@return number
            amountOfCitizens = function() end,
            ---@return number
            maxOfCitizens = function() end,
            ---@return number
            amountOfGraves = function() end,
            ---@return number
            amountOfConstructionSites = function() end,
        },
        ---@class ColonyCitizen
        c = {
            ---@type string
            id = "",
            ---@type string
            name = "",
            ---@type "child"|"adult"
            age = "child",
            ---@type "male"|"female"
            gender = "male",
            ---@type {x:number,y:number,z:number}
            location = { x = 0, y = 0, z = 0 },
            ---@type {x:number,y:number,z:number}
            bedPos = { x = 0, y = 0, z = 0 },
            ---@type number
            saturation = 0,
            ---@type boolean
            happiness = false,
            ---@type number|nil
            health = nil,
            ---@type number|nil
            maxHealth = nil,
            ---@type number|nil
            armor = nil,
            ---@type number|nil
            toughness = nil,
            ---@type boolean
            betterFood = false,
            ---@type boolean
            isAsleep = false,
            ---@type boolean
            isIdle = false,
            ---@type string
            state = "",
            ---@type string[]
            children = {},
            ---@type {level:string,xp:number}[]
            skills = {},
            ---@type ColonyCitizenWork|nil
            work = nil,
            ---@type ColonyCitizenHome|nil
            home = nil
        },
        ---@class ColonyCitizenWork
        cw = {
            ---@type string
            name = "",
            ---@type string
            job = "",
            ---@type {x:number,y:number,z:number}
            location = { x = 0, y = 0, z = 0 },
            ---@type string
            type = "",
            ---@type number
            level = 0
        },
        ---@class ColonyCitizenHome
        ch = {
            ---@type {x:number,y:number,z:number}
            location = { x = 0, y = 0, z = 0 },
            ---@type string
            type = "",
            ---@type number
            level = 0
        },
        ---@class ColonyVisitor: ColonyCitizen
        v = {
            ---@class ColonyItemInterface
            recruitCost = {
                ---@type string
                name = "",
                ---@type number
                count = 0,
                ---@type number
                maxStackSize = 0,
                ---@type string
                displayName = "",
                ---@type string[]
                tags = {},
                ---@type table
                nbt = {}
            },
        },
        ---@class ColonyBuilding
        b = {
            ---@type string
            name = "",
            ---@type {x:number,y:number,z:number}
            location = { x = 0, y = 0, z = 0 },
            ---@type string
            type = "",
            ---@type number
            level = 0,
            ---@type number
            maxLevel = 0,
            ---@type string
            style = "",
            ---@type number
            storageBlocks = 0,
            ---@type number
            storageSlots = 0,
            ---@type boolean
            guarded = false,
            ---@type boolean
            built = false,
            ---@type boolean
            isWorkingOn = false,
            ---@type number
            priority = 0,
            ---@class ColonyBuildingStructure
            structure = {
                ---@type {x:number,y:number,z:number}
                cornerA = { x = 0, y = 0, z = 0 },
                ---@type {x:number,y:number,z:number}
                cornerB = { x = 0, y = 0, z = 0 },
                ---@type number
                rotation = 0,
                ---@type boolean
                mirror = false,
            },
            ---@type {name:string,id:string}[]
            citizens = {}
        },
        ---@class ColonyResearch
        r = {
            ---@type string
            id = "",
            ---@type string
            name = "",
            ---@type number
            status = 0,
            ---@type any[]
            researchEffects = {},
            ---@type any[]|nil
            children = {},
            ---@type number
            progress = 0,
            ---@type (ColonyResearchRequirements|ColonyResearchBuildingRequirements)[]
            requirements = {},
            ---@type ColonyItemInterface[]
            cost = {}
        },
        ---@class ColonyResearchRequirements
        rr = {
            ---@type string
            type = "",
            ---@type string
            desc = "",
            ---@type boolean
            fulfilled = false,
        },
        ---@class ColonyResearchBuildingRequirements: ColonyResearchRequirements
        rbr = {
            ---@type string
            building = "",
            ---@type number
            level = 0
        },
        ---@class ColonyRequest
        req = {
            ---@type string
            id = "",
            ---@type string
            name = "",
            ---@type string
            desc = "",
            ---@type string
            state = "",
            ---@type number
            count = 0,
            ---@type number
            minCount = 0,
            ---@type string
            target = "",
            ---@type ColonyItemInterface[]
            items = {},
        },
        ---@class ColonyWorkOrder
        wo = {
            ---@type number
            id = 0,
            ---@type number
            priority = 0,
            ---@type string
            workOrderType = "",
            ---@type boolean
            changed = false,
            ---@type boolean
            isClaimed = false,
            builder = {
                ---@type number
                x = 0,
                ---@type number
                y = 0,
                ---@type number
                z = 0,
            },
            ---@type string
            buildingName = "",
            ---@type string
            type = "",
            ---@type number
            targetLevel = 0,
        },
        ---@class ColonyWorkOrderResource
        wor = {
            ---@type ItemInterface
            item = {},
            ---@type string
            displayName = "",
            ---@type string
            status = "",
            ---@type number
            needs = 0,
            ---@type number
            available = 0,
            ---@type boolean
            delivering = false,
        }

    },
    ---@class NixieTube Create_NixieTube
    NixieTube = {
        ---@param led1 NixieTubeSignal|nil
        ---@param led2 NixieTubeSignal|nil
        setSignal = function(led1, led2) end,
        ---@param text string
        setText = function(text) end,
        ---@param color "black"|"blue"|"brown"|"cyan"|"gray"|"grey"|"green"|"light_blue"|"light_gray"|"lime"|"magenta"|"orange"|"pink"|"purple"|"red"|"white"|"yellow"|"BLACK"|"BLUE"|"BROWN"|"CYAN"|"GRAY"|"GREEN"|"LIGHT_BLUE"|"LIGHT_GRAY"|"LIME"|"MAGENTA"|"ORANGE"|"PINK"|"PURPLE"|"RED"|"WHITE"|"YELLOW"
        setTextColor = function(color) end,
        ---@param colour "black"|"blue"|"brown"|"cyan"|"gray"|"grey"|"green"|"light_blue"|"light_gray"|"lime"|"magenta"|"orange"|"pink"|"purple"|"red"|"white"|"yellow"|"BLACK"|"BLUE"|"BROWN"|"CYAN"|"GRAY"|"GREEN"|"LIGHT_BLUE"|"LIGHT_GRAY"|"LIME"|"MAGENTA"|"ORANGE"|"PINK"|"PURPLE"|"RED"|"WHITE"|"YELLOW"
        setTextColour = function(colour) end,
    },
    ---@class NixieTubeSignal
    NixieTubeSignal = {
        ---@type number|nil 0 ~ 255
        r = 0,
        ---@type number|nil 0 ~ 255
        g = 0,
        ---@type number|nil 0 ~ 255
        b = 0,
        ---@type number|nil 1 ~ 4
        glowWidth = 0,
        ---@type number|nil 1 ~ 4
        glowHeight = 0,
        ---@type number|nil 0 ~ 255
        blinkPeriod = 0,
        ---@type number|nil 0 ~ 255
        blinkOffTime = 0,
    },
    ---@class TrainSignal Create_Signal
    TrainSignal = {
        cycleSignalType = function() end,
        ---@return "ENTRY_SIGNAL"|"CROSS_SIGNAL"
        getSignalType = function() end,
        ---@return "RED"|"GREEN"|"YELLOW"
        getState = function() end,
        ---@return boolean
        isForcedRed = function() end,
        ---@return string[]
        listBlockingTrainNames = function() end,
        ---@param forcedRed boolean
        setForcedRed = function(forcedRed) end
    }
}
