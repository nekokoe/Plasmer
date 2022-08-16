FROM ubuntu:20.04 AS builder

RUN apt-get update && \
	apt-get install --no-install-suggests --no-install-recommends --yes wget
RUN wget --no-check-certificate "https://github.com/shenwei356/seqkit/releases/download/v2.2.0/seqkit_linux_amd64.tar.gz" -O /tmp/seqkit.tar.gz && \
	tar zxvf /tmp/seqkit.tar.gz -C /usr/bin/ && rm /tmp/seqkit.tar.gz

FROM ubuntu:20.04
MAINTAINER iskoldt-X
COPY --from=builder /usr/bin/seqkit /usr/bin/

ENTRYPOINT ["seqkit"]
