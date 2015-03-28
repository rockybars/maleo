namespace Maleo {
  const string APP_NAME = "Maleo";
  const string APP_SYS_NAME = "maleo";
  const string APP_ID = "id.blankon.maleo";
  const string APP_VERSION = "2.0.0";

  public class Utils {
    public static ConfigXML? configFromArgs(string[] args) {
      string path = args.length > 1 ? args[1] : ".";
      File file = File.new_for_path(path);
      path = file.get_path();
      bool exists = file.query_exists();
      
      if (!exists) {
        return null;
      }

      FileType type = file.query_file_type(FileQueryInfoFlags.NOFOLLOW_SYMLINKS);
      if (type != FileType.DIRECTORY) {
        return null;
      }

      file = File.new_for_path(path + "/config.xml");
      exists = file.query_exists();

      if (!exists) {
        return null;
      }

      return new ConfigXML(path);
    }
  }
}
