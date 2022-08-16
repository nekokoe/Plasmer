FROM gcc:12 AS builder
 
RUN wget "https://github.com/shenwei356/seqkit/releases/download/v2.2.0/seqkit_linux_amd64.tar.gz" -O /tmp/seqkit.tar.gz && \
	tar zxvf /tmp/seqkit.tar.gz -C /usr/bin/ && \
	rm /tmp/seqkit.tar.gz

RUN git clone https://github.com/hyattpd/Prodigal.git && \
	cd Prodigal && \
	make install -j8

RUN wget "https://github.com/bbuchfink/diamond/releases/download/v2.0.8/diamond-linux64.tar.gz" -O /tmp/diamond-linux64.tar.gz && \
        tar zxvf /tmp/diamond-linux64.tar.gz -C /usr/bin/ && rm /tmp/diamond-linux64.tar.gz

RUN wget "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.10.1/ncbi-blast-2.10.1+-x64-linux.tar.gz" -O /tmp/ncbi-blast-2.10.1+-x64-linux.tar.gz && \
	mkdir /tmp/blast && \
        tar zxvf /tmp/ncbi-blast-2.10.1+-x64-linux.tar.gz -C /tmp/blast && \
	rm /tmp/ncbi-blast-2.10.1+-x64-linux.tar.gz

FROM ubuntu:20.04
MAINTAINER iskoldt-X

COPY --from=builder /usr/bin/seqkit /usr/bin/
COPY --from=builder /usr/bin/diamond /usr/bin/
COPY --from=builder /usr/local/bin/prodigal /usr/local/bin/
COPY --from=builder /tmp/blast/ncbi-blast-2.10.1+/bin/ /usr/local/bin/

RUN apt-get update && \
        apt-get install --no-install-suggests --no-install-recommends --yes\
        parallel hmmer

ENTRYPOINT ["blastn"]
