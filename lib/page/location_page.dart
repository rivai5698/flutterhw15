import 'package:flutter/material.dart';
import 'package:flutterhw15/page/location_bloc.dart';
import 'package:flutterhw15/services/debounce.dart';
import 'package:flutterhw15/services/location_manager.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final debounce = Debounce(milliseconds: 2000);
  TextEditingController? _controller;
  List<String> locations = [];
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Page'),
      ),
      body:
      Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
            ),
            child: TextField(
                  controller: _controller,
                  autocorrect: false,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    suffix: GestureDetector(
                        onTap: (){
                          _controller!.text = '';
                          locationBloc.clearLocation();
                        },
                        child: const Icon(Icons.close),),
                  ),
                  onChanged: (str){
                    debounce.run(() {
                      locationBloc.getLocation(str);

                    });
                  },
            ),

          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: locationBloc.locationStream,
              builder: (_,snapshot){
                locations.clear();
                if(snapshot.hasData){
                  locations.addAll(snapshot.data!);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_,  index) {
                      return _location(locations[index]);
                    },
                    itemCount: locations.length,
                  );
                }
                if(snapshot.hasError){
                  return const Center(child: Text('Error'),);
                }
                return Container();

              },
            ),
          )
        ],
      ),
    );
  }

  Widget _location(String location){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8,),
      child: Row(
        children: [
          const Icon(Icons.my_location,color: Colors.orangeAccent,),
          Expanded(child: Text(location)),
        ],
      ),
    );
  }
}
