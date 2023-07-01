class EndPoint {
  final String base;
  final String path;

  EndPoint({required this.base, required this.path});
}


class EndPoints {
  static String _devBase = "kyzens.com";
  static String get _base {
    return _devBase;
  }

  static final  _api = 'dev/eschool/api/';

  //login
  static EndPoint get login => _getEndPointWithPath(_api + 'login');
  //dashboard
  static EndPoint get dashboard => _getEndPointWithPath(_api +'get-data' );
  //Get Subjects
  static EndPoint get getSubjects => _getEndPointWithPath(_api +'get-data' );
  //add Data
  static EndPoint get addData => _getEndPointWithPath(_api +'post-data' );


// Profile Page
  static EndPoint get getProfile => _getEndPointWithPath(_api + 'profile' );


  static EndPoint _getEndPointWithPath(String path) {
    return EndPoint(base: _base, path: path);
  }
}