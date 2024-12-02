ARG BASE_IMAGE=rust:1.69.0-bullseye

FROM $BASE_IMAGE as planner
WORKDIR /app
RUN cargo install cargo-chef --version 0.1.59 --locked
COPY . .
RUN cargo chef prepare  --recipe-path recipe.json

FROM $BASE_IMAGE as cacher
WORKDIR /app
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y cmake build-essential libclang-dev pkg-config libssl-dev git clang llvm apt-utils protobuf-compiler

RUN cargo install cargo-chef --version 0.1.59 --locked
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json

FROM $BASE_IMAGE as builder
WORKDIR /app
COPY . .
# Copy over the cached dependencies
COPY --from=cacher /app/target target
COPY --from=cacher $CARGO_HOME $CARGO_HOME
RUN cargo build --release

FROM gcr.io/distroless/cc-debian10
COPY --from=builder /app/target/release/publisher /
EXPOSE 8080 
CMD ["./publisher"]
