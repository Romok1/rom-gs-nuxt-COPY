FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client

# Define versions
ENV NVM_VERSION=0.25.4
ENV NODE_VERSION=12.18.3
ARG BUNDLER_VERSION=2.3.18
ENV BUNDLER_VERSION=${BUNDLER_VERSION}

# Install nvm with node and npm
ENV NVM_DIR=/root/.nvm
RUN mkdir -p $NVM_DIR
RUN /bin/bash -l -c "curl -L https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash  && source $NVM_DIR/nvm.sh"
RUN /bin/bash -l -c "source $NVM_DIR/nvm.sh \
                    && nvm install $NODE_VERSION \
                    && nvm alias default $NODE_VERSION \
                    && nvm use default \
                    && npm install -g yarn && npm g puppeteer"

# Export NODE_PATH
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
# Update PATH to make node/npm accessible
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN gem install bundler -v ${BUNDLER_VERSION} --no-document

RUN mkdir /encore
WORKDIR /encore

COPY Gemfile /encore/Gemfile
COPY Gemfile.lock /encore/Gemfile.lock
RUN bundle _${BUNDLER_VERSION}_ install -j 4


COPY package*.json yarn.lock ./
RUN yarn install

#COPY config/database-jenkinsci.yml /encore/config/database.yml

#ARG rails_master_key
#RUN RAILS_MASTER_KEY=$rails_master_key

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
 
ADD . /encore

CMD ["rails","server","-b","0.0.0.0"]
