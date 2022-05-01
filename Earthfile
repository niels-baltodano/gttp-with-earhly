VERSION 0.5
FROM niels58/graalvm-cmp:v1
WORKDIR /save

build:
  ENV USER_NAME="user"
  ENV JAVA_HOME="/home/$USER_NAME/.sdkman/candidates/java/current"
  ENV GROOVY_HOME="/home/$USER_NAME/.sdkman/candidates/groovy/current"
  ENV GROOVY_VERSION="3.0.5"
  ENV PATH="$GROOVY_HOME/bin:$JAVA_HOME/bin:$PATH"
  COPY gttp.groovy .
  RUN  groovyc --compile-static gttp.groovy && \
      timeout 3s java -agentlib:native-image-agent=config-output-dir=./conf/ -cp ".:$GROOVY_HOME/lib/groovy-$GROOVY_VERSION.jar" gttp 2>&1 || true
  RUN native-image --allow-incomplete-classpath \
  --report-unsupported-elements-at-runtime \
  --initialize-at-build-time \
  --initialize-at-run-time=org.codehaus.groovy.control.XStreamUtils \
  --no-fallback \
  --no-server \
  -H:ConfigurationFileDirectories=./conf/ \
  -H:+ReportExceptionStackTraces \
  -cp ".:$GROOVY_HOME/lib/groovy-3.0.5.jar" gttp
  RUN ls -lha && \
      chmod a+x gttp
  SAVE ARTIFACT gttp AS LOCAL gttp
docker:
  FROM debian:stretch-slim
  COPY +build/gttp .
  ENTRYPOINT ["/gttp"]
  SAVE IMAGE niels58/graalvm-gttp:v1