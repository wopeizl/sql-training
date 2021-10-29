###############################################################################
# Copyright 2020 Ververica GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

###############################################################################
# Build Click Count Job
###############################################################################

FROM maven:3.6-jdk-8-slim AS builder

# Get UDF code and compile it
COPY ./java/sql-training-udfs /opt/sql-udfs
RUN cd /opt/sql-udfs; \
    mvn clean install

# Get data producer code and compile it
COPY ./java/sql-training-data-producer /opt/data-producer
RUN cd /opt/data-producer; \
    mvn clean install

###############################################################################
# Build SQL Playground Image
###############################################################################

# FROM flink:1.11.3-scala_2.11
FROM wopeizl/flink1.11.3-yarn-embedded:0.1

ARG FLINK_VERSION=1.11.3

# Copy sql-client configuration
COPY sql-client/ /opt/sql-client

# Copy playground UDFs
COPY --from=builder /opt/sql-udfs/target/sql-training-udfs-*.jar /opt/sql-client/lib/

# Copy data producer
COPY --from=builder /opt/data-producer/target/sql-training-data-producer-*.jar /opt/data/data-producer.jar

# Create data folders
RUN    mkdir -p /opt/data; \
    mkdir -p /opt/data/stream; 
# Download data files

COPY ./data/* /opt/data/

# Copy configuration
COPY conf/* /opt/flink/conf/

WORKDIR /opt/sql-client
ENV SQL_CLIENT_HOME /opt/sql-client
