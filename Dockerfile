# マルチステージビルドを使用
FROM rust:1.78-slim-bookworm AS builder
WORKDIR /app
# 下二行は3章説明のsqlxクレートを使ったビルドで使用
ARG DATABASE_URL
ENV DATABASE_URL=${DATABASE_URL}
COPY . .
RUN cargo build --release

# 不要なソフトウェアを同梱する必要はないので、軽量なbookworm-slimを使用
FROM debian:bookworm-slim
WORKDIR /app

# ユーザを作成
RUN adduser book && chown -R book /app
USER book 
COPY --from=builder ./app/target/release/app ./target/release/app

# 8080ポートを解放し、アプリを起動
ENV PORT 8080
EXPOSE $PORT 
ENTRYPOINT ["./target/release/app"]

