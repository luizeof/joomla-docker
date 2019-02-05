FROM joomla:7.2-apache

LABEL maintainer="Luiz Eduardo Oliveira Fonseca <luizeof@gmail.com> (@luizeof)"

RUN apt-get update

RUN apt-get install software-properties-common -y

RUN apt-get install sudo build-essential tcl8.5 zlib1g-dev libicu-dev g++ -y

RUN apt-get install -y \
      curl \
      libmemcached-dev \
      libz-dev \
      libpq-dev \
      libjpeg-dev \
      libpng-dev \
      libfreetype6-dev \
      libcurl4-openssl-dev \
      libssl-dev \
      bzip2 \
      csstidy \
      libfreetype6-dev \
  		libicu-dev \
  		libldap2-dev \
  		libmemcached-dev \
  		libxml2-dev \
  		libz-dev \
      tidy \
      libapache2-modsecurity \
      wget \
      nano \
      htop \
      zip \
      unzip \
      libmagickwand-dev \
      imagemagick

RUN docker-php-ext-install pdo intl xml zip mysqli pdo_mysql soap

# Install the PHP gd library
RUN docker-php-ext-configure gd \
      --enable-gd-native-ttf \
      --with-jpeg-dir=/usr/lib \
      --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

# Install Extra modules
RUN pecl install \
		apcu-5.1.11 \
		memcached-3.0.4

# Enable Extra modules
RUN docker-php-ext-enable \
		apcu \
		memcached

RUN pecl install imagick -y

RUN docker-php-ext-enable imagick

RUN docker-php-ext-install exif

RUN a2enmod setenvif headers deflate filter expires rewrite include ext_filter

COPY luizeof.ini /usr/local/etc/php/conf.d/luizeof.ini

COPY luizeof.conf /etc/apache2/conf-available/luizeof.conf

RUN curl -o /home/mod-pagespeed-beta_current_amd64.deb https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-beta_current_amd64.deb

RUN dpkg -i /home/mod-pagespeed-*.deb

RUN apt-get -f install

RUN a2enconf luizeof

ENTRYPOINT ["entrypoint.sh"]

CMD ["apache2-foreground"]