FROM pytorch/pytorch:1.13.0-cuda11.6-cudnn8-runtime

# TimeZone 환경 변수 지정
ENV TZ Asia/Seoul
# TimeZone 설정   
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# git 설치
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        git 

# 쥬피터 노트북 설치 및 환경설정
RUN conda install jupyter

WORKDIR /root/.jupyter
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py

# 폴더 생성
RUN mkdir /root/workdir
#COPY 윈도우 / 도커 경로
ARG PROJECT_DIR="/root/workdir"
COPY requirements.txt ${PROJECT_DIR} 
WORKDIR ${PROJECT_DIR}
# requirements.txt 설치
RUN pip install -r requirements.txt