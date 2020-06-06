import 'package:flutter/material.dart';

class RadiusSlider extends StatefulWidget {
  double value = 0;
  @override
  _RadiusSliderState createState() => _RadiusSliderState();
}

class _RadiusSliderState extends State<RadiusSlider> {
  @override
  Widget build(BuildContext context) {
    _radiusText() {
      return Container(
          width: 80,
          padding: EdgeInsets.only(right: 8.0),
          child: Text(
            '${(widget.value * 100).roundToDouble()} KM',
            textAlign: TextAlign.center,
          ));
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Slider(
                value: widget.value,
                onChanged: (double value) {
                  setState(() {
                    widget.value = value;
                  });
                },
              ),
            ),
            _radiusText()
          ],
        ));
  }
}
