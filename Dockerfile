# pull official base image
FROM python:3.9.12-alpine

# set work directory
WORKDIR /opt/urlshortner

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev build-base

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt /opt/urlshortner/requirements.txt
RUN export LDFLAGS="-L/usr/local/opt/openssl/lib"
RUN pip install -r requirements.txt

# copy project
COPY src /opt/urlshortner/src
RUN
COPY app.py /opt/urlshortner/
COPY config.py /opt/urlshortner/
COPY .env /opt/urlshortner/
COPY gunicorn.config.py /opt/urlshortner
COPY ./src/docker-entrypoint.sh /opt/urlshortner/docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

EXPOSE 5001

ENTRYPOINT ["/opt/urlshortner/docker-entrypoint.sh"]
