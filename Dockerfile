FROM python:3
ENV PYTHONUNBUFFERED 1

# Requirements have to be pulled and installed here, otherwise caching won't work
ADD ./requirements /requirements
ADD ./requirements.txt /requirements.txt

RUN pip install -r /requirements.txt
RUN pip install -r /requirements/local.txt

RUN groupadd -r django && useradd -r -g django django
ADD . /app

# Node install
RUN apt-get update && apt-get install nodejs npm ruby-compass --yes && apt-get autoremove --yes && apt-get clean
# Fixing node path, set /usr/bin/node to /usr/bin/nodejs
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10

# Nodejs package require own python, but it's already intalled
# Fix default python link to /usr/local/bin/python
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python 10

RUN npm install -g grunt grunt-cli

RUN cd /app && npm install
RUN cd /app && grunt build

RUN chown -R django /app

ADD ./compose/django/env.sh /env.sh
ADD ./compose/django/gunicorn.sh /gunicorn.sh
ADD ./compose/django/entrypoint.sh /entrypoint.sh

RUN chmod +x /env.sh && chown django /env.sh
RUN chmod +x /entrypoint.sh && chown django /entrypoint.sh
RUN chmod +x /gunicorn.sh && chown django /gunicorn.sh

WORKDIR /app/pcdocker

ENTRYPOINT ["/entrypoint.sh"]
