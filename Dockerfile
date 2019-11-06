FROM jekyll/jekyll
ENV JEKYLL_ENV=development
COPY --chown=jekyll:jekyll Gemfile .
COPY --chown=jekyll:jekyll Gemfile.lock .

RUN bundle install --quiet --clean
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["jekyll", "serve"]
