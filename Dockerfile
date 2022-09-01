FROM python:3.9-alpine3.13      
#python- name of image and alpine is a light weight version of linux and very strict with absolutely no dependencies
LABEL maintaner="kakarott@gmail.com"     
#name of the maintaner who is mantaining docker container


ENV PYTHONUNBUFFERED 1      
#Recom. when running python program in docker container as it prevents any buffer and python o/p's are printed directly from console

#cOPY from local mchine req.text to docker container and simillarly app from local machine to app in the docker container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app 
#wordir is from where we'll be running our app
EXPOSE 8000

#Only we'll run via yml, ARG=True means files are being config for development process
ARG DEV=false
# Created a virt. env and transfered all files from local machines to docker cont. and also created "django user" named container with no home and no pass
RUN python -m venv /py && \   
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    #gonna install development dependencies if true
    if [ $DEV = "true" ]; \     
       then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \    
    #end if style in shell scripting
    rm -rf /tmp && \
    adduser \
       --disabled-password \
       --no-create-home \
       django-user

ENV PATH="/py/bin:$PATH"

# anytime we run from docker img, its gonna run as django-user. it doesn't have full root privilges as for extra safety if incase it gets compromised.
USER django-user     





