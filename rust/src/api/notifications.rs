use anyhow::Error;
use chrono::{DateTime, Local};
use std::{collections::HashMap, future::pending};
use zbus::{blocking::connection, interface, zvariant::Value};

use crate::frb_generated::StreamSink;

/// D-Bus interface for desktop notifications.
const NOTIFICATION_INTERFACE: &str = "org.freedesktop.Notifications";

/// D-Bus path for desktop notifications.
const NOTIFICATION_PATH: &str = "/org/freedesktop/Notifications";

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

struct NotificationService {
    sink: StreamSink<NotificationData>,
}

#[interface(name = "org.freedesktop.Notifications")]
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
        let id = rand::random();

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
            "body".to_string(),
            "body-markup".to_string(),
            "body-hyperlinks".to_string(),
            "actions".to_string(),
            "persistence".to_string(),
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
}

pub async fn watch_notification_bus(sink: StreamSink<NotificationData>) -> Result<(), Error> {
    let notif_service = NotificationService { sink };
    let _conn = connection::Builder::session()?
        .name(NOTIFICATION_INTERFACE)?
        .serve_at(NOTIFICATION_PATH, notif_service)?
        .build();

    pending::<()>().await;

    Ok(())
}

pub async fn dismiss_notification(id: u32) -> Result<(), Error> {
    // Connect to the D-Bus session
    let connection = zbus::Connection::session().await?;

    connection
        .call_method(
            Some(NOTIFICATION_INTERFACE),
            NOTIFICATION_PATH,
            Some(NOTIFICATION_INTERFACE),
            "NotificationClosed",
            &(id, 2), // 2 is notification dismissed by user
        )
        .await?;

    Ok(())
}
