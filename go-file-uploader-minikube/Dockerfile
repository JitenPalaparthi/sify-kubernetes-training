FROM golang:1.26 AS builder
WORKDIR /src
COPY go.mod ./
COPY cmd ./cmd
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o /out/app ./cmd/server

FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /out/app /app/app
EXPOSE 8080
ENTRYPOINT ["/app/app"]
