# Go parameters
.PHONY:  testall test testl testv coverage threshold lint run depgraph
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GORUN=$(GOCMD) run .
GOCOV=$(GOCMD) tool cover -html=coverage.out
GOTEST=$(GOCMD) test -tags test -short
GOGET=$(GOCMD) get
GODEP=godepgraph -s -o  github.com/webmalc/mb-redirector github.com/webmalc/mb-redirector | dot -Tpng -o godepgraph.png
BINARY_NAME=mb-redirector

all: build

build:
	$(GOBUILD) -o $(BINARY_NAME) -v

test:
	GOENV=test $(GOTEST) ./... -coverprofile=coverage.out

testv:
	GOENV=test $(GOTEST) -v ./... -coverprofile=coverage.out

depgraph:
	$(GODEP)

coverage:
	$(GOCOV)

threshold:
	overcover --coverprofile coverage.out --threshold 80 --summary
testl: testv lint

testall: test lint threshold

clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)

lint:
	golangci-lint run ./...
	golint ./...

run:
	$(GORUN) $(c)