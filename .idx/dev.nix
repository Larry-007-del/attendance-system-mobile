{ pkgs, ... }: {
  channel = "stable-23.11";
  packages = [
    pkgs.jdk17
    pkgs.flutter
    pkgs.unzip
    pkgs.zip
  ];
  env = {};
  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    previews = {
      enable = true;
      previews = {
        android = {
          command = ["flutter" "run" "--machine" "-d" "android" "-d" "localhost:5555"];
          manager = "flutter";
        };
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
      };
    };
  };
}
