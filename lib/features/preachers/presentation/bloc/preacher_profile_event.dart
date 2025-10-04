abstract class PreacherProfileEvent {}

class LoadPreacherProfile extends PreacherProfileEvent {
  final String id;

  LoadPreacherProfile({required this.id});
}
