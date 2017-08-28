FROM centos:7
MAINTAINER sgardner

RUN yum update -y && \
	yum clean all

RUN yum install -y git && \
	yum install -y wget && \
	yum install -y maven && \
	yum install -y openssh-server && \
	yum install -y java-1.8.0-openjdk && \
	yum install -y sudo && \
	yum clean all

RUN /usr/bin/ssh-keygen -A

RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pamloginuid.so/' /etc/pam.d/sshd

RUN useradd jenkins -m -s /bin/bash

RUN mkdir /home/jenkins/.ssh
COPY /files/authorized_keys /home/jenkins/.ssh/authorized_keys
RUN chown -R jenkins /home/jenkins
RUN chgrp -R jenkins /home/jenkins
RUN chmod 600 /home/jenkins/.ssh/authorized_keys
RUN chmod 700 /home/jenkins/.ssh

RUN echo "jenkins ALL=(ALL) ALL" >> /etc/sudoers

COPY /files/resolv.conf /etc/resolv.conf

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
