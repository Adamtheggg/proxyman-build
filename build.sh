#!/usr/bin/env bash
set -euo pipefail
URL=https://github.com/Adamtheggg/proxyman-build/releases/download/v1/com.nsproxy.NSProxy-iOS-26.4.1-eeveedecrypter.ipa
curl -sSL -o in.ipa "$URL"
rm -rf w && mkdir w
unzip -q in.ipa -d w
APP=$(ls -d w/Payload/*.app | head -1)
echo "APP=$APP"
rm -rf "$APP/_CodeSignature" "$APP/SC_Info"
rm -f "$APP/embedded.mobileprovision" "$APP/embedded.provisionprofile"
python3 fix.py "$APP"
cat > entitlements.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>com.apple.developer.networking.networkextension</key><array><string>packet-tunnel-provider</string></array>
<key>com.apple.security.application-groups</key><array><string>group.com.nsproxy.NSProxy-iOS</string></array>
<key>keychain-access-groups</key><array><string>TEAMID.com.nsproxy.NSProxy-iOS</string></array>
<key>get-task-allow</key><true/>
</dict></plist>
EOF
cd w && zip -qry ../Proxyman-clean.ipa Payload && cd ..
cp entitlements.plist Proxyman.entitlements
ls -l Proxyman-clean.ipa Proxyman.entitlements
echo BUILD_OK
