# ------------------------------------------------------------------------------
# Build Stage
# ------------------------------------------------------------------------------
FROM ekidd/rust-musl-builder:stable as builder

COPY build/cargo.conf .cargo/config
COPY Cargo.toml build.rs ./
RUN mkdir src && \
    echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/yourapp*

COPY . .
RUN cargo build --release

# ------------------------------------------------------------------------------
# Run Stage
# ------------------------------------------------------------------------------
FROM alpine:latest
WORKDIR /app
EXPOSE 8000
COPY --from=builder /volume/target/x86_64-unknown-linux-musl/release/yourapp ./
CMD ["./yourapp", "--config=config.toml"]
