# jsreport 
FROM dockerfile/nodejs
MAINTAINER Michael Klatskin <michael.ecompositor.com>
EXPOSE 443
RUN mkdir /reports

#versions
ENV JDK_RPM jdk-7u67-linux-x64.rpm
ENV JDK_RPM_URL http://download.oracle.com/otn-pub/java/jdk/7u67-b01/
ENV SCALA_TAR_URL http://www.scala-lang.org/files/archive
ENV SCALA_VERSION 2.10.4
ENV SBT_VERSION 0.13.6


RUN sudo apt-get update -y
RUN sudo apt-get install rpm alien -y

#install java
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"  $JDK_RPM_URL/$JDK_RPM 
RUN chmod a+x $JDK_RPM
RUN alien -i $JDK_RPM
RUN rm $JDK_RPM


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


WORKDIR /reports

#COPY data data


RUN sudo apt-get install freetype* -y 

RUN sudo apt-get install httpie* -y 

RUN sudo apt-get install -y  build-essential chrpath git-core libssl-dev libfontconfig1-dev

RUN  \
  wget http://npmjs.org/install.sh | sh && \
  npm install jsreport && \
  npm install nodemailer && \ 
  npm install cron && \
  node node_modules/jsreport --init 

CMD ["node server.js"]
