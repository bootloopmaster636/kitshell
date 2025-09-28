use anyhow::{bail, Error};
use mpris::{LoopStatus, PlaybackStatus, Player, PlayerFinder, ProgressTick};
use std::ops::Deref;
use std::thread::sleep;
use std::time::Duration as StdDuration;

use crate::frb_generated::StreamSink;

pub enum PlayerOperations {
    TogglePlayPause,
    NextTrack,
    PrevTrack,
    ToggleShuffle,

    /// Set loop status with status once, playlist, disable, then back to once
    SetLoop,
}

/// Struct copying the content of [`mpris::Metadata`]
///
/// Visit [mpris crate docs](https://docs.rs/mpris/2.0.1/mpris/struct.Metadata.html) for more information
/// and description regarding fields in this struct
#[derive(Clone)]
pub struct TrackMetadata {
    pub title: Option<String>,
    pub artists: Option<Vec<String>>,
    pub album: Option<String>,
    pub art_url: Option<String>,
    pub track_id: Option<String>,
}

/// Struct copying the content of [`mpris::Progress`]
///
/// Visit [mpris crate docs](https://docs.rs/mpris/2.0.1/mpris/struct.Progress.html) for more information
/// and description regarding fields in this struct
#[derive(Clone)]
pub struct TrackProgress {
    pub metadata: TrackMetadata,
    pub playback_status: PlaybackStatus,
    pub shuffle_enabled: bool,
    pub loop_status: LoopStatus,

    /// This is calculated progress from difference between [`mpris::Progress::position`]
    /// and [`mpris::Progress::length`]
    pub progress: Option<f64>,

    /// Info about player, inserted here just for easier access
    pub player: PlayerInfo,
}

/// Struct that contains info regarding Player application
#[derive(Clone)]
pub struct PlayerInfo {
    pub friendly_name: String,
    pub desktop_entry: Option<String>,
    pub can_be_controlled: bool,
    pub can_go_prev: bool,
    pub can_go_next: bool,
    pub can_play: bool,
    pub can_pause: bool,
    pub can_stop: bool,
}

pub async fn watch_media_player_events(
    sink: StreamSink<Option<TrackProgress>>,
) -> Result<(), Error> {
    println!("API | MPRIS: Watching media player events");
    let player = PlayerFinder::new();
    let player_finder = match player {
        Ok(player) => player,
        Err(_) => {
            bail!("API | MPRIS: Cannot connect to DBus!");
        }
    };

    loop {
        let active_player = match player_finder.find_active() {
            Ok(player) => player,
            Err(_) => {
                // No player found, we repeat this until we get an active player
                let _ = sink.add(None);
                sleep(StdDuration::from_secs(3));
                continue;
            }
        };
        println!("API | MPRIS: Found active player");

        let mut progress_tracker = active_player.track_progress(200).unwrap();
        let mut progress_state: Option<TrackProgress> = None;

        loop {
            let ProgressTick {
                progress,
                progress_changed,
                player_quit,
                track_list_changed,
                ..
            } = progress_tracker.tick();

            // Break the loop and return to searching active player
            // when this player exits
            if player_quit {
                break;
            }

            // When following changes occurs in progress, update metadata
            // Otherwise just update the progress position.
            //
            // * Playback status changed
            // * Metadata changed for the track
            // * Volume was decreased
            if progress_changed || track_list_changed || progress_state.is_none() {
                let metadata = progress.metadata();
                let metadata_struct = TrackMetadata {
                    title: match metadata.title() {
                        Some(val) => Some(String::from(val)),
                        None => None,
                    },
                    artists: match metadata.artists() {
                        Some(val) => Some(val.iter().map(|e| String::from(e.deref())).collect()),
                        None => None,
                    },
                    album: match metadata.album_name() {
                        Some(val) => Some(String::from(val)),
                        None => None,
                    },
                    art_url: match metadata.art_url() {
                        Some(val) => Some(String::from(val)),
                        None => None,
                    },
                    track_id: match metadata.track_id() {
                        Some(val) => Some(String::from(val)),
                        None => None,
                    },
                };
                let result = TrackProgress {
                    metadata: metadata_struct,
                    playback_status: progress.playback_status(),
                    shuffle_enabled: progress.shuffle(),
                    loop_status: progress.loop_status(),
                    player: get_player_info(&active_player).unwrap(),
                    progress: get_calculated_progress(&progress.position(), &progress.length()),
                };

                progress_state = Some(result);
            } else {
                let mut result = progress_state.unwrap();
                result.progress = get_calculated_progress(&progress.position(), &progress.length());
                progress_state = Some(result);
            }

            // Emit new state
            match &progress_state {
                Some(val) => {
                    let _ = sink.add(Some(val.clone()));
                }
                None => {}
            }
        }
    }
}

pub async fn dispatch_player_action(action: PlayerOperations) -> Result<(), Error> {
    let player = PlayerFinder::new();
    let player_finder = match player {
        Ok(player) => player,
        Err(_) => {
            bail!("API | MPRIS: Cannot connect to DBus!");
        }
    };

    let active_player = match player_finder.find_active() {
        Ok(player) => player,
        Err(_) => bail!("API | MPRIS: No active player detected"),
    };

    match action {
        PlayerOperations::TogglePlayPause => match active_player.play_pause() {
            Ok(_) => (),
            Err(_) => bail!("API | MPRIS: Cannot play/pause track (dbus error?)"),
        },
        PlayerOperations::NextTrack => match active_player.next() {
            Ok(_) => (),
            Err(_) => bail!("API | MPRIS: Cannot go to next track (dbus error?)"),
        },
        PlayerOperations::PrevTrack => match active_player.previous() {
            Ok(_) => (),
            Err(_) => bail!("API | MPRIS: Cannot go to previous track (dbus error?)"),
        },
        PlayerOperations::ToggleShuffle => {
            let shuffle_state = active_player.get_shuffle().ok();

            if shuffle_state.is_none() {
                ()
            }

            match active_player.set_shuffle(!shuffle_state.unwrap()) {
                Ok(_) => (),
                Err(_) => bail!("API | MPRIS: Cannot set track shuffle (dbus error?)"),
            }
        }
        PlayerOperations::SetLoop => {
            let loop_state = active_player.get_loop_status().ok();

            if loop_state.is_none() {
                ()
            }

            let operation = match loop_state.unwrap() {
                LoopStatus::None => LoopStatus::Track,
                LoopStatus::Track => LoopStatus::Playlist,
                LoopStatus::Playlist => LoopStatus::None,
            };

            match active_player.set_loop_status(operation) {
                Ok(_) => (),
                Err(_) => bail!("API | MPRIS: Cannot set track loop status (dbus error?)"),
            }
        }
    }

    Ok(())
}

fn get_calculated_progress(position: &StdDuration, length: &Option<StdDuration>) -> Option<f64> {
    match length {
        Some(length) => Some(position.as_secs_f64() / length.as_secs_f64()),
        None => None,
    }
}

fn get_player_info(player: &Player) -> Result<PlayerInfo, Error> {
    Ok(PlayerInfo {
        friendly_name: String::from(player.identity()),
        desktop_entry: match player.get_desktop_entry() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | desktopEntry: Cannot get player info (DBus problem): {:?}", e
            ),
        },
        can_be_controlled: match player.can_control() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | canControl: Cannot get player info (DBus problem): {:?}", e
            ),
        },
        can_go_prev: match player.can_go_previous() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | canPrev: Cannot get player info (DBus problem): {:?}", e
            ),
        },
        can_go_next: match player.can_go_next() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | canNext: Cannot get player info (DBus problem): {:?}", e
            ),
        },
        can_play: match player.can_play() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | canPlay: Cannot get player info (DBus problem): {:?}", e
            ),
        },
        can_pause: match player.can_pause() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | canPause: Cannot get player info (DBus problem): {:?}", e
            ),
        },
        can_stop: match player.can_stop() {
            Ok(val) => val,
            Err(e) => bail!(
                "API | MPRIS | getPlayerInfo | canStop: Cannot get player info (DBus problem): {:?}", e
            ),
        },
    })
}
