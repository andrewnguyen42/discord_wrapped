# must create a discord bot that has read history priviliges in your channel
# details here https://github.com/Tyrrrz/DiscordChatExporter/wiki/Obtaining-Token-and-Channel-IDs#how-to-get-a-bot-token

# must install DiscordChatExporter
# https://github.com/Tyrrrz/DiscordChatExporter/wiki

# you're gonna have to copy and paste channel_ids following instructions here
#https://github.com/Tyrrrz/DiscordChatExporter/wiki/Obtaining-Token-and-Channel-IDs#how-to-get-a-server-id-or-a-server-channel-id
dotnet DiscordChatExporter.Cli.dll export -t "bot.key" -c  channel_id_list -b -f csv
