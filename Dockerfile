FROM nginx:1.10

ENV UPLOAD_MAX_FILESIZE 64M
ENV FPM_HOST fpm
ENV XDEBUG_HOST fpm_xdebug
ENV FPM_PORT 9000
ENV MAGENTO_ROOT /app
ENV MAGENTO_RUN_MODE default
ENV MFTF_UTILS 0
ENV DEBUG false

COPY etc/nginx.conf /etc/nginx/
COPY etc/vhost.conf /etc/nginx/conf.d/default.conf
COPY etc/xdebug-upstream.conf /etc/nginx/conf.d/xdebug/upstream.conf

RUN mkdir /etc/nginx/ssl
COPY certs/* /etc/nginx/ssl/

RUN groupadd -g 1000 www && useradd -g 1000 -u 1000 -d ${MAGENTO_ROOT} -s /bin/bash www

VOLUME ${MAGENTO_ROOT}

COPY nginx-healthcheck.sh /usr/local/bin/nginx-healthcheck.sh
RUN ["chmod", "+x", "/usr/local/bin/nginx-healthcheck.sh"]

HEALTHCHECK --retries=3 CMD ["bash", "/usr/local/bin/nginx-healthcheck.sh"]

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

USER root

EXPOSE 80

WORKDIR ${MAGENTO_ROOT}

CMD ["nginx", "-g", "daemon off;"]
