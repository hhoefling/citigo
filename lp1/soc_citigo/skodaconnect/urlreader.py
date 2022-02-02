
import os
import json
import pprint


class Reader:
		dirname=""
		dodump=False
		debug=0
		pp=None
		
		def __init__(self,adebug, adodump,adirname):
			self.dodump=adodump
			self.dirname=adirname
			self.debug=adebug
			print(f"Reader debug:{adebug} dodump:{adodump}, pfad:[{adirname}] ")
			self.pp=pprint.PrettyPrinter(width=128, compact=True)
            
		def	deb(self, str):
			if self.debug>0:
				print(f"Reader: {str}")
		

		def	mkdirifneeded(self):
			if self.dirname!="":
				if not os.path.exists(self.dirname):
					os.mkdir(self.dirname)
					self.deb(f"{self.dirname} angelegt ")
				else:
					self.deb(f"{self.dirname} exists ")
			else:
				self.deb(f"kein Path")


		def dumpdata(self, areq, aurl, adata):
			self.deb(f"get url {aurl} ")
			print(areq.status, areq._real_url)
			fxx="".join(x for x in aurl.replace("https://","").replace("/", "#") if x.isprintable())
			fn=f"{self.dirname}/{fxx}.req"
			fo=open(fn, 'w')
			fo.write( self.pp.pformat(areq))
			fo.close()
			print(f"written to {fn}")
			
			fn=f"{self.dirname}/{fxx}.data"
			fo=open(fn, 'w')
			fo.write(self.pp.pformat(adata))
			fo.close()
			print(f"written to {fn}")

		def dump(self, areq, aurl):
			self.deb(f"get url {aurl} ")
			print(areq.status, areq._real_url)
			
			fxx="".join(x for x in aurl.replace("https://","").replace("/", "#") if x.isprintable())
			fn=f"{self.dirname}/{fxx}.req"
			fo=open(fn, 'w')
			fo.write( self.pp.pformat(areq))
			fo.close()
			print(f"written to {fn}")


R = None;

          