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

RUN git clone https://github.com/refresh-bio/kmer-db && \
	cd kmer-db && \
	make -j8

RUN wget "http://eddylab.org/software/infernal/infernal.tar.gz" && \
	tar zxf infernal.tar.gz && \
	cd infernal-1.1.4 && \
	./configure --prefix /usr/bin/infernal && \
	make -j8 && \
	make check && \
	make install

RUN git clone https://github.com/DerrickWood/kraken2.git && \
	cd kraken2 && \
	./install_kraken2.sh /usr/bin/kraken2

FROM ubuntu:22.04
MAINTAINER iskoldt-X

COPY --from=builder /usr/bin/seqkit /usr/bin/
COPY --from=builder /usr/bin/diamond /usr/bin/
COPY --from=builder /usr/local/bin/prodigal /usr/local/bin/
COPY --from=builder /tmp/blast/ncbi-blast-2.10.1+ /usr/local/bin/blast
COPY --from=builder /kmer-db /usr/bin/kmer-db
COPY --from=builder /usr/bin/infernal /usr/bin/infernal
COPY --from=builder /usr/bin/kraken2 /usr/bin/kraken2

ENV TZ=Etc/UTC
RUN apt-get update && \
	DEBIAN_FRONTEND=nointeractive \
        apt-get install --no-install-suggests --no-install-recommends --yes\
        parallel hmmer python3.10 r-base libgomp1 && \
	apt-get clean

ENV PATH="/usr/bin/infernal/bin:/usr/bin/kraken2:/usr/bin/kmer-db:/usr/local/bin/blast/bin:/usr/bin/kmer-db:${PATH}"

RUN cmscan
RUN R --version

ENTRYPOINT ["cmscan"]
