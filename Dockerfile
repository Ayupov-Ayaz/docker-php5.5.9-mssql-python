FROM ubuntu:trusty
MAINTAINER ayaz ayupov <ayaz.ayupov@gmail.com>

# Downloads URLs
ENV MS_ODBC_URL https://download.microsoft.com/download/B/C/D/BCDD264C-7517-4B7D-8159-C99FC5535680/RedHat6/msodbcsql-11.0.2270.0.tar.gz
ENV FIX_SCRIPT Microsoft--SQL-Server--ODBC-Driver-1.0-for-Linux-Fixed-Install-Scripts
ENV FIX_SCRIPT_URL https://github.com/Andrewpk/${FIX_SCRIPT}/archive/master.zip

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get -y install aptitude wget unzip make gcc libkrb5-3 libgssapi-krb5-2 &&\

  # Download ODBC install files & scripts
  cd /tmp && wget -O msodbcsql.tar.gz ${MS_ODBC_URL} && wget -O odbc-fixed.zip ${FIX_SCRIPT_URL} &&\

  # Unzip downloaded files
  cd /tmp && tar -xzf ./msodbcsql.tar.gz && unzip -o ./odbc-fixed.zip && cp ./${FIX_SCRIPT}-master/* ./msodbcsql-11.0.2270.0 &&\

  # Run install scripts
  cd /tmp/msodbcsql-11.0.2270.0 && yes YES | ./build_dm.sh --accept-warning --libdir=/usr/lib/x86_64-linux-gnu && \
    ./install.sh install --accept-license --force &&\

  # Install apache and php5 with dependencies
  apt-get update &&  apt-get -y install \

    #apache
    apache2 \
    apache2-utils \

    # php5
    php5 \
    php5-gd \
    php5-imagick \
    php5-json \
    php5-mssql \
    php5-curl \
    php5-odbc \

    #python
    python \
    python-pip \
    python-numpy \
    python-dev \
    tdsodbc \

    # apache2 mods
    libapache2-mod-php5 \
    libapache2-mod-python \

    # freeTDS driver
    freetds-dev \
    freetds-bin \
    freetds-common \

    #other
    curl &&\

    #pip and python packages
    pip install -U pip && \
    pip install xlrd \
                xlwt \
                pyodbc &&\

  # Clean installation files
   apt-get remove -y aptitude wget unzip make gcc && apt-get -y autoremove && apt-get clean && \
   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
   apt-get -y clean && \
   apt-get -y autoremove

#db connection configs:
COPY configs/odbcinst.ini /etc/odbcinst.ini
COPY configs/freetds.conf /etc/freetds/freetds.conf
COPY configs/apache.conf /etc/apache2/sites-available/000-default.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
RUN a2enmod rewrite && php5enmod mssql

EXPOSE 80
