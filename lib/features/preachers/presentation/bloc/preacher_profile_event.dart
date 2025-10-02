abstract class PreacherProfileEvent {}

class LoadPreacherProfile extends PreacherProfileEvent {
  final int id;

  LoadPreacherProfile({required this.id});
}
