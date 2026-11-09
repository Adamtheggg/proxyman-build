import glob,os,plistlib
app=glob.glob('w/Payload/*.app')[0]
f=os.path.join(app,'Info.plist')
p=plistlib.load(open(f,'rb'))
p['CFBundleIdentifier']='com.nsproxy.NSProxy-iOS'
plistlib.dump(p,open(f,'wb'),fmt=plistlib.FMT_BINARY)
q=plistlib.load(open(f,'rb'))
print('OK',q['CFBundleIdentifier'],'min',q.get('MinimumOSVersion'))
