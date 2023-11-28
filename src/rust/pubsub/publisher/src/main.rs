use actix_web::middleware::Logger;
use actix_web::{web, App, HttpServer};
use actix_web::{HttpResponse, Responder};
use dapr::client::TonicClient;
use dapr::Client;

use serde::Deserialize;
use std::sync::{Arc, Mutex};
use std::{thread, time::Duration};

mod publisher;
const TECHTALKS_TOPIC_NAME: &str = "techtalks";
const PUBSUB_NAME: &str = "rabbitmq-pubsub";

#[derive(Deserialize)]
struct FormData {
    max_messages: String,
}

// This struct represents state
struct DaprState {
    client: Arc<Mutex<Client<TonicClient>>>,
}
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    std::env::set_var("RUST_LOG", "info");
    env_logger::init();
    // wait for the dapr grpc to be ready
    // Introduce delay so that dapr grpc port is assigned before app tries to connect
    thread::sleep(Duration::from_secs(2));

    // Get the Dapr port and create a connection
    let port: u16 = std::env::var("DAPR_GRPC_PORT").unwrap().parse().unwrap();
    let addr = format!("http://localhost:{}", port);

    // Create the client
    let client = dapr::Client::<dapr::client::TonicClient>::connect(addr)
        .await
        .unwrap();

    // Note: web::Data created _outside_ HttpServer::new closure
    let dapr_client = web::Data::new(DaprState {
        client: Arc::new(Mutex::new(client)),
    });
    HttpServer::new(move || {
        App::new()
            .app_data(dapr_client.clone())
            .route("/generate/", web::post().to(publish_messages))
            .wrap(Logger::default())
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}

async fn publish_messages(
    dapr_client: web::Data<DaprState>,
    form: web::Form<FormData>,
) -> impl Responder {
    println!("query: {:?}", form.max_messages);
    let max_messages: u32 = form.max_messages.parse().unwrap();
    if publisher::publish_message(max_messages, dapr_client.client.clone())
        .await
        .is_err()
    {
        return HttpResponse::BadRequest().body("publish failed");
    }
    HttpResponse::Ok().body("Publish complete")
}
