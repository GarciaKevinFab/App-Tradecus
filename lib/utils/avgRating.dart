Map<String, num> calculateAvgRating(List<dynamic>? reviews) {
  int totalRating = reviews?.fold<int>(
          0, (acc, item) => acc + (item['rating'] as int? ?? 0)) ??
      0;
  double avgRating = totalRating == 0
      ? 0.0
      : totalRating == 1
          ? totalRating.toDouble()
          : (totalRating / (reviews?.length ?? 1)).toDouble();

  return {
    'totalRating': totalRating,
    'avgRating': avgRating,
  };
}
