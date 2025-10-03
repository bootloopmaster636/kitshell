use crate::{
    api::ipc::types::{IpcContent, IpcMessage, IpcReply, KITSHELL_IPC_SERVER_SPEC_VER},
    frb_generated::StreamSink,
};
use anyhow::{bail, Error};
use linux_ipc::IpcChannel;

pub fn watch_kitshell_socket(sink: StreamSink<IpcContent>) -> Result<(), Error> {
    let mut socket = match IpcChannel::new("/tmp/kitshell.sock") {
        Ok(val) => {
            println!("API | IPC: Socket created");
            val
        }
        Err(_) => bail!("API | IPC: Failed to create socket"),
    };

    loop {
        let (response, reply) = socket.receive::<IpcMessage, IpcReply>()?;

        let frontend_ok = match sink.add(response.content) {
            Ok(_) => true,
            Err(_) => false,
        };

        let send_msg = IpcReply {
            received_successfully: frontend_ok,
            server_spec_version: KITSHELL_IPC_SERVER_SPEC_VER,
        };

        reply(send_msg).expect("API | IPC: Failed to reply to client");
    }
}
