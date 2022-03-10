FROM alpine:latest 

ARG BUILD_DATE="ooit op een dag"

LABEL org.opencontainers.image.created $BUILD_DATE
LABEL org.opencontainers.image.authors "Rutger Hartog"
LABEL org.opencontainers.image.url ""
LABEL org.opencontainers.image.documentation ""
LABEL org.opencontainers.image.source ""
LABEL org.opencontainers.image.version "0.1.0"
LABEL org.opencontainers.image.revision "not set" 
LABEL org.opencontainers.image.vendor ""
LABEL org.opencontainers.image.licenses "Apache"
LABEL org.opencontainers.image.ref.name ""
LABEL org.opencontainers.image.title "Fileserver"
LABEL org.opencontainers.image.description "A webDAV-based fileserver"
LABEL org.opencontainers.image.base.digest "c74f1b116678"
LABEL org.opencontainers.image.base.name "registry.docker.io/_/alpine"



# Install nginx and webDAV extensions
RUN apk add -U nginx nginx-mod-http-dav-ext 

# Copy the setup script, which will configure nginx accordingly
COPY setup.sh .

# Configure nginx 
RUN sh setup.sh 

# We will run the app on port 8000
EXPOSE 8000

# Drop privileges to nginx user, then run
USER nginx
CMD nginx -g "daemon off;"