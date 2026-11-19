# SGCI-Adm — baseado no Dockerfile padrão do projeto (PHP 8.4 + Apache + Node 24)
FROM thecodingmachine/php:8.4-v5-apache-node24

# Document root do Laravel e extensões necessárias (MySQL/Aiven, testes, imagens)
ENV APACHE_DOCUMENT_ROOT=public/ \
    PHP_EXTENSIONS="gd intl" \
    PHP_INI_MEMORY_LIMIT=512M

WORKDIR /var/www/html

# Camada de dependências (cache de build)
COPY --chown=docker:docker composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --no-interaction --prefer-dist

COPY --chown=docker:docker . .
RUN composer dump-autoload --optimize --no-dev --no-interaction \
 && mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
 && chmod -R ug+rwX storage bootstrap/cache

EXPOSE 80
# Em produção (Render): definir SGCI_API_URL e SGCI_API_TOKEN nas variáveis de ambiente.
# O Adm não acessa banco: sessão/cache em arquivo.
