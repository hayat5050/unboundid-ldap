# FROM java:7
FROM openjdk:8-jre-alpine

ENV UNBOUNDID_HOME /opt/unboundid-ldap
ENV UNBOUNDID_VERSION unboundid-ldapsdk-3.1.0-se

ADD https://docs.ldap.com/ldap-sdk/files/${UNBOUNDID_VERSION}.zip unboundid-ldapsdk-se.zip
RUN mkdir -p ${UNBOUNDID_HOME}
RUN unzip unboundid-ldapsdk-se.zip -d ${UNBOUNDID_HOME}
RUN mkdir -p ${UNBOUNDID_HOME}/conf
ADD conf/ldap.properties ${UNBOUNDID_HOME}/conf/ldap.properties
ADD conf/ldap.ldif ${UNBOUNDID_HOME}/conf/ldap.ldif

ENTRYPOINT ./${UNBOUNDID_HOME}/${UNBOUNDID_VERSION}/tools/in-memory-directory-server \
    --baseDN 'dc=netplus,dc=local' \
    --port 389 \
    --ldifFile ${UNBOUNDID_HOME}/conf/ldap.ldif \
    --accessLogToStandardOut

EXPOSE 389