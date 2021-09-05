FROM composer:latest

WORKDIR /var/www/html

ENTRYPOINT [ "executable", "--ignore-platform-regs" ]