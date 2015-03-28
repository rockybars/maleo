[DBus (name = "id.blankon.Maleo")]
interface MaleoMessenger : Object {}

class WebView : WebKit.WebView {
  public WebView(ConfigXML config) {
    Bus.watch_name(BusType.SESSION, "id.blankon.Maleo", BusNameWatcherFlags.NONE, 
      (connection, name, owner) => { on_extension_appeared(connection, name, owner);},
      null
    );
    var settings = get_settings();
    settings.set("javascript-can-open-windows-automatically", true);
    // FIXME: load from universal uris, even handling a custom uri
    load_uri("file://" + config.directory + "/" + config.content);
  }

  private void on_extension_appeared(DBusConnection connection, string name, string owner) {
    // FIXME: handle when the extension properly appeared
  }
}
