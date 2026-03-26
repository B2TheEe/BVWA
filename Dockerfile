FROM golang:1.24.2-alpine

# Installeer bee CLI en build tools
RUN go install github.com/beego/bee/v2@latest
RUN apk add --no-cache git

# Werkmap
WORKDIR /app

# Kopieer project
COPY . .

# Download dependencies
RUN go mod download

# Expose poort
EXPOSE 8080

# Start applicatie
CMD ["bee", "run"]
