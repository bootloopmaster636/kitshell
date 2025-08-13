use chrono::{DateTime, Local};
use std::collections::HashMap;
use zbus::{
    blocking::{connection, Connection},
    interface,
    zvariant::Value,
    Error,
};

use crate::frb_generated::StreamSink;

/// D-Bus interface for desktop notifications.
const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";

/// D-Bus path for desktop notifications.
const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

pub struct NotificationDbus {
    conn: Connection,
    pub service: NotificationService,
}

#[derive(Clone)]
pub struct NotificationData {
    pub id: u32,
    pub app_name: String,
    pub replaces_id: u32,
    pub app_icon: String,
    pub summary: String,
    pub body: String,
    pub actions: Vec<String>,
    pub expire_timeout: i32,
    pub hints: HashMap<String, String>, // Simplified to avoid lifetime issues
    pub added_at: DateTime<Local>,
}

#[derive(Clone)]
pub struct NotificationService {
    pub sink: StreamSink<NotificationData>,
}

#[interface(
    name = "org.freedesktop.Notifications",
    proxy(
        gen_blocking = false,
        default_path = "/org/freedesktop/Notifications",
        default_service = "org.freedesktop.Notifications"
    )
)]
impl NotificationService {
    /// Handle the Notify method call
    async fn notify(
        &self,
        app_name: &str,
        replaces_id: u32,
        app_icon: &str,
        summary: &str,
        body: &str,
        actions: Vec<String>,
        hints: HashMap<String, Value<'_>>,
        expire_timeout: i32,
    ) -> u32 {
        let mut id: u32 = rand::random();
        while id == 0 {
            id = rand::random();
        }

        // Send notification data through the sink
        let notification_data = NotificationData {
            id: if replaces_id == 0 { id } else { replaces_id },
            app_name: app_name.to_string(),
            replaces_id,
            app_icon: app_icon.to_string(),
            summary: summary.to_string(),
            body: body.to_string(),
            actions,
            expire_timeout,
            hints: hints // TODO: add better handling of hints
                .into_iter()
                .map(|(k, v)| {
                    // Convert Value to String representation for simplicity
                    let value_str = format!("{:?}", v);
                    (k, value_str)
                })
                .collect(),
            added_at: Local::now(),
        };

        if let Err(e) = self.sink.add(notification_data) {
            eprintln!("Failed to send notification data: {}", e);
        }

        // Return ID
        // See: https://specifications.freedesktop.org/notification-spec/latest/protocol.html#command-notify
        if replaces_id == 0 {
            id
        } else {
            replaces_id
        }
    }

    /// Get capabilities of the notification daemon
    async fn get_capabilities(&self) -> Vec<String> {
        vec![
            "actions".to_string(),
            "body".to_string(),
            "body-markup".to_string(),
            "body-hyperlinks".to_string(),
            "body-images".to_string(),
            "icon-static".to_string(),
        ]
    }

    /// Get server information
    async fn get_server_information(&self) -> (String, String, String, String) {
        (
            "Kitshell".to_string(),          // name
            "bootloopmaster636".to_string(), // vendor
            "1.0.0".to_string(),             // version
            "1.3".to_string(),               // spec_version
        )
    }

    // Invoke actions
    // #[zbus(signal)]
    // async fn action_invoked(id: u32, action_key: String) -> Result<(), Error> {}
}

pub async fn watch_notification_bus(
    sink: StreamSink<NotificationData>,
) -> Result<NotificationDbus, Error> {
    let notif_service = NotificationService { sink };
    let _conn = connection::Builder::session()?
        .name(NOTIFICATION_INTERFACE)?
        .serve_at(NOTIFICATION_PATH, notif_service.clone())?
        .build();

    Ok(NotificationDbus {
        conn: _conn.unwrap(),
        service: notif_service,
    })
}

pub async fn invoke_notif_action(id: u32, action_key: String) {}
