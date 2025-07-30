# Start from the official Jenkins LTS image
FROM jenkins/jenkins:lts

USER root

# Install Java 11 (OpenJDK)
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk curl && \
    apt-get clean

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Maven 3.8.1
RUN curl -fsSL https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz -o /tmp/maven.tar.gz && \
    tar -xzvf /tmp/maven.tar.gz -C /opt && \
    ln -s /opt/apache-maven-3.8.1 /opt/maven

ENV MAVEN_HOME=/opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"

# Change back to Jenkins user
USER jenkins

