use whoami::fallible::{hostname, realname, username};

pub struct UserInfo {
    pub fullname: String,
    pub username: String,
    pub hostname: String,
}

pub fn get_user_info() -> UserInfo {
    UserInfo {
        fullname: realname().unwrap(),
        username: username().unwrap(),
        hostname: hostname().unwrap(),
    }
}
