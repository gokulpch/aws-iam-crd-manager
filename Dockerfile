# Build the manager binary
FROM golang:1.10.3 as builder

# Copy in the go src
WORKDIR /go/src/github.com/gokulpch/aws-iam-crd-manager
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY vendor/ vendor/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager github.com/gokulpch/aws-iam-crd-manager/cmd/manager

# Copy the controller-manager into a thin image
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/gokulpch/aws-iam-crd-manager/manager .
ENTRYPOINT ["./manager"]
