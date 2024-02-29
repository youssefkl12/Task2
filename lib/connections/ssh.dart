import 'package:dartssh2/dartssh2.dart';

import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  SSHClient? _client;

  // Initialize connection details from shared preferences
  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  // Connect to the Liquid Galaxy system
  Future<bool?> connectToLG() async {
    await initConnectionDetails();

    try {
      final socket = await SSHSocket.connect(_host, int.parse(_port));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );
      print('$_host,  $_passwordOrKey,  $_username,  $_port');

      return true;
    } on SocketException catch (e) {
      print('Failed to connect: $e');
      return false;
    }
  }

  Future<SSHSession?> execute() async {
    final stringTest = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Placemark>
    <name>Simple placemark</name>
    <description>Attached to the ground. Intelligently places itself 
       at the height of the underlying terrain.</description>
    <Point>
      <coordinates>-122.0822035425683,37.42228990140251,0</coordinates>
    </Point>
  </Placemark>
</kml>''';
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final resultExct = await _client!.execute(
          'echo "flytoview=<gx:duration>1</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>31.244046</longitude><latitude>29.996211</latitude><range>5000</range><tilt>60</tilt><heading>180</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>" > /tmp/query.txt');


      return resultExct;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  // DEMO above, all the other functions below
  Future<SSHSession?> relauchLG() async {
    try {
      if (_client == null) {
        print("SSH client not intialized");
        return null;
      }
      final excuResult = await _client!.execute("""RELAUNCH_CMD="\\
if [ -f /etc/init/lxdm.conf ]; then
  export SERVICE=lxdm
elif [ -f /etc/init/lightdm.conf ]; then
  export SERVICE=lightdm
else
  exit 1
fi
if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
  echo $_passwordOrKey | sudo -S service \\\${SERVICE} start
else
  echo $_passwordOrKey | sudo -S service \\\${SERVICE} restart
fi
" && sshpass -p $_passwordOrKey ssh -x -t lg@lg1 "\$RELAUNCH_CMD\"""");
      print("re launch command sent ");
      return excuResult;
    } catch (e) {
      print("error occured");
      return null;
    }
  }

  uploadKml(File inputFile, String filename) async {
    final sftp = await _client?.sftp();
    double anyKindofProgressBar;
    final file = await sftp?.open('/var/www/html/$filename',
        mode: SftpFileOpenMode.create |
            SftpFileOpenMode.truncate |
            SftpFileOpenMode.write);
    var fileSize = await inputFile.length();
    await file?.write(inputFile.openRead().cast(), onProgress: (progress) {
      anyKindofProgressBar = progress / fileSize;
    });
  }

  Future<SSHSession?> goHome() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final resultExct =
          await _client!.execute('echo "search=Cairo" > /tmp/query.txt');

      return resultExct;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> Orbithome() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final resultExct = await _client!.execute(
          'echo "flytoview=<gx:duration>1</gx:duration><gx:flyToMode>smooth</gx:flyToMode><LookAt><longitude>31.244046</longitude><latitude>29.996211</latitude><range>5000</range><tilt>60</tilt><heading>180</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>" > /tmp/query.txt');

      return resultExct;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> reboot() async {
    print("reboot testing");
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      // final resultExct=await _client!.execute('echo "search=Street 15, Maadi as Sarayat Al Gharbeyah, Maadi, Cairo Governorate 4212006" > /tmp/query.txt');
      final resultExct2 = await _client!.execute(
          'sshpass -p $_passwordOrKey ssh -t lg2 "echo $_passwordOrKey | sudo -S reboot"');
      final resultExct3 = await _client!.execute(
          'sshpass -p $_passwordOrKey ssh -t lg3 "echo $_passwordOrKey | sudo -S reboot"');
      final resultExct = await _client!.execute(
          'sshpass -p $_passwordOrKey ssh -t lg1 "echo $_passwordOrKey | sudo -S reboot"');
      print("excution ok");
      return resultExct;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> kmlLogo() async {
    final KML = '''
<kml xmlns="http://www.opengis.net/kml/2.2"
     xmlns:gx="http://www.google.com/kml/ext/2.2"
     xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <Folder>
      <name>Logos</name>
      <ScreenOverlay>
        <name>Logos</name>
        <Icon>
          <href>https://raw.githubusercontent.com/youssefkl12/images/main/logo.png</href>
        </Icon>
        <!-- Center the overlay on the screen -->
        <overlayXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
        <screenXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
      </ScreenOverlay>
    </Folder>
  </Document>
</kml>

''';
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final resultExct =
          await _client!.execute("echo '$KML' > /var/www/html/kml/slave_2.kml");
      print(
          "chmod 777 /var/www/html/kml.txt; echo '$KML' > /var/www/html/kml/slave_2.kml");
      return resultExct;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<SSHSession?> clearKML() async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      final resultExct =
          await _client!.execute("echo '' > /var/www/html/kml/slave_2.kml");
      final resultExct3 =
          await _client!.execute("echo '' > /var/www/html/kml/slave_3.kml");

      return resultExct;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }
}
