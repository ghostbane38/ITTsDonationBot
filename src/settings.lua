local ITTDB = ITTsDonationBot
local logger = ITTDB.logger
local worldName = GetWorldName()

-- --------------------
-- Create Settings
-- --------------------
local function makeSettings( defaults )
    local optionsData = {}
    local guildLotto = 1
    local lottotTicketValue = 1000

    logger:Info('makeSettings()')
    
    local db = ITTDB.db

    local panelData = {
        type = "panel",
        name = ITTDB:parse( "NAME" ),
        author = '|c00a313Ghostbane|r & |c268074JN Slevin|r',
        version = '{{VERSION}}',
        website = 'https://www.esoui.com/downloads/info2765-ITTsDonationBotITTDB.html'
    }

    optionsData[ #optionsData + 1 ] = {
        type = "header",
        name = ITTDB:parse( "HEADER_GUILDS" )
    }


    local function getGuildNameTable()
        local tb = {}
        local guildMap = ITTDB:GetGuildMap()
        for i = 1, GetNumGuilds() do
            local guildId = GetGuildId( i )
            if
                ZO_IsElementInNumericallyIndexedTable( guildMap, guildId ) then
                tb[ #tb+1 ] = ITTDB.CreateGuildLink( GetGuildId( i ) )
            end
        end

        return tb
    end
    
    local function getGuildIndexTable()
        local tb = {}
        local guildMap = ITTDB:GetGuildMap()
        for i = 1, GetNumGuilds() do
            local guildId = GetGuildId( i )
            if
                ZO_IsElementInNumericallyIndexedTable( guildMap, guildId ) then
                tb[ #tb+1 ] = i
            end
        end

        return tb
    end


    optionsData[ #optionsData + 1 ] = {
        type = "description",
        title = "",
        text = ITTDB:parse( "SETTINGS_DESC" )
    }

    for i = 1, 5 do
        optionsData[ #optionsData + 1 ] = {
            type = "checkbox",
            name = function()
                return db.settings[ worldName ].guilds[ i ].name
            end,
            tooltip = function()
                if db.settings[ worldName ].guilds[ i ].disabled then
                    return ITTDB:parse( "SETTINGS_SCAN_ERROR" )
                else
                    return ITTDB:parse( "SETTINGS_SCAN_PROMPT", { guild = db.settings[ worldName ].guilds[ i ].name } )
                end
            end,
            disabled = function()
                return db.settings[ worldName ].guilds[ i ].disabled
            end,
            getFunc = function()
                return db.settings[ worldName ].guilds[ i ].selected
            end,
            setFunc = function( value )
                db.settings[ worldName ].guilds[ i ].selected = value
            end,
            default = defaults.settings[ worldName ].guilds[ i ].selected,
            reference = "ITTDBSettingsGuild" .. tostring( i )
        }
    end

    optionsData[ #optionsData + 1 ] = {
        type = "description",
        title = "",
        text = ITTDB:parse( "SETTINGS_SCAN_INFO" )
    }

    optionsData[ #optionsData + 1 ] = {
        type = "header",
        name = ITTDB:parse( "HEADER_NOTIFY" )
    }

    optionsData[ #optionsData + 1 ] = {
        type = "description",
        title = "",
        text = ITTDB:parse( "SETTINGS_NOTIFY" )
    }

    optionsData[ #optionsData + 1 ] = {
        type = "checkbox",
        name = ITTDB:parse( "SETTINGS_CHAT" ),
        getFunc = function()
            return db.settings[ worldName ].notifications.chat
        end,
        setFunc = function( value )
            db.settings[ worldName ].notifications.chat = value
        end,
        default = defaults.settings[ worldName ].notifications.chat
    }

    optionsData[ #optionsData + 1 ] = {
        type = "checkbox",
        name = ITTDB:parse( "SETTINGS_SCREEN" ),
        getFunc = function()
            if ITT_DonationBotSettingsLogo and _desc then
                makeITTDescription()
                local _desc = true
            end

            return db.settings[ worldName ].notifications.screen
        end,
        setFunc = function( value )
            db.settings[ worldName ].notifications.screen = value
        end,
        default = defaults.settings[ worldName ].notifications.screen
    }

    local function ITT_LottoGenerate()
        local guildId = GetGuildId( guildLotto )
        local nameList = ""
        local amountList = ""
        local nameList2 = ""
        local amountList2 = ""
        local rowCount = 0

        if not ITTDB:IsGuildEnabled( guildId ) then
            return false
        end

        for i = 1, GetNumGuildMembers( guildId ) do
            local displayName = GetGuildMemberInfo( guildId, i )
            local startTime = 0
            local endTime = 0

            for reportIndex = 1, #ITTDB.reportQueries do
                if ITTDB.reportQueries[ reportIndex ].name == db.settings[ worldName ].queryTimeframe then
                    startTime, endTime = ITTDB.reportQueries[ reportIndex ].range()
                end
            end
            if not PlainStringFind( string.lower( db.lottoBlacklist ), string.lower( displayName ) ) then
                local amount = ITTDB:QueryValues( guildId, displayName, startTime, endTime )

                amount = math.floor( amount / lottotTicketValue )

                if amount > 0 then
                    rowCount = rowCount + 1

                    if rowCount <= 250 then
                        nameList = nameList .. string.gsub( displayName, "@", "" ) .. "\n"
                        amountList = amountList .. tostring( amount ) .. "\n"
                    else
                        nameList2 = nameList2 .. string.gsub( displayName, "@", "" ) .. "\n"
                        amountList2 = amountList2 .. tostring( amount ) .. "\n"
                    end
                end
            end
        end

        ITT_LottoNameList.editbox:SetText( nameList )
        ITT_LottoAmountList.editbox:SetText( amountList )

        if rowCount > 250 then
            ITT_LottoNameList2.editbox:SetText( nameList2 )
            ITT_LottoAmountList2.editbox:SetText( amountList2 )
        end
    end

    local lottoOptions = {}

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "description",
        title = "",
        text = ITTDB:parse( "SETTINGS_LOTTO_DESC" )
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "dropdown",
        name = ITTDB:parse( "SETTINGS_LOTTO_SELECT" ),
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_GUILD" ),
        choices = getGuildNameTable(),
        choicesValues = getGuildIndexTable(),
        getFunc = function()
            return getGuildIndexTable()[1]
        end,
        setFunc = function( var )
            guildLotto = var
        end,

        width = "half",
        isExtraWide = true
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "editbox",
        name = ITTDB:parse( "SETTINGS_LOTTO_VALUE" ),
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_EXAMPLE" ),
        getFunc = function()
            return lottotTicketValue
        end,
        setFunc = function( text )
            lottotTicketValue = text
        end,
        width = "half", --or "half" (optional)
        isExtraWide = true
    }

    ITTDB.reportQueries = {
        {
            name = ITTDB:parse( "TIME_TODAY" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 0 ), GetTimeStamp()
            end
        },
        {
            name = ITTDB:parse( "TIME_YESTERDAY" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 1 ), ITTDB:GetTimestampOfDayStart( 0 )
            end
        },
        {
            name = ITTDB:parse( "TIME_2_DAYS" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 2 ), ITTDB:GetTimestampOfDayStart( 1 )
            end
        },
        {
            name = ITTDB:parse( "TIME_THIS_WEEK" ),
            range = function()
                return ITTDB:GetTraderWeekStart(), ITTDB:GetTraderWeekEnd()
            end
        },
        {
            name = ITTDB:parse( "TIME_LAST_WEEK" ),
            range = function()
                return ITTDB:GetTraderWeekStart() - SECONDS_IN_WEEK, ITTDB:GetTraderWeekStart()
            end
        },
        {
            name = ITTDB:parse( "TIME_PRIOR_WEEK" ),
            range = function()
                return ITTDB:GetTraderWeekStart() - (SECONDS_IN_WEEK * 2), ITTDB:GetTraderWeekStart() - SECONDS_IN_WEEK
            end
        },
        {
            name = ITTDB:parse( "TIME_7_DAYS" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 7 ), GetTimeStamp()
            end
        },
        {
            name = ITTDB:parse( "TIME_10_DAYS" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 10 ), GetTimeStamp()
            end
        },
        {
            name = ITTDB:parse( "TIME_14_DAYS" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 14 ), GetTimeStamp()
            end
        },
        {
            name = ITTDB:parse( "TIME_30_DAYS" ),
            range = function()
                return ITTDB:GetTimestampOfDayStart( 30 ), GetTimeStamp()
            end
        },
        {
            name = ITTDB:parse( "TIME_TOTAL" ),
            range = function()
                return 0, GetTimeStamp()
            end
        }
    }

    local function getReportNames()
        local values = {}

        for i = 1, #ITTDB.reportQueries do
            values[ #values + 1 ] = ITTDB.reportQueries[ i ][ "name" ]
        end

        return values
    end

    local _reportNames = getReportNames()

    ITTDB._test = _reportNames

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "dropdown",
        name = ITTDB:parse( "SETTINGS_LOTTO_TIMEFRAME" ),
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_TIMEFRAME_2" ),
        choices = _reportNames,
        getFunc = function()
            return db.settings[ worldName ].queryTimeframe
        end,
        setFunc = function( value )
            db.settings[ worldName ].queryTimeframe = value
        end,
        width = "half",
        isExtraWide = false
    }
    lottoOptions[ #lottoOptions + 1 ] = {

        type = "editbox",
        name = "Lotto blacklist",
        tooltip = "Blacklist names to be ignored in the list. Seperate each name with a comma",
        getFunc = function() return db.lottoBlacklist end,
        setFunc = function( text ) db.lottoBlacklist = text end,
        isMultiline = true, --boolean
        width = "full",     --or "half" (optional)
        isExtraWide = true,
        default = "",       --(optional)
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "button",
        name = ITTDB:parse( "SETTINGS_LOTTO_GENERATE" ),
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_GENERATE_COL" ),
        func = ITT_LottoGenerate,
        width = "full"
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "description",
        title = "",
        text = [[ ]]
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "editbox",
        name = ITTDB:parse( "SETTINGS_LOTTO_NAMES" ),
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_INFO_1" ),
        getFunc = function()
            return ITTDB:parse( "SETTINGS_LOTTO_INFO_5" )
        end,
        setFunc = function( text )
            print( text )
        end,
        isMultiline = true,
        width = "half",
        isExtraWide = true,
        reference = "ITT_LottoNameList"
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "editbox",
        name = ITTDB:parse( "SETTINGS_LOTTO_TICKETS" ),
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_INFO_2" ),
        getFunc = function()
            return ITTDB:parse( "SETTINGS_LOTTO_INFO_6" )
        end,
        setFunc = function( text )
            print( text )
        end,
        isMultiline = true,
        width = "half",
        isExtraWide = true,
        reference = "ITT_LottoAmountList"
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "editbox",
        name = "",
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_INFO_3" ),
        getFunc = function()
            return ITTDB:parse( "SETTINGS_LOTTO_INFO_5" )
        end,
        setFunc = function( text )
            print( text )
        end,
        isMultiline = true,
        width = "half",
        isExtraWide = true,
        reference = "ITT_LottoNameList2"
    }

    lottoOptions[ #lottoOptions + 1 ] = {
        type = "editbox",
        name = "",
        tooltip = ITTDB:parse( "SETTINGS_LOTTO_INFO_4" ),
        getFunc = function()
            return ITTDB:parse( "SETTINGS_LOTTO_INFO_6" )
        end,
        setFunc = function( text )
            print( text )
        end,
        isMultiline = true,
        width = "half",
        isExtraWide = true,
        reference = "ITT_LottoAmountList2"
    }
    optionsData[ #optionsData + 1 ] = {
        type = "submenu",
        name = ITTDB:parse( "SETTINGS_LOTTO_NAME" ),
        -- tooltip = "$$$", --(optional)
        controls = lottoOptions
    }
    local ITTLibHistoireOptions = {}
    optionsData[ #optionsData + 1 ] = {
        type = "submenu",
        name = ITTDB:parse( "LH_OPTIONS" ),
        controls = ITTLibHistoireOptions
    }
    ITTLibHistoireOptions[ #ITTLibHistoireOptions + 1 ] = {
        type = "header",
        name = ITTDB:parse( "LH_OPTION2_DESC" ),
        width = "full"
    }
    ITTLibHistoireOptions[ #ITTLibHistoireOptions + 1 ] = {
        type = "description",
        text = ITTDB:parse( "LH_OPTION2_WARN" ),
        width = "half"
    }
    ITTLibHistoireOptions[ #ITTLibHistoireOptions + 1 ] = {
        type = "button",
        name = "Scan",
        func = function()
            return ITTDB:SetupFullScan()
        end,
        width = "half", --or "full" (optional)
        warning = ITTDB:parse( "LH_OPTION2_ENTRY" ),
        isDangerous = true
    }
    local ITTImportOptions = {}

    optionsData[ #optionsData + 1 ] = {
        type = "submenu",
        name = ITTDB:parse( "TRANSFER_OPTIONS" ),
        controls = ITTImportOptions,
        reference = "ITTImportMenu"
    }

    optionsData[ #optionsData + 1 ] = {
        type = "description",
        title = "",
        text = [[ ]]
    }

    optionsData[ #optionsData + 1 ] = {
        type = "texture",
        image = "ITTDB/itt-logo.dds",
        imageWidth = "192",
        imageHeight = "192",
        reference = "ITT_DonationBotSettingsLogo"
    }
    ITTImportOptions[ #ITTImportOptions + 1 ] = {
        type = "header",
        name = ITTDB:parse( "TRANSFER_TITLE" ),
        width = "full"
    }
    ITTImportOptions[ #ITTImportOptions + 1 ] = {
        type = "description",
        text = ITTDB:parse( "TRANSFER_DESC" ),
        width = "half"
    }
    ITTImportOptions[ #ITTImportOptions + 1 ] = {
        type = "button",
        name = "Import",
        tooltip = ITTDB:parse( "TRANSFER_WARN" ),
        func = function()
            return ITTDB:TransferData(), ITTImportMenu:SetHidden( true )
        end,
        width = "half", --or "full" (optional)
        warning = ITTDB:parse( "TRANSFER_WARN_2" ),
        isDangerous = true
    }
    local _desc = true

    local function makeITTDescription()
        local ITTDTitle = WINDOW_MANAGER:CreateControl( "ITTDBSettingsLogoTitle", ITT_DonationBotSettingsLogo, CT_LABEL )
        ITTDTitle:SetFont( "$(BOLD_FONT)|$(KB_18)|soft-shadow-thin" )
        ITTDTitle:SetText( "|Cfcba03INDEPENDENT TRADING TEAM" )
        ITTDTitle:SetDimensions( 240, 31 )
        ITTDTitle:SetHorizontalAlignment( 1 )
        ITTDTitle:SetAnchor( TOP, ITT_DonationBotSettingsLogo, BOTTOM, 0, 40 )

        local ITTDLabel = WINDOW_MANAGER:CreateControl( "ITTDBSettingsLogoTitleServer", ITTDBSettingsLogoTitle, CT_LABEL )
        ITTDLabel:SetFont( "$(MEDIUM_FONT)|$(KB_16)|soft-shadow-thick" )
        ITTDLabel:SetText( "|C646464PC EU" )
        ITTDLabel:SetDimensions( 240, 21 )
        ITTDLabel:SetHorizontalAlignment( 1 )
        ITTDLabel:SetAnchor( TOP, ITTDBSettingsLogoTitle, BOTTOM, 0, -5 )

        ITT_HideMePls:SetHidden( true )

        if db.records == nil then
            ITTImportMenu:SetHidden( true )
        end
    end

    optionsData[ #optionsData + 1 ] = {
        type = "checkbox",
        name = "HideMePls",
        getFunc = function()
            if ITT_DonationBotSettingsLogo ~= nil and _desc then
                makeITTDescription()
                _desc = false
            end

            return false
        end,
        setFunc = function( value )
            return false
        end,
        default = false,
        disabled = true,
        reference = "ITT_HideMePls"
    }

    return panelData, optionsData
end

ITTDB.makeSettings = makeSettings