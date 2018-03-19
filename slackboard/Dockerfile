FROM golang:1.10-alpine

WORKDIR /tmp
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/main" > /etc/apk/repositories && \
  apk add --update perl git
RUN go get -u github.com/cubicdaiya/slackboard/...

COPY setup_configs.sh run.sh config.toml.sample generate_config.pl /tmp/

ENV PORT 29800
ENV SLACK_URL https://
ENV QPS 1
ENV MAX_DELAY_DURATION 5
ENV TAGS "random|#random|random|:warning:||general|#general|general|:warning:"

CMD /tmp/setup_configs.sh && /tmp/run.sh
