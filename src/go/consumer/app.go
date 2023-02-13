package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/dapr/go-sdk/service/common"
	daprd "github.com/dapr/go-sdk/service/http"
)

var sub = &common.Subscription{
	PubsubName: "rabbitmq-pubsub",
	Topic:      "techtalks",
	Route:      "/techtalks",
}

func main() {
	appPort := os.Getenv("APP_PORT")
	if appPort == "" {
		appPort = "8081"
	}

	// Create the new server on appPort and add a topic listener
	s := daprd.NewService(":" + appPort)
	err := s.AddTopicEventHandler(sub, eventHandler)
	if err != nil {
		log.Fatalf("error adding topic subscription: %v", err)
	}

	// Start the server
	err = s.Start()
	if err != nil && err != http.ErrServerClosed {
		log.Fatalf("error listenning: %v", err)
	}
}

func eventHandler(ctx context.Context, e *common.TopicEvent) (retry bool, err error) {
	// introduce delay of 250 milliseconds
	time.Sleep(250 * time.Millisecond)

	var techTalk TechTalk

	// fmt.Println("Subscriber received:", e.RawData)
	fmt.Println("Subscriber received:", e.Data)

	jsonData := e.Data.(map[string]interface{})
	fmt.Println("jsonData: ", jsonData)

	if data, err := json.Marshal(jsonData); err == nil {
		json.Unmarshal(data, &techTalk)
	}

	fmt.Println("TechTalk Id: ", techTalk.Id)
	fmt.Println("TechTalk name: ", techTalk.TechTalkName)
	fmt.Println("TechTalk Category : ", techTalk.CategoryId)
	fmt.Println("TechTalk Level: ", techTalk.LevelId)

	return false, nil
}

type TechTalk struct {
	Id           int    `json:"id"`
	TechTalkName string `json:"TechTalkName"`
	CategoryId   int    `json:"CategoryId"`
	LevelId      int    `json:"LevelId"`
}
