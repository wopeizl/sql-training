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
# Build Flink images with configured S3 plugin
###############################################################################

#FROM flink:1.11.3-scala_2.11
FROM flink:1.11.3-scala_2.12-java8

ARG FLINK_VERSION=1.11.3

ADD VERSION .

# move and download dependencies
RUN mkdir /opt/flink/plugins/s3; \
    mv /opt/flink/opt/flink-s3-fs-hadoop-1.11.3.jar /opt/flink/plugins/s3; 

# adjust configuration
RUN echo "s3.access-key: minio" >> /opt/flink/conf/flink-conf.yaml; \
    echo "s3.secret-key: minio123" >> /opt/flink/conf/flink-conf.yaml; \
    echo "fs.s3a.endpoint: http://minio:9000" >> /opt/flink/conf/flink-conf.yaml; \
    echo "fs.s3a.path.style.access: true" >> /opt/flink/conf/flink-conf.yaml; \
    sed -i -e 's/taskmanager.memory.process.size: 1568m/taskmanager.memory.process.size: 1728m/g' /opt/flink/conf/flink-conf.yaml; \
    echo "taskmanager.memory.jvm-metaspace.size: 256m" >> /opt/flink/conf/flink-conf.yaml;

ENV FLINK_HOME /opt/flink

ADD 3rd-libs/*.jar ${FLINK_HOME}/lib/
ADD conf/flink-conf/*.yaml  ${FLINK_HOME}/conf/
ADD conf/hive-conf/*.xml  /opt/hive-conf/
        
ENV HADOOP_VERSION 3.2.2
# ENV HADOOP_URL http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HADOOP_CONF_DIR=/etc/hadoop
# COPY lib/hadoop-${HADOOP_VERSION}.tar.gz /
COPY lib/* /
RUN cat /hadoop-${HADOOP_VERSION}.tar.gz.* |tar -xzf - -C / && \
        tar -xzf /hadoop-${HADOOP_VERSION}.tar.gz -C /opt && \
        rm /hadoop-${HADOOP_VERSION}.tar.gz* && \
        ln -s /opt/hadoop-${HADOOP_VERSION}/etc/hadoop /etc/hadoop
ENV PATH ${HADOOP_HOME}/bin/:$PATH
ADD bin/config.sh ${FLINK_HOME}/bin
ADD conf/hdp-conf/*.xml /opt/hadoop-${HADOOP_VERSION}/etc/hadoop/

