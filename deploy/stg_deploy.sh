#!/bin/bash

if [ $? -eq 0 ]; then
  echo "CI Branch: $CI_BRANCH"
  echo "CI Pull Request: $CI_PULL_REQUEST"
  DEPLOY_BRANCH="staging"

  if [ "$CI_BRANCH" == "$DEPLOY_BRANCH" ] && [ "$CI_PULL_REQUEST" == "false" ]; then
    # Hot swap need to know what is the current version
    echo " :: Edeliver: Build"

    #mix edeliver build upgrade
    mix edeliver build release --branch=$DEPLOY_BRANCH

    if [ $? -eq 0 ]; then
      echo " :: [INFO] Successfully created build file!"

      echo " :: Edeliver: Deploy"
      #mix edeliver deploy upgrade
      mix edeliver deploy release --start-deploy --branch=$DEPLOY_BRANCH

      echo " :: Edeliver: Migrate"
      mix edeliver migrate --branch=$DEPLOY_BRANCH

      exit 0
    else
      echo " :: [ERROR] Could not create file"
      exit 1
    fi
  fi
else
  echo "Failed build!"
  exit 1
fi
