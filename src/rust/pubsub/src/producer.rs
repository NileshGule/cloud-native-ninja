use rand::prelude::*;
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, thread, time::Duration};

const TECHTALKS_TOPIC_NAME: &str = "techtalks";
const PUBSUB_NAME: &str = "rabbitmq-pubsub";

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

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut rng = rand::thread_rng();
    // TODO: Handle this issue in the sdk
    // Introduce delay so that dapr grpc port is assigned before app tries to connect
    thread::sleep(Duration::from_secs(2));

    // Get the Dapr port and create a connection
    let port: u16 = std::env::var("DAPR_GRPC_PORT")?.parse()?;
    let addr = format!("http://localhost:{}", port);

    // Create the client
    let mut client = dapr::Client::<dapr::client::TonicClient>::connect(addr).await?;

    // name of the pubsub component
    let pubsub_name = PUBSUB_NAME.to_string();

    // content type of the pubsub data
    let data_content_type = "application/json".to_string();

    // topic to publish message to
    let topic = TECHTALKS_TOPIC_NAME.to_string();

    for count in 0..10000 {
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
