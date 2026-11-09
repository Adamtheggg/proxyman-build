import glob,os,plistlib
app=glob.glob('x/Payload/*.app')[0]
print('ROOT',sorted(os.listdir(app)))
cs=os.path.join(app,'_CodeSignature')
print('CSDIR',sorted(os.listdir(cs)) if os.path.isdir(cs) else 'MISSING')
print('ANYPROV',glob.glob('x/**/*provision*',recursive=True))
b=open(os.path.join(app,'Proxyman'),'rb').read()
print('MAGIC',b[:4].hex(),'SIZE',len(b))
print('XML_ENT',b.find(b'<?xml'))
print('EXTS',glob.glob(app+'/**/*.appex',recursive=True))
print('UDID_KEYS',[k for k in plistlib.load(open(os.path.join(app,'Info.plist'),'rb')).keys() if 'NS' in k])
