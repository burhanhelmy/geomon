import 'package:flutter/material.dart';
import 'package:geomon/page/home/provider/home_provider.dart';
import 'package:geomon/page/home/widget/edit_menu_btn.dart';
import 'package:geomon/page/home/widget/radius_slider.dart';
import 'package:provider/provider.dart';

class BottomDrawer extends StatefulWidget {
  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    _colorIndicator() {
      var indicatorColor;

      switch (homeProvider.status) {
        case GeofenceLocationStatus.inside:
          indicatorColor = Colors.green;
          break;
        case GeofenceLocationStatus.outside:
          indicatorColor = Colors.orange;
          break;
        default:
          indicatorColor = Colors.grey;
      }

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: AnimatedContainer(
          height: 18,
          width: 5,
          color: indicatorColor,
          duration: Duration(seconds: 2),
        ),
      );
    }

    _mainMenu() {
      return Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(children: [
                      Icon(
                        Icons.rss_feed,
                        size: 15,
                      ),
                      Text(
                        'Status',
                      )
                    ]),
                    Row(children: [
                      _colorIndicator(),
                      Text(homeProvider.status, style: textTheme.headline5)
                    ]),
                  ],
                ),
                RaisedButton(
                  textColor: Colors.white,
                  color: theme.primaryColor,
                  onPressed: () {
                    homeProvider.editArea();
                  },
                  child: Text('EDIT AREA'),
                )
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'GEOM',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  'O',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'N',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      );
    }

    _editMenu() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    EditMenuBtn(Icons.delete_outline, 'Clear Area', () {
                      homeProvider.clearMonitorArea();
                    },
                        homeProvider.bottomDrawerEditMenuState ==
                            BottomDrawerEditMenuState.DELETE),
                  ],
                ),
                Column(
                  children: <Widget>[
                    EditMenuBtn(Icons.location_on, 'Pin Location', () {
                      homeProvider.bottomDrawerEditMenuState =
                          BottomDrawerEditMenuState.PIN;
                    },
                        homeProvider.bottomDrawerEditMenuState ==
                            BottomDrawerEditMenuState.PIN),
                  ],
                ),
                Column(
                  children: <Widget>[
                    EditMenuBtn(Icons.zoom_out_map, 'Set Radius', () {
                      homeProvider.bottomDrawerEditMenuState =
                          BottomDrawerEditMenuState.RADIUS;
                    },
                        homeProvider.bottomDrawerEditMenuState ==
                            BottomDrawerEditMenuState.RADIUS),
                  ],
                )
              ],
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  homeProvider.saveMonitorArea();
                },
                child: Text(
                  'Save',
                ),
              ),
              FlatButton(
                onPressed: () {
                  homeProvider.restoreMonitorArea();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.errorColor),
                ),
              ),
            ],
          ),
        ],
      );
    }

    _getCurrentLocationFab() {
      return FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.gps_fixed,
            color: Colors.black,
          ),
          onPressed: () {
            homeProvider.onfocusCurrentLocation();
          });
    }

    _topWidget() {
      if (homeProvider.bottomDrawerMenuState == BottomDrawerMenuState.VIEW) {
        return _getCurrentLocationFab();
      }
      if (homeProvider.bottomDrawerEditMenuState ==
          BottomDrawerEditMenuState.RADIUS) {
        return RadiusSlider();
      } else {}
      return Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(8.0), child: _topWidget()),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          height: MediaQuery.of(context).size.height / 3.5,
          child:
              homeProvider.bottomDrawerMenuState == BottomDrawerMenuState.VIEW
                  ? _mainMenu()
                  : _editMenu(),
        ),
      ],
    );
  }
}
