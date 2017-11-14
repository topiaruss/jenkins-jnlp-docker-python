FROM jenkinsci/slave:alpine

USER root
RUN apk add --upgrade --no-cache \
ca-certificates \
curl \
openssl \
python \
py-pip \
py-yaml

ENV DOCKER_BUCKET download.docker.com
ENV DOCKER_VERSION 17.09.0-ce
ENV DOCKER_SHA256 a9e90a73c3cdfbf238f148e1ec0eaff5eb181f92f35bdd938fd7dab18e1c4647

RUN set -x \
&& curl -fSL "https://${DOCKER_BUCKET}/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
&& echo "${DOCKER_SHA256} docker.tgz" | sha256sum -c - \
&& tar -xzf docker.tgz \
&& mv docker/* /usr/local/bin/ \
&& rmdir docker \
&& rm docker.tgz \
&& docker -v

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
