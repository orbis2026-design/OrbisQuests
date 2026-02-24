#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-1.21.8-R0.1-SNAPSHOT}"
GROUP_ID="io.papermc.paper"
ARTIFACT_ID="paper-api"
M2_PATH="$HOME/.m2/repository/io/papermc/paper/paper-api/${VERSION}"
LOCAL_JAR=".paper-cache/${ARTIFACT_ID}-${VERSION}.jar"
LOCAL_POM=".paper-cache/${ARTIFACT_ID}-${VERSION}.pom"

mkdir -p .paper-cache

if [[ -f "${M2_PATH}/${ARTIFACT_ID}-${VERSION}.jar" ]]; then
  echo "paper-api ${VERSION} already installed in local Maven repository."
  exit 0
fi

if [[ ! -f "$LOCAL_JAR" || ! -f "$LOCAL_POM" ]]; then
  echo "Local artifacts not found in .paper-cache/."
  echo "Place these two files first, then rerun:"
  echo "  - $LOCAL_JAR"
  echo "  - $LOCAL_POM"
  echo "Tip: in unrestricted environments you can download from repo.papermc.io."
  exit 2
fi

mvn -q install:install-file \
  -DgroupId="$GROUP_ID" \
  -DartifactId="$ARTIFACT_ID" \
  -Dversion="$VERSION" \
  -Dpackaging=jar \
  -Dfile="$LOCAL_JAR" \
  -DpomFile="$LOCAL_POM"

echo "Installed ${GROUP_ID}:${ARTIFACT_ID}:${VERSION} into local Maven cache."
