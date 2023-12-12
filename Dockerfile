FROM ubuntu:22.04

# dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y \
        build-essential git python3 python3-pip wget \
        ffmpeg libsm6 libxext6 libxrender1 libglib2.0-0

RUN pip3 install -U pip
RUN pip3 install --upgrade pip

WORKDIR /solution

COPY requirements.txt .
RUN pip3 install -r requirements.txt
RUN mim install mmcv==2.0.0 # can be deleted

COPY . .

# model weights
RUN mkdir -p ./weights
COPY weights/last6.pt ./weights
COPY weights/best_tree_model.joblib ./weights
COPY weights/scaler_model.joblib ./weights

# input and output folders
RUN mkdir -p ./test/images
RUN mkdir -p ./test/labels
RUN mkdir -p ./output

CMD /bin/sh -c "python3 solution.py"