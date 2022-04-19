#!/bin/bash
TAG=$1

# copy .next package
rm -rf app-package
mkdir app-package
cp -r .next app-package
cp -r pages app-package
cp -r components app-package
cp -r _posts app-package
cp -r lib app-package
cp -r node_modules app-package
cp package.json app-package
cp -r public app-package
cp -r styles app-package
cp postcss.config.js app-package
cp tailwind.config.js app-package

# install packages
cd  app-package
yarn

# zip packages
zip -qr ../app-package-$TAG.zip .next/ node_modules/ src/ next.config.js package.json
cd ..
openssl dgst -sha256 -binary app-package-$TAG.zip | openssl enc -base64 | tr -d "\n" > app-package-$TAG.zip.base64sha256

# Clean up
rm -rf app-package
