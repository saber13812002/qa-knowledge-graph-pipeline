FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV HF_HOME=/models/hf
ENV TRANSFORMERS_CACHE=/models/hf
ENV SENTENCE_TRANSFORMERS_HOME=/models/hf

RUN rm -f /etc/apt/sources.list.d/cuda*.list /etc/apt/sources.list.d/nvidia*.list /etc/apt/sources.list.d/libnvidia*.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends python3.11 python3.11-dev python3.11-venv python3-pip curl wget git vim tini jq ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sf /usr/bin/python3.11 /usr/bin/python \
 && ln -sf /usr/bin/python3.11 /usr/bin/python3

COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && pip install -r /tmp/requirements.txt

WORKDIR /work
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
