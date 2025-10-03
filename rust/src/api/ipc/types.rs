use serde::{Deserialize, Serialize};

pub const KITSHELL_IPC_SERVER_SPEC_VER: u32 = 2025_10_02;

#[derive(Debug, Serialize, Deserialize)]
pub struct IpcMessage {
    /// IPC content
    pub content: IpcContent,

    /// Kitshell IPC specification version
    pub version: u32,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct IpcContent {
    pub opt1: String,
    pub opt2: Option<String>,
    pub opt3: Option<String>,
    pub opt4: Option<String>,
    pub opt5: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct IpcReply {
    pub received_successfully: bool,
    pub server_spec_version: u32,
}
