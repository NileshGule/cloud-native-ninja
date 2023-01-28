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


@RestController
public class TechTalksConsumerController {
    private static final Logger log = LoggerFactory.getLogger(TechTalksConsumerController.class);

    @Value("${RABBITMQ_TOPIC}")
    private String topicName;

    @Value("${PUBSUB_NAME}")
    private String pubsubName;


    @Topic(pubsubName="rabbitmq-pubsub", name="techtalks")
//@Topic(pubsubName="${PUBSUB_NAME}", name="${RABBITMQ_TOPIC}")
    @PostMapping(path = "/process", consumes = MediaType.ALL_VALUE)
    public Mono<ResponseEntity> consumeMessage(@RequestBody(required = false) CloudEvent<TechTalk> cloudEvent) {

        return Mono.fromSupplier(() -> {
            try {
//                log.info("Subscriber received: " + cloudEvent.getData().getId());
                TechTalk techtalk = cloudEvent.getData();
                logTechTalkDetails(techtalk);
                return ResponseEntity.ok("SUCCESS");
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
//        log.info("Subscriber received: " + cloudEvent.getData().getOrderId());
//        return ResponseEntity.ok("Success");

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
