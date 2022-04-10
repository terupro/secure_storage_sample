import 'package:flutter/material.dart';
import 'package:secure_storage_sample/utils/user_secure_storage.dart';
import 'package:secure_storage_sample/widget/birthday_widget.dart';
import 'package:secure_storage_sample/widget/button_widget.dart';
import 'package:secure_storage_sample/widget/pets_buttons_widget.dart';
import 'package:secure_storage_sample/widget/title_widget.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  DateTime? birthday;
  List<String> pets = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final birthday = await UserSecureStorage.getBirthday();
    final pets = await UserSecureStorage.getPets() ?? [];

    setState(() {
      controllerName.text = name;
      this.birthday = birthday;
      this.pets = pets;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const TitleWidget(icon: Icons.lock, text: 'Secure Storage'),
              const SizedBox(height: 32),
              buildName(),
              const SizedBox(height: 12),
              buildBirthday(),
              const SizedBox(height: 12),
              buildPets(),
              const SizedBox(height: 32),
              buildButton(),
              const SizedBox(height: 32),
              deleteButton(),
            ],
          ),
        ),
      );

  Widget buildName() => buildTitle(
        title: 'Name',
        child: TextFormField(
          controller: controllerName,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your Name',
          ),
        ),
      );

  Widget buildBirthday() => buildTitle(
        title: 'Birthday',
        child: BirthdayWidget(
          birthday: birthday,
          onChangedBirthday: (birthday) =>
              setState(() => this.birthday = birthday),
        ),
      );

  Widget buildPets() => buildTitle(
        title: 'Pets',
        child: PetsButtonsWidget(
          pets: pets,
          onSelectedPet: (pet) => setState(
              () => pets.contains(pet) ? pets.remove(pet) : pets.add(pet)),
        ),
      );

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );

  Widget buildButton() => ButtonWidget(
      text: 'Save',
      onClicked: () async {
        await UserSecureStorage.setUsername(controllerName.text);
        await UserSecureStorage.setPets(pets);

        if (birthday != null) {
          await UserSecureStorage.setBirthday(birthday!);
        }
      });

  Widget deleteButton() => ButtonWidget(
        text: 'Delete',
        onClicked: () async {
          await UserSecureStorage.deleteAll();
          setState(() {
            controllerName.text = '';
            birthday = null;
            pets.clear();
          });
        },
      );
}
