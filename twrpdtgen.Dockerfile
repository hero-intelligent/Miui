FROM python:3.8

RUN apt update && apt install cpio -y
RUN pip install twrpdtgen

