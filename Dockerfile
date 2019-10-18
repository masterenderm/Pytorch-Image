FROM pytorch/pytorch:1.3-cuda10.1-cudnn7-runtime
MAINTAINER master

WORKDIR /home

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install vim \
    wget \
    git \
    ssh \
    openssh-server
RUN mkdir /var/run/sshd \
    && echo 'root:850130' | chpasswd \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
# SSH login fix. Otherwise user is kicked off after login
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
