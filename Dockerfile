FROM nginx:1.19

ENV UPLOAD_MAX_FILESIZE 64M
ENV XDEBUG_HOST fpm_xdebug
ENV FPM_HOST fpm
ENV FPM_PORT 9000
ENV UPSTREAM_HOST web
ENV UPSTREAM_PORT 80
ENV MAGENTO_ROOT /app
ENV MAGENTO_RUN_MODE default
ENV MFTF_UTILS 0
ENV DEBUG false

COPY etc/nginx.conf /etc/nginx/
COPY etc/vhost.conf /etc/nginx/conf.d/default.conf
COPY etc/xdebug-upstream.conf /etc/nginx/conf.d/xdebug/upstream.conf

RUN mkdir /etc/nginx/ssl
COPY certs/* /etc/nginx/ssl/

VOLUME ${MAGENTO_ROOT}

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 443

WORKDIR ${MAGENTO_ROOT}

CMD ["nginx", "-g", "daemon off;"]