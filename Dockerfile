ARG ALPINE_VERSION
FROM python:3.11-alpine${ALPINE_VERSION}
ARG TARGETARCH

# install gsuilt
RUN apk add --no-cache curl
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-447.0.0-linux-x86_64.tar.gz
RUN tar -xf google-cloud-cli-447.0.0-linux-x86_64.tar.gz
RUN ./google-cloud-sdk/install.sh
RUN rm google-cloud-cli-447.0.0-linux-x86_64.tar.gz

# install postgresql-client
RUN apk add --no-cache postgresql-client

# install go-cron
RUN apk add curl
RUN curl -L https://github.com/ivoronin/go-cron/releases/download/v0.0.5/go-cron_0.0.5_linux_${TARGETARCH}.tar.gz -O
RUN tar xvf go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
RUN rm go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
RUN mv go-cron /usr/local/bin/go-cron
RUN chmod u+x /usr/local/bin/go-cron
RUN apk del curl

RUN rm -rf /var/cache/apk/*

WORKDIR /app

COPY src/ .

ENV SCHEDULE ''

CMD [ "./run.sh" ]