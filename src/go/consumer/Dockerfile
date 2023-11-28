# builder image
FROM golang:1.20-alpine as builder
RUN mkdir /build
WORKDIR /build

COPY go.mod ./
COPY go.sum ./

# download dependencies only
RUN go mod download

COPY *go ./
RUN CGO_ENABLED=0 GOOS=linux go build -a -o consumer .

# generate clean, final image for end users
FROM alpine:3.17
COPY --from=builder /build/consumer .

# executable
ENTRYPOINT [ "./consumer" ]
