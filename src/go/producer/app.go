package main

import (
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/bxcodec/faker/v4"
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

		// use faker to create fields related to the TechTalk struct
		techTalkID, _ := faker.RandomInt(1, numberOfTalks, 1)
		techTalkName := faker.Name()
		techTalkCategory, _ := faker.RandomInt(1, 4, 1)
		techTalkLevel, _ := faker.RandomInt(1, 3, 1)

		techTalk := TechTalk{Id: techTalkID[0], TechTalkName: techTalkName, CategoryId: techTalkCategory[0], LevelId: techTalkLevel[0]}

		if err := client.PublishEvent(ctx, pubsubComponentName, pubsubTopic, techTalk); err != nil {
			http.Error(w, fmt.Sprintf("error publishing message: %v", err), http.StatusInternalServerError)
			return
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
