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
public class TechTalksConsumerController {
    private static final Logger log = LoggerFactory.getLogger(TechTalksConsumerController.class);

    @Value("${RABBITMQ_TOPIC}")
    private String topicName;

    @Value("${PUBSUB_NAME}")
    private String pubsubName;

    @PostMapping(path = "/process", consumes = MediaType.ALL_VALUE)
    @Topic(pubsubName=pubsubName, name=topicName)
    public Mono<ResponseEntity> consumeMessage(@RequestBody(required = false) CloudEvent<Order> cloudEvent) {
        return Mono.fromSupplier(() -> {
        try {
            logger.info("Subscriber received: " + cloudEvent.getData().getOrderId());
            return ResponseEntity.ok("SUCCESS");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    });
}

 
}

@Getter
@Setter
class Order {
    private int orderId;
}
