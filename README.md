# NFI Tags Auto Updater

Inspired by https://github.com/shanejones/nfi-auto-update

Simple Bash script to check for [NostalgiaForInfinityNext](https://github.com/iterativv/NostalgiaForInfinity) newly added tags and update it for usage with [Freqtrade](https://github.com/freqtrade/freqtrade) bot.

## Installation

Clone the repo:
```
git clone https://github.com/krsh-off/nfi-tags-auto-update.git
```

Open `update.sh` file and tweak some variables:
- `ROOT_PATH` - path to the directory where `NostalgiaForInfinityNext` and `freqtrade` directories are places
- `TG_TOKEN` - Telegram token you've got for the bot
- `TG_CHAT_ID` - Telegram chat ID with your bot
- `TG_FT_BOT_ID` - Telegram ID of your Freqtrade bot, the one that ends in `bot`

Make the file executable:
```
chmod +x update.sh
```

Setup a Cron job to execute the script periodically.

Log into your server and type `crontab -e`. Next you should be editing the cron file, add in the following line at the bottom of the file.

```
*/30 * * * * /bin/bash -c "nfi-tags-auto-update/update.sh"
```

Once that is saved, the updater will check for new git updates every 30 mins and notify you via Telegram if there was anything new so you can restart it.
