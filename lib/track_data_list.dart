import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_application/store_data.dart';

import 'background_service.dart';

class TrackData extends StatefulWidget {
  const TrackData({super.key});

  @override
  State<TrackData> createState() => _TrackDataState();
}

class _TrackDataState extends State<TrackData> {
  List<UserInfo> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isLoading = true;
      await StoreDataLocally.deleteData();
      data = await StoreDataLocally.loadDataList();
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Data list",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          elevation: 5,
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].name),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data[index].lat),
                        Text(data[index].lng),
                      ],
                    ),
                    onTap: (){},
                  );
                }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){},
          label: const Text("Map"),
        icon: const Icon(CupertinoIcons.map),
      ),
    );
  }
}
