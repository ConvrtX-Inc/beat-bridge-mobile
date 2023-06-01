class FaqResult {
  var id, question, description;

  FaqResult({
    this.id,
    this.question,
    this.description,
  });
  factory FaqResult.fromJson(Map json) {
    return FaqResult(
      // graphData: json['tempHumidityData'] == null
      //     ? []
      //     : (json['tempHumidityData'] as List)
      //             .map((e) => graphResult.fromJson(e))
      //             .toList() ??
      //         [],
      // id: json['id'] ?? "",

      id: json['id'] ?? "",
      question: json['questions'] ?? "",
      description: json['description'] ?? "",
    );
  }
}


 // List<Map<String, dynamic>> graphData = [
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 01
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 02
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 03
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 04
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-01-24T12:48:05Z",
  //     "hour": 05
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-01-24T12:48:05Z",
  //     "hour": 06
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 07
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-01-24T12:48:05Z",
  //     "hour": 08
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 09
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-01-24T12:48:05Z",
  //     "hour": 10
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-01-24T12:48:05Z",
  //     "hour": 11
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 12
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 13
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 14
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 15
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 16
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 17
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 18
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 19
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 20
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 21
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 22
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 23
  //   },
  //   {
  //     "temperature": 26,
  //     "humidity": 20,
  //     "timeStamp": "2022-10-12T21:00:12.5974482Z",
  //     "hour": 24
  //   }
  // ];
