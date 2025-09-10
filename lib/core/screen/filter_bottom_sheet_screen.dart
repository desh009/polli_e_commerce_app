import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool filter1 = false;
  bool filter2 = false;
  bool filter3 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text("Filter Options", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: Text("Filter 1"),
            value: filter1,
            onChanged: (val) {
              setState(() {
                filter1 = val!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Filter 2"),
            value: filter2,
            onChanged: (val) {
              setState(() {
                filter2 = val!;
              });
            },
          ),
          CheckboxListTile(
            title: Text("Filter 3"),
            value: filter3,
            onChanged: (val) {
              setState(() {
                filter3 = val!;
              });
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter1 = false;
                    filter2 = false;
                    filter3 = false;
                  });
                },
                child: Text("Clear"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Apply"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
