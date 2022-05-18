#!/bin/sh

set -e

export FLASK_APP=app.py
ls -ltrha
rm -rf migrations
flask db init
flask db migrate
flask db upgrade

gunicorn -c gunicorn.config.py src:app
