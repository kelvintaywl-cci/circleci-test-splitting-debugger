ARG python_version

FROM python:${python_version}

COPY . .
RUN pip install -r requirements.txt

ENV PARALLELISM=2

ENV CIRCLE_TOKEN=replaceme
ENV CIRCLE_JOB_NUMBER=1234
ENV CIRCLE_PROJECT_NAME=github/foobar/repo

RUN apt -y update && apt install -y jq curl

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "python", "cli.py", "--partition", "/tmp/testcases.json" ]
