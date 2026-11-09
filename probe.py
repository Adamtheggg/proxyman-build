import glob,os,re,sys
app=glob.glob('w/Payload/*.app')[0]
b=open(os.path.join(app,'Proxyman'),'rb').read()
print('ENT_XML', b.find(b'<?xml'))
print('SUPERBLOB', b.find(bytes.fromhex('fade0cc0')))
print('SCINFO', glob.glob('w/**/SC_Info*', recursive=True))
print('CODESIG_DIRS', glob.glob('w/**/_CodeSignature', recursive=True))
print('DYLIB', glob.glob(app+'/Frameworks/*.dylib'))
print('APPEX', glob.glob('w/**/*.appex', recursive=True))
print('FRSIZE', os.path.getsize(app+'/Frameworks/ProxymanCore_iOS.framework/ProxymanCore_iOS') if os.path.exists(app+'/Frameworks/ProxymanCore_iOS.framework/ProxymanCore_iOS') else 'NA')
