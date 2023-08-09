ITTsDonationBot.i18n = {
	ITTDB_NAME = "ITT's Donation Bot",
	ITTDB_HEADER = "Donations",
	ITTDB_HEADER_GUILDS = "Guilds",
	ITTDB_HEADER_NOTIFY = "Notifications",
	-- time
	ITTDB_TIME_TODAY = "Today",
	ITTDB_TIME_YESTERDAY = "Yesterday",
	ITTDB_TIME_2_DAYS = "Two days ago",
	ITTDB_TIME_THIS_WEEK = "This Week",
	ITTDB_TIME_LAST_WEEK = "Last Week",
	ITTDB_TIME_PRIOR_WEEK = "Prior Week",
	ITTDB_TIME_7_DAYS = "Last 7 Days",
	ITTDB_TIME_10_DAYS = "Last 10 Days",
	ITTDB_TIME_14_DAYS = "Last 14 Days",
	ITTDB_TIME_30_DAYS = "Last 30 Days",
	ITTDB_TIME_TOTAL = "Total",
	-- settings
	ITTDB_SETTINGS_DESC = [[If you have the correct permissions with a guild, it will be available below as a toggle option to scan. If a guild option is disabled, you do not have the correct "View Guild Bank Gold" permission]],
	ITTDB_SETTINGS_SCAN_ERROR = "You do not have the correct permissions to scan this guild",
	ITTDB_SETTINGS_SCAN_PROMPT = "Turn scanning on or off for ${guild}",
	ITTDB_SETTINGS_SCAN_INFO = [[Whilst we try to handle things automatically, stuff can slip through. If the above guild list is not correct due to a recent change, you may need to run the /reloadui command]],
	ITTDB_SETTINGS_NOTIFY = [[Notifications only apply for anything under the last 24 hours]],
	ITTDB_SETTINGS_CHAT = "In-Chat Notifications",
	ITTDB_SETTINGS_SCREEN = "Screen Notifications",
	ITTDB_SETTINGS_LOTTO_NAME = "Lotto List Generator",
	ITTDB_SETTINGS_LOTTO_DESC = [[Click to generate the columns of member names and ticket counts for your lotto spreadsheet. You can set the value of a ticket below, default is 1k = 1 ticket. The results are based on donations within the current "This Week", which currently is the in-game trading week.]],
	ITTDB_SETTINGS_LOTTO_SELECT = "Select Guild",
	ITTDB_SETTINGS_LOTTO_GUILD = "Guild members for lotto",
	ITTDB_SETTINGS_LOTTO_VALUE = "Lotto ticket value",
	ITTDB_SETTINGS_LOTTO_EXAMPLE = "Example 1000 per ticket",
	ITTDB_SETTINGS_LOTTO_TIMEFRAME = "Select Timeframe",
	ITTDB_SETTINGS_LOTTO_TIMEFRAME_2 = "Timeframe for lotto",
	ITTDB_SETTINGS_LOTTO_GENERATE = "Generate",
	ITTDB_SETTINGS_LOTTO_GENERATE_COL = "Click to generate the spreadsheet columns",
	ITTDB_SETTINGS_LOTTO_INFO_1 = "Values for the name column, rows 1 - 250",
	ITTDB_SETTINGS_LOTTO_INFO_2 = "Values for the ticket column, rows 1 - 250",
	ITTDB_SETTINGS_LOTTO_INFO_3 = "Values for the name column, rows 251 - 500",
	ITTDB_SETTINGS_LOTTO_INFO_4 = "Values for the ticket column, rows 251 - 500",
	ITTDB_SETTINGS_LOTTO_NAMES = "Name Values",
	ITTDB_SETTINGS_LOTTO_TICKETS = "Ticket Values",
	ITTDB_SETTINGS_LOTTO_INFO_5 = "Name column generated here",
	ITTDB_SETTINGS_LOTTO_INFO_6 = "Amount column generated here",
	ITTDB_LH_OPTIONS = "LibHistoire Options",
	ITTDB_LH_OPTION1_DESC = "Missing Entries",
	ITTDB_LH_OPTION1_ENTRY = "This will scan LibHistoire for any missing entries",
	ITTDB_LH_OPTION2_DESC = "Full Scan",
	ITTDB_LH_OPTION2_ENTRY = "This can take time, depending on how much data you are missing and how much data you have stored in your LibHistoire.",
	ITTDB_LH_OPTION2_WARN = "This will scan the entirety of LibHistoire's data (might take a while)",
	ITTDB_TRANSFER_OPTIONS = "Import Options",
	ITTDB_TRANSFER_TITLE = "Transfer old records",
	ITTDB_TRANSFER_DESC = "|cff0000WARNING BACK UP YOUR SAVED VARIABLES BEFORE PRESSING THIS BUTTON",
	ITTDB_TRANSFER_WARN = "Have you backed up your Saved Variables?",
	ITTDB_TRANSFER_REMINDER = "|cffffffWe have detected that you have saved data before the update! Don't worry, your data is still there, please head to our Addon Menu and click on <<Import Options>> and follow the instructions there. Thank you!",
	-- Notifications
	ITTDB_NOTIFICATION = "${user} has donated ${amount} to ${guild} ${time}",
	-- Null
	ITTDB_NONE = "None",
	-- commands
	ITTDB_CMD_NO_GUILDS = "Could not find guild, please enter a number between 1 and 5",
	ITTDB_CMD_GENERATED = "Tooltips regenerated"
}