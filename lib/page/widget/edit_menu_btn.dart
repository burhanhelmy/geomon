import 'package:flutter/material.dart';

class EditMenuBtn extends StatefulWidget {
  final IconData icon;
  final Function onClick;
  final String label;
  bool selected;

  EditMenuBtn(this.icon, this.label, this.onClick, this.selected);

  @override
  _EditMenuBtnState createState() => _EditMenuBtnState();
}

class _EditMenuBtnState extends State<EditMenuBtn> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          widget.onClick();
        },
        child: Ink(
          padding: EdgeInsets.all(5),
          width: 70,
          child: Column(
            children: <Widget>[
              Icon(widget.icon,
                  color: widget.selected ? theme.primaryColor : Colors.grey),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.label,
                  style: TextStyle(
                      color:
                          widget.selected ? theme.primaryColor : Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
