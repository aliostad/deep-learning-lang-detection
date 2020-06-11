FROM ubuntu:14.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget \
      curl \
      python-pip

RUN pip install --upgrade pip
RUN pip install --ignore-installed six

RUN pip install \
      tensorflow \
      requests \
      flask \
      numpy \
      keras \
      h5py

ENV NB_USER keras
ENV NB_UID 1000
ENV SRC_PATH /app


RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
RUN mkdir -p $SRC_PATH && \
    chown $NB_USER $SRC_PATH -R

USER $NB_USER

ADD wsgi.py $SRC_PATH
ADD lang_detect_api.py $SRC_PATH
ADD data_helper.py $SRC_PATH
ADD defs.py $SRC_PATH
ADD save_tmp.h5 $SRC_PATH
ADD ui $SRC_PATH/ui
ADD data/stackoverflow-snippets $SRC_PATH/data/stackoverflow-snippets

EXPOSE 5000

WORKDIR $SRC_PATH
ENTRYPOINT ["python2"]
CMD ["wsgi.py"]
