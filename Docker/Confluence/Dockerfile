FROM java:8

# Setup application install environment variables
ENV CONFLUENCE_NAME         "atlassian-confluence"
ENV CONFLUENCE_VERSION      "6.2.1"
ENV CONFLUENCE_HOME         "/var/atlassian/confluence"
ENV CONFLUENCE_INSTALL      "/opt/atlassian/confluence"
ENV DOWNLOAD_URL            "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.2.1.tar.gz"
ENV JVM_MYSQL_CONNECTOR_URL "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.42.tar.gz"
ENV JAVA_HOME               "/usr/lib/jvm/java-1.8.0-openjdk-amd64"
ENV RUN_USER                daemon
ENV RUN_GROUP               daemon


RUN apt-get update -y \
    && apt-get install -y  libtcnative-1 xmlstarlet mc liblucene2-java  vim tar

RUN mkdir -p ${CONFLUENCE_HOME} \
                ${CONFLUENCE_INSTALL} \
		${CONFLUENCE_INSTALL}/lib \
    && wget "${DOWNLOAD_URL}" &&  tar -xvf atlassian-confluence-6.2.1.tar.gz -C ./ \
    && cp -R atlassian-confluence-6.2.1/* "${CONFLUENCE_INSTALL}" \

#tar -xvf mysql-connector-java-5.1.42.tar.gz
#mysql-connector-java-5.1.42-bin.jar

    && wget "${JVM_MYSQL_CONNECTOR_URL}"  \
    &&  tar -xvf mysql-connector-java-5.1.42.tar.gz -C ./  \
    && cp /mysql-connector-java-5.1.42/mysql-connector-java-5.1.42-bin.jar /opt/atlassian/confluence/confluence/WEB-INF/lib/ \
    && echo -e "\nconfluence.home=$CONFLUENCE_HOME" >> "${CONFLUENCE_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
    && chmod -R 700 ${CONFLUENCE_HOME} ${CONFLUENCE_INSTALL} \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${CONFLUENCE_HOME} ${CONFLUENCE_INSTALL} \
    && rm -rf /mysql-connector-java-5.1.42 \
    && rm -rf atlassian-confluence-6.2.1


# Expose default HTTP connector port.
EXPOSE 8090

# Next, set the default working directory as confluence home directory.
WORKDIR ${CONFLUENCE_INSTALL}



#USER ${RUN_USER}:${RUN_GROUP}

# Finally, run Atlassian confluence as a foreground process by default.
CMD ["/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]
