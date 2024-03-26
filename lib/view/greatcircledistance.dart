import 'dart:math';

 double greatCircleDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = _toRadians(lat1);
    double lon1Rad = _toRadians(lon1);
    double lat2Rad = _toRadians(lat2);
    double lon2Rad = _toRadians(lon2);

    // Calculate the difference between latitudes and longitudes
    double dLat = lat2Rad - lat1Rad;
    double dLon = lon2Rad - lon1Rad;

    // Calculate the distance using the Great Circle Distance formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;
    

    return distance;
  }
 double _toRadians(double degree) {
    return degree * pi / 180;
  }


void main() {
  double lat1 = 52.2296756;
  double lon1 = 21.0122287;
  double lat2 = 41.8919300;
  double lon2 = 12.5113300;

  double distance = greatCircleDistance(lat1, lon1, lat2, lon2);
  print("Distance: $distance kilometers");
}
