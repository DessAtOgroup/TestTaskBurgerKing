import 'dart:async';
//enum Events{chCat}

class Update {
 // Events _lastEvent = Events.chCat;

  final StreamController _inController = StreamController();
  final StreamController _outController = StreamController();

  StreamSink<dynamic> get inputEventSink => _inController.sink;
  Stream<dynamic> get outputEventStream => _outController.stream;

  Update() {
    _inController.stream.listen((event) {_outController.sink.add(event);});
  }
  void closeStream(){
    _inController.close();
    _outController.close();
  }


}