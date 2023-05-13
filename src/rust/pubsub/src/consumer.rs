use serde::{Deserialize, Serialize};
use tonic::{transport::Server, Request, Response, Status};

use dapr::{
    appcallback::*,
    dapr::dapr::proto::runtime::v1::app_callback_server::{AppCallback, AppCallbackServer},
};

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
#[derive(Default)]
pub struct AppCallbackService {}

#[tonic::async_trait]
impl AppCallback for AppCallbackService {
    /// Invokes service method with InvokeRequest.
    async fn on_invoke(
        &self,
        _request: Request<InvokeRequest>,
    ) -> Result<Response<InvokeResponse>, Status> {
        println!("on_invoke called");
        Ok(Response::new(InvokeResponse::default()))
    }

    /// Lists all topics subscribed by this app.
    ///
    /// NOTE: Dapr runtime will call this method to get
    /// the list of topics the app wants to subscribe to.
    /// In this example, the app is subscribing to topic `techtalks`.
    async fn list_topic_subscriptions(
        &self,
        _request: tonic::Request<()>,
    ) -> Result<Response<ListTopicSubscriptionsResponse>, Status> {
        let topic = TECHTALKS_TOPIC_NAME.to_string();
        let pubsub_name = PUBSUB_NAME.to_string();
        println!("list subscriptions called");
        let list_subscriptions = ListTopicSubscriptionsResponse::topic(pubsub_name, topic);
        println!("subscriptions {:?}", list_subscriptions);
        Ok(Response::new(list_subscriptions))
    }

    /// Subscribes events from Pubsub.
    async fn on_topic_event(
        &self,
        request: Request<TopicEventRequest>,
    ) -> Result<Response<TopicEventResponse>, Status> {
        let r = request.into_inner();
        let data = &r.data;
        let data_content_type = &r.data_content_type;

        let message = String::from_utf8_lossy(&data);

        let x: TechTalks = serde_json::from_str(message.to_string().as_str()).unwrap();
        println!("Category ID: {}", x.category_id);
        println!("ID: {}", x.id);
        println!("Name: {}", x.techtalk_name);
        println!("Level ID: {}", x.level_id);
        println!("Content-Type: {}", &data_content_type);

        Ok(Response::new(TopicEventResponse::default()))
    }

    /// Lists all input bindings subscribed by this app.
    async fn list_input_bindings(
        &self,
        _request: Request<()>,
    ) -> Result<Response<ListInputBindingsResponse>, Status> {
        println!("list_input_bindings called");
        Ok(Response::new(ListInputBindingsResponse::default()))
    }

    /// Listens events from the input bindings.
    async fn on_binding_event(
        &self,
        _request: Request<BindingEventRequest>,
    ) -> Result<Response<BindingEventResponse>, Status> {
        println!("on_binding_event called");
        Ok(Response::new(BindingEventResponse::default()))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::]:50051".parse().unwrap();

    let callback_service = AppCallbackService::default();

    println!("app server server listening on: {}", addr);

    // Create a gRPC server with the callback_service.
    Server::builder()
        .add_service(AppCallbackServer::new(callback_service))
        .serve(addr)
        .await?;

    Ok(())
}
