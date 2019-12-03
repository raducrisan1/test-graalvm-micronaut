FROM adoptopenjdk/openjdk8-openj9:alpine-slim as BUILD_IMAGE
ENV APP_HOME=/root/dev/app
RUN mkdir -p ${APP_HOME}/src/main/java
WORKDIR ${APP_HOME}
COPY build.gradle gradlew gradlew.bat gradle.properties ${APP_HOME}/
COPY gradle ${APP_HOME}/gradle
RUN ./gradlew build -x :shadowJar -x test --continue
COPY . .
RUN ./gradlew build

FROM oracle/graalvm-ce:19.2.1 as graalvm
RUN mkdir -p /home/app/test-graalvm
COPY --from=BUILD_IMAGE /root/dev/app/build/libs/test-graalvm-*-all.jar /home/app/test-graalvm
WORKDIR /home/app/test-graalvm
RUN gu install native-image
RUN native-image --no-server -cp test-graalvm-*-all.jar

FROM frolvlad/alpine-glibc as final
EXPOSE 8080
COPY --from=graalvm /home/app/test-graalvm .
ENTRYPOINT ["./test-graalvm"]
