import 'package:flutter/material.dart';
import 'package:geomon/page/widget/edit_menu_btn.dart';
import 'package:geomon/page/widget/radius_slider.dart';

enum BottomDrawerMenuState { VIEW, EDIT }
enum BottomDrawerEditMenuState { PIN, RADIUS }

class BottomDrawer extends StatefulWidget {
  BottomDrawerMenuState menuState = BottomDrawerMenuState.VIEW;
  BottomDrawerEditMenuState editMenuState = BottomDrawerEditMenuState.PIN;
  @override
  _BottomDrawerState createState() => _BottomDrawerState();
}

class _BottomDrawerState extends State<BottomDrawer> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    _colorIndicator() {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 20,
          width: 5,
          color: Colors.green,
        ),
      );
    }

    _mainMenu() {
      return Row(
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
                Text('INSIDE', style: textTheme.headline5)
              ]),
            ],
          ),
          RaisedButton(
            textColor: Colors.white,
            color: theme.primaryColor,
            onPressed: () {
              setState(() {
                widget.menuState = BottomDrawerMenuState.EDIT;
              });
            },
            child: Text('EDIT AREA'),
          )
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
                    EditMenuBtn(Icons.location_on, 'Pin Location', () {
                      setState(() {
                        widget.editMenuState = BottomDrawerEditMenuState.PIN;
                      });
                    }, widget.editMenuState == BottomDrawerEditMenuState.PIN),
                  ],
                ),
                Column(
                  children: <Widget>[
                    EditMenuBtn(Icons.zoom_out_map, 'Set Radius', () {
                      setState(() {
                        widget.editMenuState = BottomDrawerEditMenuState.RADIUS;
                      });
                    },
                        widget.editMenuState ==
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
                onPressed: () {},
                child: Text(
                  'Save',
                ),
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    widget.menuState = BottomDrawerMenuState.VIEW;
                  });
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
          onPressed: () {});
    }

    _topWidget() {
      if (widget.menuState == BottomDrawerMenuState.VIEW) {
        return _getCurrentLocationFab();
      }
      if (widget.editMenuState == BottomDrawerEditMenuState.RADIUS) {
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
          padding: EdgeInsets.all(20),
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
          height: MediaQuery.of(context).size.height / 4,
          child: widget.menuState == BottomDrawerMenuState.VIEW
              ? _mainMenu()
              : _editMenu(),
        ),
      ],
    );
  }
}
