FROM python:3.6.15-bullseye
# FROM python:3.6.8-stretch


# Set the working directory to /app
COPY . /app
WORKDIR /app


# Install the dependencies
RUN python -m pip install --upgrade pip && \
    python -m pip install ./


# Run tests
RUN python -m unittest discover -s tests -t .


CMD python -m hexoshi -mq
