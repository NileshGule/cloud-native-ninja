package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

	dapr "github.com/dapr/go-sdk/client"
	"github.com/gorilla/mux"
)

const (
	pubsubComponentName = "rabbitmq-pubsub"
	pubsubTopic         = "techtalks"
)

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/generate/{num}", produceMessages).Methods("GET")
	log.Fatal(http.ListenAndServe(":8080", router))
}

func produceMessages(w http.ResponseWriter, r *http.Request) {
	// get number of messages to produce from URL parameter
	log.Println("Received request to produce messages")

	vars := mux.Vars(r)
	talks := vars["num"]
	log.Println("Number of talks: ", talks)

	// numberOfTalks, err := strconv.Atoi(vars["num"])
	numberOfTalks, err := strconv.Atoi(talks)

	if err != nil {
		http.Error(w, "invalid number of messages", http.StatusBadRequest)
		return
	}

	// get rabbitMQ topic name from environment variable
	// topicName := os.Getenv("RABBITMQ_TOPIC")
	// if topicName == "" {
	// 	http.Error(w, "RABBITMQ_TOPIC environment variable not set", http.StatusInternalServerError)
	// 	return
	// }

	// create Dapr pubsub client
	client, err := dapr.NewClient()
	if err != nil {
		http.Error(w, fmt.Sprintf("error creating pubsub client: %v", err), http.StatusInternalServerError)
		return
	}

	// create context
	ctx := r.Context()

	// produce messages
	for i := 0; i < numberOfTalks; i++ {
		message := fmt.Sprintf("message %d", i)

		techTalk := TechTalk{Id: i, TechTalkName: message, CategoryId: 1, LevelId: 1}

		serializedTalk, err := json.Marshal(techTalk)

		if err != nil {
			http.Error(w, fmt.Sprintf("error serializing message: %v", err), http.StatusInternalServerError)
		} else {
			if err := client.PublishEvent(ctx, pubsubComponentName, pubsubTopic, serializedTalk); err != nil {
				http.Error(w, fmt.Sprintf("error publishing message: %v", err), http.StatusInternalServerError)
				return
			}
		}
	}

	fmt.Fprintf(w, "Successfully produced %d messages to RabbitMQ", numberOfTalks)
}

type TechTalk struct {
	Id           int    `json:"id"`
	TechTalkName string `json:"TechTalkName"`
	CategoryId   int    `json:"CategoryId"`
	LevelId      int    `json:"LevelId"`
}
