# BuddyBot (t.me/like_buddy_bot)

This bot is designed to provide helpful responses based on user input. You can chat with the bot by sending text messages. The bot will use OpenAI's powerful language model to generate responses.

## Getting Started

## Prerequisites

Before you start, make sure you have the following environment variables set:

- `TELE_TOKEN`: Telegram bot token (required)
- `OPEN_AI_TOKEN`: OpenAI GPT-3.5 Turbo API token (required)

```
export TELE_TOKEN=your_telegram_bot_token
export OPEN_AI_TOKEN=your_openai_token
```

## Installation

- Clone the repository:

```
git clone https://github.com/yourusername/buddybot.git
cd buddybot
```

- Build the binary:

```
go build -o buddybot
```

## Usage

- Start the bot:

```
./buddybot start
```

- Interact with the bot:

Send a text message to the bot, and it will respond with a generated message.

![BuddyBot work example](buddyBot.png)

# Gitleaks in pre-commit hook

To use `gitleak` in pre-commit hook, simply create (if not exist) file `pre-commit` in `.git/hooks/` folder and place this code in it

```
#!/bin/bash

# Check if pre-commit hook is enabled
enabled=$(git config --get hooks.gitleaks.enable)
if [ "$enabled" != "true" ]
then
    exit 0
fi

# Get the repository root
repo_path=$(git rev-parse --show-toplevel)

# Install Gitleaks if not installed
if [ ! -f "$repo_path/gitleaks" ]
then
    VERSION=8.18.1
    UNAMES="$(uname -s)"
    case "${UNAMES}" in
        Linux*)     OS=linux;;
        Darwin*)    OS=darwin;;
        Windows*)   OS=windows;;
    esac

    UNAMEM="$(uname -m)"
    case "${UNAMEM}" in
        arm64*)     ARCH=arm64;;
        x86_64*)    ARCH=x64;;
    esac

    SHASUM="$(which shasum 2> /dev/null || true)"

    curl https://github.com/zricethezav/gitleaks/releases/download/v${VERSION}/gitleaks_${VERSION}_${OS}_${ARCH}.tar.gz -L -O

    if [ -z "$SHASUM" ]
    then
        echo "shasum not found, skipping integrity check"
    else
        shasum -c checksums.txt -a 256 --ignore-missing || ( echo "Checksum verification of gitleaks failed" ; exit -1 )
    fi

    tar -xzf gitleaks_${VERSION}_${OS}_${ARCH}.tar.gz gitleaks
    rm gitleaks_${VERSION}_${OS}_${ARCH}.tar.gz
fi

# Run Gitleaks
echo "Running gitleaks..."
leaks_output=$("./gitleaks detect" 2>&1)

# Check for secrets and reject the commit if found
if [ $? -ne 0 ]
then
    echo "Gitleaks found secrets. Commit rejected."
    echo "Gitleaks output:"
    ./gitleaks detect -v
    exit 1
fi

exit 0
```

and don't forget to execute `git config hooks.gitleaks.enable true`.