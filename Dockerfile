FROM php:8.2-fpm AS php-build

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    libonig-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a stripped-down PHP binary for Vercel
RUN mkdir -p /opt/vercel-php && \
    cp /usr/local/bin/php /opt/vercel-php/ && \
    cp -r /usr/local/lib/php /opt/vercel-php/ && \
    cp /usr/local/etc/php/php.ini-production /opt/vercel-php/php.ini && \
    tar -czf /tmp/vercel-php.tar.gz -C /opt vercel-php

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl
RUN docker-php-ext-install gd

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add user for application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"] 