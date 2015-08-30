FROM python:3.3-wheezy
MAINTAINER Alexander Vaniashev

ENV CQ_CODE=/code

RUN mkdir $CQ_CODE
WORKDIR $CQ_CODE
COPY requirements.txt requirements.txt
COPY oursql-0.9.4 oursql

RUN apt-get build-dep python3-scipy

RUN pip install uwsgi
RUN pip install git+https://github.com/jorgecarleitao/django-sphinxql.git
RUN pip install Cython
RUN pip install Numpy
WORKDIR $CQ_CODE/oursql
RUN python setup.py install
WORKDIR $CQ_CODE
RUN pip install -r $CQ_CODE/requirements.txt

VOLUME ["/data/qvark/"]

WORKDIR /data/qvark/
CMD uwsgi --socket __main/running.sock --wsgi-file __main/wsgi.py --daemonize log/uwsgi.log --pidfile __main/running.pid --master --buffer-size=65536
