use crate::frb_generated::StreamSink;
use anyhow::Result;
use chrono::{DateTime, Local};
use std::{thread::sleep, time::Duration};

const ONE_SECOND: Duration = Duration::from_secs(1);

pub fn time_stream(sink: StreamSink<DateTime<Local>>) -> Result<()> {
    loop {
        let now = Local::now();
        sink.add(now).expect("Failed to send time");
        sleep(ONE_SECOND);
    }
}
