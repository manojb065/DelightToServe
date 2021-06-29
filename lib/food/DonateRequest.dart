import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:location/location.dart';

class ReqList extends StatefulWidget {
  @override
  _ReqListState createState() => _ReqListState();
}

class _ReqListState extends State<ReqList> {
  List<Widget> list = new List<Widget>.empty(growable: true);

  late double lat, long;
  static void _showDirection(double lat, double long) async {
    bool flag = await MapLauncher.isMapAvailable(MapType.google) as bool;
    Location location = new Location();
    // _locData =
    await location.getLocation().then((value) {
      lat = value.latitude!;
      long = value.longitude!;
    });
    await MapLauncher.showDirections(
        mapType: MapType.google,
        destination: Coords(lat, long),
        origin: Coords(lat, long));
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('foodrequest')
        .where("name",
            isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Colors.amber[700],
          );
        }

        return new ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          var d = DateTime.fromMicrosecondsSinceEpoch(
              data['time'].microsecondsSinceEpoch);

          String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(d);
          return new ListTile(
            // onTap: () {
            //   print("${data['aname']} got selected");
            //   if (data['status']) {
            //     Navigator.of(context).pushNamed("/track");
            //   }
            // },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                data["status"] == false
                    ? const Tooltip(
                        message: "pending", child: Icon(Icons.pending_actions))
                    : const Tooltip(
                        message: "accepted",
                        child: Icon(Icons.assignment_turned_in_rounded),
                      ),
                // Icon(Icons.assignment_turned_in_rounded),
                if (data["status"])
                  IconButton(
                    icon: Icon(Icons.directions),
                    tooltip: "directions",
                    onPressed: () async {
                      print("pressed direction button");
                      try {
                        final availableMaps = await MapLauncher.installedMaps;
                        print(availableMaps);
                      } catch (e) {
                        print(e);
                      }
                      bool flag =
                          await MapLauncher.isMapAvailable(MapType.google)
                              as bool;
                      Location location = new Location();
                      // _locData =
                      await location
                          .getLocation()
                          .then((value) => print(value));
                      await MapLauncher.showDirections(
                          mapType: MapType.google,
                          destination: Coords(data["lat"], data["long"]),
                          directionsMode: DirectionsMode.driving);
                      // _showDirection(data["lat"], data["long"]);
                    },
                  ),
              ],
            ),
            tileColor: Colors.deepOrangeAccent[600],
            selectedTileColor: Colors.cyanAccent,
            title: new Text("${data.values.elementAt(1)}"),
            subtitle: new Text("Date $formattedDate "),
          );
        }).toList());
      },
    );
  }
}
