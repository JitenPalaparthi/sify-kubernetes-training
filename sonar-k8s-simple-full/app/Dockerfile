FROM golang:1.24 AS builder
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w -X github.com/example/sonar-k8s-simple/app/internal/version.Version=${APP_VERSION}" -o /out/app ./cmd/server

FROM gcr.io/distroless/static-debian12
WORKDIR /
COPY --from=builder /out/app /app
EXPOSE 8080
USER 65532:65532
ENTRYPOINT ["/app"]
