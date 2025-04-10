# ------------------------------------------------------------------------
#
# Copyright 2020-2025 WSO2, LLC. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
#
# ------------------------------------------------------------------------

# set base Docker image to WSO2 Identity Server Docker image with latest WSO2 Updates
FROM wso2/wso2is:7.1.0

LABEL maintainer="Ody <odytrice@gmail.com>"

# build arguments for external artifacts
ARG MYSQL_CONNECTOR_VERSION=8.0.30
# ---> ADDED: Define an argument for the PostgreSQL driver version
ARG POSTGRES_CONNECTOR_VERSION=42.7.3 # Using a recent stable version as default

# add MySQL JDBC connector to server home as a third party library
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/repository/components/dropins/

# ---> ADDED: Add PostgreSQL JDBC connector to server home as a third party library
ADD --chown=wso2carbon:wso2 https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_CONNECTOR_VERSION}/postgresql-${POSTGRES_CONNECTOR_VERSION}.jar ${WSO2_SERVER_HOME}/repository/components/dropins/

# You might need other configurations depending on how WSO2 IS is configured
# to use PostgreSQL, but this adds the necessary driver library.