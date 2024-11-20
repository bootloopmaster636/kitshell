use mpris::PlayerFinder;

pub struct MprisData {
    pub title: String,
    pub artist: Vec<String>,
    pub album: String,
    pub image_url: String,
    pub duration: u64,
    pub position: u64,
    pub is_playing: bool,
    pub can_next: bool,
    pub can_previous: bool,
}

pub async fn get_mpris_data() -> MprisData {
    let player = PlayerFinder::new()
        .expect("Failed to connect to D-Bus")
        .find_active();
    let player_result = match (player) {
        Ok(player) => player,
        Err(_) => {
            return MprisData {
                title: "".to_string(),
                artist: vec!["".to_string()],
                album: "".to_string(),
                image_url: "".to_string(),
                duration: 0,
                position: 0,
                is_playing: false,
                can_next: false,
                can_previous: false,
            };
        }
    };

    let metadata = player_result
        .get_metadata()
        .expect("Failed to get metadata");

    let title = metadata.title().unwrap_or("");
    let artist = metadata.artists().unwrap();
    let album = metadata.album_name().unwrap_or("");
    let image_url = metadata.art_url().unwrap_or("");
    let duration = metadata.length_in_microseconds().unwrap_or(0);
    let position = player_result.get_position_in_microseconds().unwrap_or(0);
    let is_playing = player_result
        .get_playback_status()
        .expect("Failed to get playback status")
        == mpris::PlaybackStatus::Playing;
    let can_next = player_result
        .can_go_next()
        .expect("Failed to get next status");
    let can_previous = player_result
        .can_go_previous()
        .expect("Failed to get previous status");

    MprisData {
        title: title.to_string(),
        artist: artist.iter().map(|s| s.to_string()).collect(),
        album: album.to_string(),
        image_url: image_url.to_string(),
        duration,
        position,
        is_playing,
        can_next,
        can_previous,
    }
}

pub async fn player_toggle_pause() {
    let player = PlayerFinder::new()
        .expect("Failed to connect to D-Bus")
        .find_active()
        .expect("No active player found");
    if (player
        .get_playback_status()
        .expect("Failed to get playback status")
        == mpris::PlaybackStatus::Playing)
    {
        player.pause().expect("Failed to pause player");
    } else {
        player.play().expect("Failed to play player");
    }
}

pub async fn player_next() {
    let player = PlayerFinder::new()
        .expect("Failed to connect to D-Bus")
        .find_active()
        .expect("No active player found");
    player.next().expect("Failed to play next song");
}

pub async fn player_previous() {
    let player = PlayerFinder::new()
        .expect("Failed to connect to D-Bus")
        .find_active()
        .expect("No active player found");
    player.previous().expect("Failed to play previous song");
}
