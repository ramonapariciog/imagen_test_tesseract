FROM ubuntu:22.04

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    git \
    ffmpeg \
    libsm6 \
    libxext6 \
    python3-pip

## Para desinstalar versiones anteriores
# sudo apt list --installed | grep tesseract
# sudo apt purge tesseract-ocr
# sudo apt purge libtesseract4
## ------------------------------------------

RUN add-apt-repository ppa:alex-p/tesseract-ocr5
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    tesseract-ocr=5.2.0-1ppa1~jammy1 \
    python3.8 \
    python3.8-dev \
    python3.8-venv

RUN pip3 install --upgrade pip
WORKDIR /code
COPY requerimientos.txt .

ENV VIRTUAL_ENV=/opt/venv_python3.8
RUN mkdir $VIRTUAL_ENV
RUN /usr/bin/python3.8 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Activar
# source /opt/virtual_env/venv_with_python3.8/bin/activate

RUN pip install -r requerimientos.txt
RUN pip install git+https://github.com/scikit-learn-contrib/py-earth@v0.2dev

EXPOSE 5053
RUN mkdir /home/SIVA
WORKDIR /home/SIVA/indiceSIVA

ENTRYPOINT ["sh", "run_server.sh"]

# docker image build -t indice_deterioro_12:siva .
# docker save indice_deterioro_10:siva > indiceDetSIVA.tar
# docker run -it --rm -p 5053:5053 -v $(realpath ./indiceSIVA):/home/SIVA --name indice_deterioro indice_deterioro_11:siva
