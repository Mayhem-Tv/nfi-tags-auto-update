#!/bin/bash

set -x

MODE="tags"
AUTO_RELOAD=true

TG_TOKEN="5232175834:AAFZ6eRMujdaEy_ZUfpJf2-QjWbxnv6ysig"
TG_CHAT_ID="493383140
TG_FT_BOT_ID="Kucoin-Bot"

ROOT_PATH="/home/franklin_leon_d"
NFI_DIR="${ROOT_PATH}/NostalgiaForInfinity"
FT_DIR="${ROOT_PATH}/ft_userdata/"

GIT_URL="https://github.com/iterativv/NostalgiaForInfinity"

# Go to NFI directory
cd $NFI_DIR

if [ "$MODE" == "tags" ]; then
        # Fetch latest tags
        git fetch --tags
    
        # Get tags names
        latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
        current_tag=$(git describe --tags)
    
        # Create a new branch with the latest tag name and copy the new version of the strategy
        if [ "$latest_tag" != "$current_tag" ]; then
    
                # Checkout to latest tag and update the NFI in Freqtrade folder
                git checkout tags/$latest_tag -b $latest_tag || git checkout $latest_tag 
    
                # Get tag to which the latest tag is pointing
                latest_tag_commit=$(git rev-list -n 1 tags/${latest_tag})
    
                if $AUTO_RELOAD; then
                        # Compose the main message send by the bot
                        message="NFI is updated to tag: *${latest_tag}*"
                        message+="%0A%0A"
                        message+="Config has been re-loaded, no actions are required."

                        # Do auto-reload
                        python3 "${FT_DIR}/scripts/rest_client.py" --config "$FT_DIR/user_data/config.json" reload_config
                else
                        # Compose the main message send by the bot
                        message="NFI is updated to tag: *${latest_tag}*"
                        message+="%0A%0A"
                        message+="Please [/reload_config](https://t.me/${TG_FT_BOT_ID}) to get it loaded."
                fi
    
                # Compose buttons for showing git changes and backtesting results
                keyboard="{\"inline_keyboard\":[[{\"text\":\"Changes\", \"url\":\"${GIT_URL}/compare/${current_tag}...${latest_tag}\"},{\"text\":\"Backtesting\", \"url\":\"${GIT_URL}/commit/${latest_tag_commit}\"}]]}"
    
                # Send the message
                curl -s --data "text=${message}" \
                        --data "reply_markup=${keyboard}" \
                        --data "chat_id=$TG_CHAT_ID" \
                        --data "parse_mode=markdown" \
                        "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
        fi
elif [ "$MODE" == "latest" ]; then
        # Get current commit
        current_commit=$(git rev-parse --short HEAD)

        # Pull latest changes
        git checkout main
        git pull origin main
    
        # Get latest commit
        latest_commit=$(git rev-parse --short HEAD)

        if [ "$latest_commit" != "$current_commit" ]; then
                if $AUTO_RELOAD; then
                        # Compose the main message send by the bot
                        message="NFI is updated to commit: *${latest_commit}*"
                        message+="%0A%0A"
                        message+="Config has been re-loaded, no actions are required."
        
                        # Do auto-reload
                        python3 "${FT_DIR}/scripts/rest_client.py" --config "$FT_DIR/user_data/config.json" reload_config
                else
                        # Compose the main message send by the bot
                        message="NFI is updated to commit: *${latest_commit}*"
                        message+="%0A%0A"
                        message+="Please [/reload_config](https://t.me/${TG_FT_BOT_ID}) to get it loaded."
                fi
        
                # Compose buttons for showing git changes and backtesting results
                keyboard="{\"inline_keyboard\":[[{\"text\":\"Changes\", \"url\":\"${GIT_URL}/commit/${latest_commit}\"}]]}"
        
                # Send the message
                curl -s --data "text=${message}" \
                        --data "reply_markup=${keyboard}" \
                        --data "chat_id=$TG_CHAT_ID" \
                        --data "parse_mode=markdown" \
                        "https://api.telegram.org/bot${TG_TOKEN}/sendMessage"
        fi

else
        echo "Supported modes: tags/latest"
fi
