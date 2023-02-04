package com.nileshgule.techtalksconsumer.controller;

import io.dapr.Topic;
import io.dapr.client.domain.CloudEvent;
import lombok.Getter;
import lombok.Setter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Value;
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
        log.info("TechTalk ID : " + techTalk.getId());
        log.info("TechTalk Name : " + techTalk.getTechTalkName());
        log.info("Category ID : " + techTalk.getCategoryId());
        log.info("Level ID : " + techTalk.getLevelId());
        log.info("---");
    }
}

@Getter
@Setter
class TechTalk {
    private int Id;
    private String techTalkName;
    private int categoryId;
    private int levelId;
}
