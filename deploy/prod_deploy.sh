#!/bin/bash

GIT_REVISION_HASH=$(git rev-parse HEAD)
GIT_USER=$(git config user.name) # Get username from your console

function migrate_start () {
  echo " :: Migrate PRODUCTION database"
  mix edeliver start production


  if [ $? -eq 0 ]; then
    echo " :: Start PRODUCTION server"
    mix edeliver migrate production

    if [ $? -eq 0 ]; then
      echo " :: Production deployed and started!"
    else
      echo "[ERROR] :: Migrating!"
    fi

  else
    echo "[ERROR] :: Starting!"
  fi
}


# Check info before release
echo " --- Production Information --- "
mix edeliver ping production
mix edeliver version production

echo " Do you want to continue with the deploy [Y/n] ?"
read response

if [ "$response" == "Y" ]; then

  echo "Do you want to upgrade current version [upgrade] or create a new release [release] ?"
  read deploy_type

  if [ "$deploy_type" == "upgrade" ]; then

    echo "Current version in PROD: "
    read current_version

    echo "NEW version to deploy to PROD:"
    read new_version

    # Crease a release
    echo " :: Building upgrade ... "

    # UPGRADE
    mix edeliver build upgrade --from=${current_version} --to=${new_version}

    if [ $? -eq 0 ]; then

      mix edeliver deploy upgrade to production

      if [ $? -eq 0 ]; then
        migrate_start

      else
        echo "[ERROR] :: Deploying!"
      fi

    else
      echo "[ERROR] :: Building!"
    fi

  elif [ "$deploy_type" == "release" ]; then
    mix edeliver build release

    if [ $? -eq 0 ]; then
      mix edeliver deploy release to production

      if [ $? -eq 0 ]; then
        mix edeliver stop production
        migrate_start

      else
        echo "[ERROR] :: Deploying!"
      fi
    else
      echo "[ERROR] :: Building!"
    fi

  else
    echo "[ERROR] :: Invalid deploy type! [${deploy_type}]"
  fi

else
  echo "[ABORT] :: Deploy abort by user!"
fi