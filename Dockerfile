FROM python:2.7

ADD runserver.py /
ADD requirements.txt /
ADD . /assessment

WORKDIR /assessment

RUN pip install -r requirements.txt

CMD [ "python", "./runserver.py" ]
