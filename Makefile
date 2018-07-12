app:

install: app
	cp app $(PREFIX)/bin/app
	chmod +x $(PREFIX)/bin/app

uninstall:
	rm -f $(PREFIX)/bin/app

.PHONY: install uninstall
