# builder image
FROM golang:1.20-alpine as builder
RUN mkdir /build
# ADD *.go /build/
COPY . /build/
WORKDIR /build
# RUN CGO_ENABLED=0 GOOS=linux go build -a -o consumer .

RUN --mount=type=cache,id=gobuild,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux go build -a -o consumer .


# generate clean, final image for end users
FROM alpine:3.17
COPY --from=builder /build/consumer .

# executable
ENTRYPOINT [ "./consumer" ]
