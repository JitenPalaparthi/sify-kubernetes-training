package main

import (
    "encoding/json"
    "log"
    "net/http"
    "os"
    "time"

    "github.com/example/sonar-k8s-simple/app/internal/version"
)

type healthResponse struct {
    Status    string `json:"status"`
    Service   string `json:"service"`
    Version   string `json:"version"`
    Timestamp string `json:"timestamp"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    _ = json.NewEncoder(w).Encode(healthResponse{
        Status:    "ok",
        Service:   "sonar-k8s-demo",
        Version:   version.Version,
        Timestamp: time.Now().UTC().Format(time.RFC3339),
    })
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
    _, _ = w.Write([]byte("sonar-k8s-demo is running\n"))
}

func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/", rootHandler)
    mux.HandleFunc("/healthz", healthHandler)
    mux.HandleFunc("/readyz", healthHandler)

    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    server := &http.Server{
        Addr:              ":" + port,
        Handler:           mux,
        ReadHeaderTimeout: 5 * time.Second,
    }

    log.Printf("server listening on :%s", port)
    if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
        log.Fatalf("server failed: %v", err)
    }
}
