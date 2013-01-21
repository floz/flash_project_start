
DEST = /usr/local
DEST_BIN = $(DEST)/bin/
DEST_ACTION = $(DEST)/lib/mmp/flash/
DEST_PROJECT = $(DEST)/include/mmp/flash/

install:
	mkdir -p $(DEST_BIN)
	cp -fr ./mmpflash $(DEST_BIN)
	mkdir -p $(DEST_ACTION)
	cp -fr ./action	$(DEST_ACTION)
	mkdir -p $(DEST_PROJECT)
	cp -fr ./mmp_project $(DEST_PROJECT)

test:
	mmpflash -h