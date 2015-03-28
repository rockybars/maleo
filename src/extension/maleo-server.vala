[DBus (name = "id.blankon.Maleo")]
public class MaleoServer : Object {
  private WebKit.WebPage page;
  unowned Seed.Engine engine;

  [DBus (visible = false)]
  public void on_bus_acquired(DBusConnection connection) {
    try {
      connection.register_object("/id/blankon/maleo", this);
    } catch (IOError error) {
      warning("Could not register service: %s", error.message);
    }   
  }

  [DBus (visible = false)]
  public void on_page_created(WebKit.WebExtension extension, WebKit.WebPage page) {
    var world = WebKit.ScriptWorld.get_default();
    world.window_object_cleared.connect((the_world, the_page, the_frame) => {
      unowned Seed.GlobalContext ctx = 
	(Seed.GlobalContext) the_frame.get_javascript_context_for_script_world(world);
      engine = Seed.init_with_context(0, "", ctx);
    });
  }
}

[DBus (name = "id.blankon.Maleo")]
public errordomain MaleoServerError {
  ERROR
}

[CCode (cname = "G_MODULE_EXPORT webkit_web_extension_initialize", instance_pos = -1)]
void webkit_web_extension_initialize(WebKit.WebExtension extension) {
  MaleoServer server = new MaleoServer();
  extension.page_created.connect(server.on_page_created);
  Bus.own_name(BusType.SESSION, "id.blankon.Maleo", BusNameOwnerFlags.NONE, 
    server.on_bus_acquired, null, () => { warning("Could not acquire name"); }
  );
}
