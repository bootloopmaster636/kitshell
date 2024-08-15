pub fn enable_rust_stacktrace() {
    std::env::set_var("RUST_BACKTRACE", "full");
}