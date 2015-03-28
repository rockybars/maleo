class MainWindow : Gtk.ApplicationWindow {
  public MainWindow (Gtk.Application app_context, ConfigXML config) {
    Object(application: app_context);
    setup(config);
  }

  private void setup(ConfigXML config) {
    set_default_size(config.width > 0 ? config.width : 600, config.height > 0 ? config.height : 400);
    title = config.title.strip();

    WebKit.WebContext.get_default().set_web_extensions_directory("./");
    var webView = new WebView(config);
    var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
    box.pack_start(webView, true, true);
    add(box);
  }
}
