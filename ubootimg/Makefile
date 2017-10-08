
bootimg = boot.img

all:
	$(MAKE) clean
	cp ../base/bl1-nanopi.bin $(bootimg)
	./gen-nsih.sh | xxd -r -p | dd of=$(bootimg) seek=63 status=none
	cat ../base/u-boot.bin >>$(bootimg)

clean:
	rm -f $(bootimg)
