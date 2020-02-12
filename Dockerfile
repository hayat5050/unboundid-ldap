# FROM java:7
FROM openjdk:8-jre-alpine

ENV UNBOUNDID_HOME /opt/unboundid-ldap
ENV UNBOUNDID_VERSION unboundid-ldapsdk-3.1.0-se

ENV baseDN='dc=netplus,dc=local'
ENV port=389
ENV additionalBindDN='cn=Manager,dc=netplus,dc=local'
ENV additionalBindPassword='plus321'
ENV LDAP_PROPS_FILE=./conf/ldap.properties
ENV LDAP_LDIF_FILE=./conf/ldap.ldif

ADD https://docs.ldap.com/ldap-sdk/files/${UNBOUNDID_VERSION}.zip unboundid-ldapsdk-se.zip
RUN mkdir -p ${UNBOUNDID_HOME}
RUN mkdir -p ${UNBOUNDID_HOME}/conf
RUN mkdir -p ${UNBOUNDID_HOME}/log
RUN unzip unboundid-ldapsdk-se.zip -d ${UNBOUNDID_HOME}
ADD ${LDAP_PROPS_FILE} ${UNBOUNDID_HOME}/conf/ldap.properties
ADD ${LDAP_LDIF_FILE} ${UNBOUNDID_HOME}/conf/ldap.ldif

ENTRYPOINT ./${UNBOUNDID_HOME}/${UNBOUNDID_VERSION}/tools/in-memory-directory-server \
    --baseDN ${baseDN} \
    --port ${port} \
    --additionalBindDN ${additionalBindDN} \
    --additionalBindPassword ${additionalBindPassword} \
    --ldifFile ${UNBOUNDID_HOME}/conf/ldap.ldif \
    --accessLogToStandardOut

EXPOSE ${port}