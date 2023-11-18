/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "buddyBot",
	Short: "Starts the BuddyBot Telegram bot",
	Long: `buddyBot is a Telegram bot powered by OpenAI's GPT-3.5 Turbo.

	This bot is designed to provide helpful responses based on user input. You can chat with the bot by sending text messages. The bot will use OpenAI's powerful language model to generate responses.
	
	Example:
	  Start the bot:
	  $ buddyBot start
	
	  Interact with the bot:
	  - Send a text message to the bot, and it will respond with a generated message.
	
	Environment Variables:
	  - TELE_TOKEN: Telegram bot token (required)
	  - OPEN_AI_TOKEN: OpenAI GPT-3.5 Turbo API token (required)
	
	Note: Make sure to set the TELE_TOKEN and OPEN_AI_TOKEN environment variables before starting the bot.
	`,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: func(cmd *cobra.Command, args []string) { },
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.

	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is $HOME/.buddyBot.yaml)")

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
