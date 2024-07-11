import 'package:hive/hive.dart';
part 'password.g.dart';
@HiveType(typeId: 0)
class Password {
  @HiveField(0)
  String? value;

  Password(this.value);
}
