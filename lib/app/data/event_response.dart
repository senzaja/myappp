class EventResponse {
  List<Events>? events;

  EventResponse({this.events});

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => Events.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Events {
  String? id;
  String? name;
  String? description;
  String? eventDate;
  String? location;

  Events({this.id, this.name, this.description, this.eventDate, this.location});

  factory Events.fromJson(Map<String, dynamic> json) {
    return Events(
      name: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      eventDate: json['event_date'] as String?,
      location: json['location'] as String?,
    );
  }
}
