# ruelala android

FROM aws/codebuild/android-8:latest
 
ENV ANDROID_HOME="/usr/local/android-sdk-linux" \
    JAVA_HOME="/usr/lib/jvm/java-8-oracle" \
    JDK_HOME="/usr/lib/jvm/java-8-oracle" \
    JAVA_VERSION="8" \
    INSTALLED_GRADLE_VERSIONS="4.1" \
    GRADLE_VERSION="4.1" 
ENV PATH="${PATH}:/opt/tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools"

# Install java8
RUN apt-get update \
# Precache most relevant versions of Gradle for `gradlew` scripts
      && mkdir -p /usr/src/gradle \
      && for version in $INSTALLED_GRADLE_VERSIONS; do {\
           wget "https://services.gradle.org/distributions/gradle-$version-all.zip" -O "/usr/src/gradle/gradle-$version-all.zip" \
           && unzip "/usr/src/gradle/gradle-$version-all.zip" -d /usr/local \
           && mkdir "/tmp/gradle-$version" \
           && "/usr/local/gradle-$version/bin/gradle" -p "/tmp/gradle-$version" wrapper \
           # Android Studio uses the "-all" distribution for it's wrapper script.
           && perl -pi -e "s/gradle-$version-bin.zip/gradle-$version-all.zip/" "/tmp/gradle-$version/gradle/wrapper/gradle-wrapper.properties" \
           && "/tmp/gradle-$version/gradlew" -p "/tmp/gradle-$version" init \
           && rm -rf "/tmp/gradle-$version" \
           && if [ "$version" != "$GRADLE_VERSION" ]; then rm -rf "/usr/local/gradle-$version"; fi; \
         }; done \
# Install default GRADLE_VERSION to path
      && ln -sf /usr/local/gradle-$GRADLE_VERSION/bin/gradle /usr/bin/gradle \
      && rm -rf /usr/src/gradle \
	  && /opt/tools/android-accept-licenses.sh "android update sdk --all --no-ui --filter android-26" \
    && /opt/tools/android-accept-licenses.sh "android update sdk --all --no-ui --filter build-tools-26.0.2"
