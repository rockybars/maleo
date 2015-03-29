PKGS=--pkg gtk+-3.0 --pkg gobject-introspection-1.0 --pkg seed
LIB_BASE=maleo-server
LIB_SOURCES=$(LIB_BASE).vala
LIBRARY=$(LIB_BASE).so
EXT_VAPI=--vapidir=./vapi
WEBKIT_EXT_VAPI=--pkg webkit2gtk-web-extension-4.0

$(LIBRARY): $(LIB_SOURCES)
	valac $(WEBKIT_EXT_VAPI) $(EXT_VAPI) $(PKGS) --library=$(LIB_BASE) -X -fPIC -X -shared -o $@ $^
ccode: $(LIB_SOURCES)
	valac --ccode $(WEBKIT_EXT_VAPI) $(EXT_VAPI) $(PKGS) --library=$(LIB_BASE) -X -fPIC -X -shared -o $@ $^
clean: 
	rm -fr $(LIBRARY) $(LIB_BASE).vapi
