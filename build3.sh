#!/usr/bin/env bash
set -euo pipefail
URL=https://github.com/Adamtheggg/proxyman-build/releases/download/v1/com.nsproxy.NSProxy-iOS-26.4.1-eeveedecrypter.ipa
curl -sSL -o in.ipa "$URL"
rm -rf w w2 && mkdir w w2
unzip -q in.ipa -d w
APP=$(ls -d w/Payload/*.app | head -1)
# variant A: keep extensions, strip every signature
find w -name '_CodeSignature' -type d -prune -exec rm -rf {} +
find w -name 'SC_Info' -type d -prune -exec rm -rf {} +
find w -name 'CodeResources' -delete
find w -name 'embedded.mobileprovision' -delete
python3 fix.py
cp -r w/Payload w2/
cd w && zip -qry ../A-with-plugins.ipa Payload && cd ..
# variant B: strip signatures AND remove PlugIns entirely
rm -rf w2/Payload/*.app/PlugIns
python3 -c "import plistlib,glob;p=glob.glob('w2/Payload/*.app/Info.plist')[0];d=plistlib.load(open(p,'rb'));print('had PlugIns key:', 'PlugIns' in d)"
cd w2 && zip -qry ../B-no-plugins.ipa Payload && cd ..
cat > bare-entitlements.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>get-task-allow</key><true/>
</dict></plist>
EOF
ls -l A-with-plugins.ipa B-no-plugins.ipa bare-entitlements.plist
echo DONE
