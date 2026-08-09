FROM ubuntu:24.04 AS build

RUN apt-get update && apt-get install -y \
    git cmake g++ make zlib1g-dev libssl-dev gperf php-cli ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN mkdir build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && cmake --build . --target install -j"$(nproc)"

FROM ubuntu:24.04
RUN apt-get update && apt-get install -y ca-certificates libssl3 zlib1g \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /usr/local/bin/telegram-bot-api /usr/local/bin/telegram-bot-api

ENTRYPOINT ["/usr/local/bin/telegram-bot-api"]