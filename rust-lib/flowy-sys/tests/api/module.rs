use crate::helper::*;
use flowy_sys::prelude::*;

pub async fn hello() -> String { "say hello".to_string() }

#[tokio::test]
async fn test_init() {
    setup_env();
    let event = "1";
    init_dispatch(|| vec![Module::new().event(event, hello)]);

    let request = DispatchRequest::new(event, Payload::None);
    let resp = async_send(request).await;
    dbg!(&resp);
}