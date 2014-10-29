# jsreport 
FROM dockerfile/java:oracle-java7
MAINTAINER Michael Klatskin <michael.ecompositor.com>
EXPOSE 443
RUN mkdir /reports

#versions
ENV SCALA_TAR_URL http://www.scala-lang.org/files/archive
ENV SCALA_VERSION 2.10.4
ENV SBT_VERSION 0.13.6

RUN sudo apt-get update -y
RUN sudo apt-get install chrpath libssl-dev libfontconfig1-dev -y

#install scala
RUN wget $SCALA_TAR_URL/scala-$SCALA_VERSION.tgz
RUN tar xvf scala-$SCALA_VERSION.tgz
RUN mv scala-$SCALA_VERSION /usr/lib
RUN rm scala-$SCALA_VERSION.tgz
RUN ln -s /usr/lib/scala-$SCALA_VERSION /usr/lib/scala

ENV PATH $PATH:/usr/lib/scala/bin
 
# install sbt
RUN wget -O /usr/local/bin/sbt-launch.jar http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/$SBT_VERSION/sbt-launch.jar
ADD scripts/sbt.sh /usr/local/bin/sbt
RUN chmod 755 /usr/local/bin/sbt

# Install Python.
RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

WORKDIR /reports

RUN sudo apt-get install freetype* build-essential git-core -y 

RUN  \
  wget http://npmjs.org/install.sh | sh && \
  npm install jsreport && \
  npm install nodemailer && \ 
  npm install cron && \
  node node_modules/jsreport --init && \
  pip install --upgrade httpie

CMD ["node server.js"]
