FROM ubuntu:latest

RUN apt-get update
RUN apt-get -o DPkg::Options::="--force-confnew" -y install cron

#RUN service cron start
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils gnupg2 

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get -y install locales \
    && rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

COPY backup.sh /backup.sh
#COPY crontab /etc/crontabs/root

CMD ["bash"]