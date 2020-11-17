


class CalendarResponse {

  final int code;
  final List<dynamic> week;
  final List<dynamic> vocations;

  CalendarResponse(this.code, this.week, this.vocations);


  CalendarResponse.fromJson(Map<String, dynamic> json):
        code = json['code'],
        week = json['calendar'],
        vocations = json['vocation'];

}

class Day {
  final int dayOfTheWeek;
  int timeFrom;
  int timeTo;
  bool work;

  Day(this.dayOfTheWeek, this.timeFrom, this.timeTo, this.work);

  Day.fromJson(Map<String, dynamic> json):
        dayOfTheWeek = json['day_of_the_week'],
        timeFrom = json['timeFrom'],
        timeTo = json['timeTo'],
        work = json['work'];
}