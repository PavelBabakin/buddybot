/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	openai "github.com/sashabaranov/go-openai"
	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
)

var (
	// TeleToken bot
	// TeleToken   = os.Getenv("TELE_TOKEN")
	TeleToken   = "6859285014:AAEehgd1_ANSFF6vnWS1DUsa5DC7WN4fSj"
	OpenAIToken = os.Getenv("OPEN_AI_TOKEN")
)

// buddyBotCmd represents the buddybot command
var buddyBotCmd = &cobra.Command{
	Use:   "start",
	Short: "Starts the BuddyBot Telegram bot",
	Long: `buddybot is a Telegram bot powered by OpenAI's GPT-3.5 Turbo.

	This bot is designed to provide helpful responses based on user input. You can chat with the bot by sending text messages. The bot will use OpenAI's powerful language model to generate responses.
	
	Example:
	  Start the bot:
	  $ buddybot start
	
	  Interact with the bot:
	  - Send a text message to the bot, and it will respond with a generated message.
	
	Environment Variables:
	  - TELE_TOKEN: Telegram bot token (required)
	  - OPEN_AI_TOKEN: OpenAI GPT-3.5 Turbo API token (required)
	
	Note: Make sure to set the TELE_TOKEN and OPEN_AI_TOKEN environment variables before starting the bot.
	`,
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("buddybot %s started", appVersion)

		buddybot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		client, req := initOpenAIAPI()

		buddybot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Print(m.Message().Payload, m.Text())
			text := m.Text()

			respText := callOpenAIAPI(client, req, text)

			err = m.Send(respText)

			return err
		})

		buddybot.Start()
	},
}

func initOpenAIAPI() (*openai.Client, openai.ChatCompletionRequest) {
	client := openai.NewClient(OpenAIToken)

	req := openai.ChatCompletionRequest{
		Model: openai.GPT3Dot5Turbo,
		Messages: []openai.ChatCompletionMessage{
			{
				Role:    openai.ChatMessageRoleSystem,
				Content: "You are a helpful telegram bot, with name BuddyBot.",
			},
		},
	}

	return client, req
}

func callOpenAIAPI(client *openai.Client, req openai.ChatCompletionRequest, text string) string {
	req.Messages = append(req.Messages, openai.ChatCompletionMessage{
		Role:    openai.ChatMessageRoleUser,
		Content: text,
	})

	resp, err := client.CreateChatCompletion(context.Background(), req)

	if err != nil {
		fmt.Printf("Error: %v\n", err)
	}

	return resp.Choices[0].Message.Content
}

func init() {
	rootCmd.AddCommand(buddyBotCmd)
}
