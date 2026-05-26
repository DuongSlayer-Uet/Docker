FROM ubuntu:20.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    make \
    python3.9 \
    git

WORKDIR /app

COPY . .

RUN make

RUN make package

CMD ["make", "run"]