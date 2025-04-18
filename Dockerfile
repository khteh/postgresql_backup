FROM ubuntu:25.04
MAINTAINER Kok How, Teh <funcoolgeeek@gmail.com>
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y --fix-missing
RUN apt upgrade -y
RUN apt install -y software-properties-common apt-transport-https python3 curl sudo gnupg mysql-client dnsutils wget git unzip
RUN curl -sL -o /tmp/awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
RUN apt update -y --fix-missing
RUN apt upgrade -y
RUN apt install -y postgresql-client
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
ADD postgres_backup.sh /usr/local/bin/postgres_backup.sh
ENTRYPOINT ["postgres_backup.sh"]
CMD ["/bin/bash"]
