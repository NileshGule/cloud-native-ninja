package com.nileshgule.techtalksconsumer.controller;

import io.dapr.Topic;
import io.dapr.client.domain.CloudEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;
import java.util.concurrent.TimeUnit;


@RestController
public class TechTalksConsumerController {
    private static final Logger log = LoggerFactory.getLogger(TechTalksConsumerController.class);

    @Topic(pubsubName="rabbitmq-pubsub", name="techtalks")
    @PostMapping(path = "/process", consumes = MediaType.ALL_VALUE)
    public Mono<ResponseEntity> consumeMessage(@RequestBody(required = false) CloudEvent<TechTalk> cloudEvent) {

        return Mono.fromSupplier(() -> {
            try {
                TimeUnit.MILLISECONDS.sleep(250);
                TechTalk techtalk = cloudEvent.getData();
                logTechTalkDetails(techtalk);
                return ResponseEntity.ok("SUCCESS");
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
    }

    private void logTechTalkDetails(TechTalk techTalk){
        log.info("---");
        log.info("TechTalk ID : " + techTalk.Id());
        log.info("TechTalk Name : " + techTalk.techTalkName());
        log.info("Category ID : " + techTalk.categoryId());
        log.info("Level ID : " + techTalk.levelId());
        log.info("---");
    }
}

record TechTalk(int Id, String techTalkName, int categoryId, int levelId) {}
