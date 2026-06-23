FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       postgresql-client \
       python3 \
       python3-pip \
       python3-psycopg2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
