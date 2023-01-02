package com.nileshgule.techtalksproducer.controllers;

import io.dapr.client.DaprClient;
import io.dapr.client.DaprClientBuilder;
import io.dapr.client.domain.Metadata;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

import java.util.stream.IntStream;

import static java.util.Collections.singletonMap;


@RestController
@RequestMapping("/api/TechTalks/")
public class TechTalksProducerController {
    private static final Logger log = LoggerFactory.getLogger(TechTalksProducerController.class);

    @Value("${RABBITMQ_TOPIC}")
    private String topicName;

    @Value("${PUBSUB_NAME}")
    private String pubsubName;


    //Time-to-live for messages published.
    private static final String MESSAGE_TTL_IN_SECONDS = "1000";

    @GetMapping (name = "/generate")
    public ResponseEntity<String> produceMessages(@RequestParam Integer numberOfMessages) {
        try (DaprClient client = new DaprClientBuilder().build()){
            IntStream.range(0, numberOfMessages)
                    .forEach(i -> {
                        String id = UUID.randomUUID().toString();
                        String techTalkName = "TechTalk " + i;
                        int categoryId = i % 3;
                        int levelId = i % 2;
                        Map<String, Object> message = Map.of(
                                "id", id,
                                "techTalkName", techTalkName,
                                "categoryId", categoryId,
                                "levelId", levelId
                        );

                log.info("Publishing message: " + message );
                client.publishEvent(pubsubName, topicName, message, singletonMap(Metadata.TTL_IN_SECONDS, MESSAGE_TTL_IN_SECONDS)).block();
            });
            client.close();
        } catch (Exception e) {
//            log.severe("Error while publishing messages: " + e.getMessage());
            log.error("Error while publishing messages: " + e.getMessage());
            return ResponseEntity.badRequest().body("Error while publishing messages: " + e.getMessage());
        }

        return ResponseEntity.ok().body("Successfully produced " + numberOfMessages + " messages to RabbitMQ");
    }
}
