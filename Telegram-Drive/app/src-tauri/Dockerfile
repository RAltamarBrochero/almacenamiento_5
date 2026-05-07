FROM rust:1.71 as builder
WORKDIR /usr/src/app
COPY . .
RUN rustup target add x86_64-unknown-linux-gnu || true
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/app/target/release/tauri-app /usr/local/bin/telegram-drive
EXPOSE 14201
ENV RUST_LOG=info
CMD ["/usr/local/bin/telegram-drive"]
