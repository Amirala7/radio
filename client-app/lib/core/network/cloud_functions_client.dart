import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsClient {
  CloudFunctionsClient({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  static const _region = 'europe-west1';

  final FirebaseFunctions _functions;

  HttpsCallable call(String name) => _functions.httpsCallable(name);
}
