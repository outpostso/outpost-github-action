FROM alpine

LABEL "com.github.actions.name"="Github Action for Outpost"
LABEL "com.github.actions.description"="Track your deployment in Outpost to be used in Github Actions"
LABEL "com.github.actions.icon"="download-cloud"
LABEL "com.github.actions.color"="gray-dark"

LABEL "repository"="https://github.com/outpostso/outpost-github-action"
LABEL "homepage"="https://github.com/outpostso/outpost-github-action"
LABEL "maintainer"="Outpost Team <github@outpost.so>"

RUN apk add --no-cache curl ca-certificates

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
