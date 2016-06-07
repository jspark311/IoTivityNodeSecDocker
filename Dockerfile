
FROM ubuntu
RUN apt-get -y update
RUN apt-get install -y git-core scons ssh build-essential g++ doxygen valgrind libboost-dev libboost-program-options-dev libboost-thread-dev uuid-dev libssl-dev libtool libglib2.0-dev unzip curl openssh-server 

# Fix for ssh errors?
RUN mkdir /var/run/sshd
RUN rm -rf /etc/ssh/sshd_host_not_to_run

# Thanks, docker...
# https://docs.docker.com/engine/examples/running_ssh_service/
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN curl -sL https://deb.nodesource.com/setup_6.x | /bin/bash -
RUN apt-get install -y nodejs

RUN npm install -g node-gyp grunt

COPY Buildscript /root/Buildscript
RUN chmod +x /root/Buildscript

WORKDIR /root

RUN /root/Buildscript

EXPOSE 22
EXPOSE 5683/udp
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/bin/bash"]

