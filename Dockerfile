# jsreport 
FROM dockerfile/nodejs
MAINTAINER Michael Klatskin <michael.ecompositor.com>
EXPOSE 443
RUN mkdir /reports

WORKDIR /reports

#COPY data data

RUN sudo apt-get update -y

RUN sudo apt-get install freetype* -y 

RUN sudo apt-get install -y  build-essential chrpath git-core libssl-dev libfontconfig1-dev

RUN  \
  git clone https://github.com/dilshod/xlsx2csv.git && \
  wget http://npmjs.org/install.sh | sh && \
  npm install jsreport && \
  npm install nodemailer && \ 
  npm install cron && \
  node node_modules/jsreport --init 

CMD ["node server.js"]
