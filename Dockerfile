FROM python:3.13.0rc1-slim as build
WORKDIR /wheels

COPY requirements.txt /opt/sherlock/
RUN apt-get update \
  && apt-get install -y build-essential \
  && pip3 wheel -r /opt/sherlock/requirements.txt

FROM python:3.13.0rc1-slim
WORKDIR /opt/sherlock

ARG VCS_REF
ARG VCS_URL="https://github.com/sherlock-project/sherlock"

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL

COPY --from=build /wheels /wheels
COPY . /opt/sherlock/

RUN pip3 install --no-cache-dir . -f /wheels \
  && rm -rf /wheels

WORKDIR /opt/sherlock/sherlock

ENTRYPOINT ["sherlock"]
