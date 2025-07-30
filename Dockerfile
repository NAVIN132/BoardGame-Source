FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl && \
    curl -fsSL https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz -o /tmp/maven.tar.gz && \
    tar -xzvf /tmp/maven.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.1 /opt/maven && \
    rm /tmp/maven.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV MAVEN_HOME=/opt/maven
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

USER jenkins
