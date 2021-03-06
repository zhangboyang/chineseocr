FROM ubuntu
MAINTAINER https://github.com/chineseocr/chineseocr

#换成ubuntu国内镜像源
RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN sed -i 's/security.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN apt-get update; apt-get install  libsm6 libxrender1 libxext-dev gcc -y

##下载Anaconda3 python 环境安装包 放置在chineseocr目录 url地址https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
COPY Anaconda3-2020.11-Linux-x86_64.sh /chineseocr/
WORKDIR /chineseocr
RUN cd /chineseocr && chmod +x Anaconda3-2020.11-Linux-x86_64.sh && bash -c 'echo -e "\nyes\n\nyes" | bash Anaconda3-2020.11-Linux-x86_64.sh'

#换成conda国内镜像源
RUN (echo 'channels:'; \
     echo '  - defaults'; \
     echo 'show_channel_urls: true'; \
     echo 'default_channels:'; \
     echo '  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main'; \
     echo '  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r'; \
     echo '  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2'; \
     echo 'custom_channels:'; \
     echo '  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'; \
     echo '  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'; \
     echo '  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'; \
     echo '  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'; \
     echo '  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'; \
     echo '  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud'; \
    ) > /root/.condarc


RUN yes | /root/anaconda3/bin/conda update --all
RUN yes | /root/anaconda3/bin/conda install python=3.6

RUN /root/anaconda3/bin/pip install easydict opencv-python-headless Cython 'h5py<3.0.0' pandas requests bs4 matplotlib lxml web.py==0.40.dev0 -U pillow keras==2.1.5 tensorflow==1.8 -i https://pypi.tuna.tsinghua.edu.cn/simple/
RUN yes | /root/anaconda3/bin/conda install pytorch-cpu torchvision-cpu -c pytorch


COPY . /chineseocr
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
EXPOSE 8080
CMD /root/anaconda3/bin/python app.py

#RUN rm Anaconda3-2020.11-Linux-x86_64.sh
#RUN cd /chineseocr/text/detector/utils && sh make-for-cpu.sh
#RUN conda clean -p
#RUN conda clean -t
