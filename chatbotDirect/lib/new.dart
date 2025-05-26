import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int selectedIndex = 0;

  final List<String> fields = [
    "Ονοματεπώνυμο",
    "Κινητό Τηλέφωνο",
    "Θέση",
    "Διεύθυνση",
    "Αριθμός Ταυτότητας",
    "ΑΜΚΑ/ΕΦΚΑ",
  ];

  final List<String> statements = [
    "Δέχομαι την χρήση των προσωπικών μου δεδομένων για τους σκοπούς της ασφάλισης",
    "Υποχρεούμαι να ενημερώσω την ασφαλιστική εταιρεία για οποιαδήποτε αλλαγή",
    "Δεν έχω υποστεί ατύχημα κατά τη διάρκεια της εργασίας μου",
    "Είμαι υπεύθυνος για την ακρίβεια των στοιχείων που παρέχω",
    "Συμφωνώ με τους όρους και τις προϋποθέσεις της ασφαλιστικής εταιρείας",
    "Δεν έχω άλλες ασφαλιστικές καλύψεις για το ίδιο περιστατικό",
    "Έχω ενημερωθεί για τα δικαιώματα και τις υποχρεώσεις μου",
    "Η δήλωση αυτή γίνεται με πλήρη επίγνωση των συνεπειών",
    "Δεν υπάρχουν εκκρεμότητες σχετικά με προηγούμενα περιστατικά",
    "Συμμετέχω στη διαδικασία με καλή πίστη",
  ];

  Map<String, TextEditingController> insuredControllers = {};
  Map<String, TextEditingController> supervisorControllers = {};
  List<bool> checked = List.filled(10, false);
  final headerDateController = TextEditingController();
  final descriptionController = TextEditingController();
  final developmentController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      insuredControllers[field] = TextEditingController();
      supervisorControllers[field] = TextEditingController();
    }
    // Παράδειγμα δυναμικής συμπλήρωσης πεδίων (μπορείς να το αλλάξεις)
    insuredControllers["Ονοματεπώνυμο"]?.text = "Ιωάννης Παπαδόπουλος";
    supervisorControllers["Ονοματεπώνυμο"]?.text = "Μαρία Ιωάννου";
  }

  @override
  void dispose() {
    for (var controller in insuredControllers.values) {
      controller.dispose();
    }
    for (var controller in supervisorControllers.values) {
      controller.dispose();
    }
    headerDateController.dispose();
    descriptionController.dispose();
    developmentController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "ΑΣΦΑΛΙΣΤΙΚΗ ΕΤΑΙΡΕΙΑ Π.Λ. & ΣΙΑ Α.Ε. 23/56",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Ημερομηνία: "),
                Expanded(
                  child: TextFormField(
                    controller: headerDateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: PersonalDetails(
                    title: "Στοιχεία Ασφαλισμένου",
                    fields: fields,
                    controllers: insuredControllers,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PersonalDetails(
                    title: "Στοιχεία Διευθυντή/Υπευθύνου",
                    fields: fields,
                    controllers: supervisorControllers,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Checkboxes(
              statements: statements,
              checked: checked,
              onCheckedChanged: (index, value) {
                setState(() {
                  checked[index] = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DescriptionFields(
              descriptionController: descriptionController,
              developmentController: developmentController,
            ),
            const SizedBox(height: 16),
            Signatures(
              dateController: dateController,
              timeController: timeController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onTabSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

class PersonalDetails extends StatelessWidget {
  final String title;
  final List<String> fields;
  final Map<String, TextEditingController> controllers;

  const PersonalDetails({
    super.key,
    required this.title,
    required this.fields,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ...fields.map((field) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(field),
                    TextFormField(
                      controller: controllers[field],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class Checkboxes extends StatelessWidget {
  final List<String> statements;
  final List<bool> checked;
  final Function(int, bool) onCheckedChanged;

  const Checkboxes({
    super.key,
    required this.statements,
    required this.checked,
    required this.onCheckedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: statements.asMap().entries.map((entry) {
          int index = entry.key;
          String statement = entry.value;
          return CheckboxListTile(
            title: Text(statement),
            value: checked[index],
            onChanged: (value) => onCheckedChanged(index, value!),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}

class DescriptionFields extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController developmentController;

  const DescriptionFields({
    super.key,
    required this.descriptionController,
    required this.developmentController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Περιγραφή Ατυχήματος"),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Εξέλιξη Ατυχήματος"),
                TextFormField(
                  controller: developmentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Signatures extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController timeController;

  const Signatures({
    super.key,
    required this.dateController,
    required this.timeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    const Text("Υπογραφή Ασφαλισμένου"),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    const Text("Υπογραφή Υπευθύνου"),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ημερομηνία"),
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Χρόνος"),
                  TextFormField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.transparent,
        elevation: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navIcon("assets/medical-report.png", 0),
                  _navIcon("assets/add.png", 1),
                  const SizedBox(width: 60),
                  _navIcon("assets/service.png", 3),
                  _navIcon("assets/profile.png", 4),
                ],
              ),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => onTabSelected(2),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedIndex == 2 ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/home-button.png",
                      width: 30,
                      height: 30,
                      color: selectedIndex == 2 ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(String asset, int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: isSelected
              ? const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                )
              : null,
          child: Image.asset(
            asset,
            width: 30,
            height: 30,
            color: isSelected ? Colors.black : const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}