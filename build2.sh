#!/usr/bin/env bash
set -euo pipefail
URL=https://github.com/Adamtheggg/proxyman-build/releases/download/v1/com.nsproxy.NSProxy-iOS-26.4.1-eeveedecrypter.ipa
curl -sSL -o in.ipa "$URL"
rm -rf w && mkdir w
unzip -q in.ipa -d w
APP=$(ls -d w/Payload/*.app | head -1)
echo "APP=$APP"
# strip every signature in the bundle, deepest first
find w -name '_CodeSignature' -type d -prune -exec rm -rf {} +
find w -name 'SC_Info' -type d -prune -exec rm -rf {} +
find w -name 'embedded.mobileprovision' -delete
find w -name 'embedded.provisionprofile' -delete
find w -name 'CodeResources' -delete
python3 fix.py
echo '--- tree ---'
find "$APP" -maxdepth 2 -name '*.appex'
echo '--- remaining sigs (should be none) ---'
find w -name '_CodeSignature' -o -name 'CodeResources' | head
cd w && zip -qry ../Proxyman-signed-ready.ipa Payload && cd ..
ls -l Proxyman-signed-ready.ipa
echo BUILD_OK
