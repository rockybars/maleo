[DBus (name = "id.blankon.Maleo")]
public class MaleoServer : Object {
  [DBus (visible = false)]
  public void on_bus_acquired(DBusConnection connection) {
    try {
      connection.register_object("/id/blankon/maleo", this);
    } catch (IOError error) {
      warning("Could not register service: %s", error.message);
    }   
  }

  private static unowned Seed.Value maleo_version(
    Seed.Context ctx,
    Seed.Object function,
    Seed.Object this_object,
    size_t argc,
    Seed.Value[] argv,
    Seed.Exception exception) {
      // FIXME: get from Utils.vala, take out the constants to another file
      unowned Seed.Value version = Seed.Value.from_string(ctx, "2.0.0", null);
      (unowned Seed.Value)[] version_args = {version};
      if (argc > 0 && Seed.Value.is_function(ctx, (Seed.Object) argv[0]))
      	Seed.Object.call(ctx, (Seed.Object) argv[0], this_object, version_args, null);
      return Seed.Value.from_int64(ctx, argc, null);
  } 

  [DBus (visible = false)]
  public void on_page_created(WebKit.WebExtension extension, WebKit.WebPage page) {
    WebKit.ScriptWorld.get_default().window_object_cleared.connect((the_world, the_page, the_frame) => {
      unowned Seed.GlobalContext ctx = 
	(Seed.GlobalContext) the_frame.get_javascript_context_for_script_world(the_world);
      unowned Seed.Engine engine = Seed.init_with_context(null, ctx);
      // test
      Seed.create_function((Seed.Context) engine.context, "maleoVersion", (Seed.FunctionCallback) MaleoServer.maleo_version, (Seed.Object) engine.global);
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
