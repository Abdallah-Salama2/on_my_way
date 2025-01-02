extension RoundToHundredth on num {
  double get roundedToHundredth {
    return (this * 100).roundToDouble() / 100;
  }
}
