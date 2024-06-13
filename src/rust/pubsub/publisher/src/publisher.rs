use std::{
    collections::HashMap,
    sync::{Arc, Mutex},
};

use dapr::Client;
use rand::Rng;
use serde::{Deserialize, Serialize};

use crate::{PUBSUB_NAME, TECHTALKS_TOPIC_NAME};

#[derive(Serialize, Deserialize, Clone, Debug)]
struct TechTalks {
    #[serde(rename = "id")]
    pub id: u32,
    #[serde(rename = "TechTalkName")]
    pub techtalk_name: String,
    #[serde(rename = "CatergoryId")]
    pub category_id: usize,
    #[serde(rename = "LevelId")]
    pub level_id: usize,
}

pub async fn publish_message(
    max_message: u32,
    client_arc: Arc<Mutex<Client<dapr::client::TonicClient>>>,
) -> Result<(), Box<dyn std::error::Error>> {
    let mut rng = rand::thread_rng();
    let mut client = client_arc.lock().unwrap();

    // name of the pubsub component
    let pubsub_name = PUBSUB_NAME.to_string();

    // content type of the pubsub data
    let data_content_type = "application/json".to_string();

    // topic to publish message to
    let topic = TECHTALKS_TOPIC_NAME.to_string();

    for count in 0..max_message {
        // message metadata
        let mut metadata = HashMap::<String, String>::new();
        metadata.insert("count".to_string(), count.to_string());

        // message
        //let message = format!("{} => hello from rust!", &count).into_bytes();
        let techtalk_message = TechTalks {
            category_id: rng.gen(),
            level_id: rng.gen(),
            id: count,
            techtalk_name: format!("Getting started with Rust - talk id {}", count),
        };

        let message = serde_json::to_string(&techtalk_message)
            .unwrap()
            .into_bytes();

        client
            .publish_event(
                &pubsub_name,
                &topic,
                &data_content_type,
                message,
                Some(metadata),
            )
            .await?;
    }
    Ok(())
}
