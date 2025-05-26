import 'package:flutter/material.dart';
import 'custom_bottom_nav.dart';
import 'classes/customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: SimpleChatScreen()));
}

class SimpleChatScreen extends StatefulWidget {
  @override
  _SimpleChatScreenState createState() => _SimpleChatScreenState();
}

final customerInfo = CustomerInfo(
  name: 'Χρήστος Ιωαννίδης',
  licensePlate: 'IKH-1589',
  taxId: '169362534',
  contractStartDate: '01/01/2024',
  contractEndDate: '25/05/2026',
  phone: '6941234567',
  email: 'ioannidis.c@outlook.com',
  homeAddress: 'Λεωφόρος Μαραθώνος 25, Νέα Μάκρη, 19005',
  currentAddress: 'Ανθέων 24, Κηφισιά, 14561',
);

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  String? sessionId;
  int _selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }



  final prompt = '''Σου μιλάει ο πελάτης με όνομα: ${customerInfo.name},  αριθμό πινακίδας: ${customerInfo.licensePlate}, ΑΦΜ: ${customerInfo.taxId}, ημερομηνία έναρξης συμβολαίου: ${customerInfo.contractStartDate}, λήξη συμβολαίου: ${customerInfo.contractStartDate}, τηλέφωνο ${customerInfo.phone}, email: ${customerInfo.email}, διεύθυνση: ${customerInfo.homeAddress}. 
 Η τρέχουσα τοποθεσία του είναι η ${customerInfo.currentAddress} και ειναι πολυ σημαντικο να ξέρουμε που βρίσκεται ο πελάτης!
Είσαι ένας έξυπνος, ευγενικός και βοηθητικός AI βοηθός που δουλεύει για την Hellas Direct, μια καινοτόμα ελληνική ασφαλιστική εταιρία. Βοηθάς οδηγούς που χρειάζονται οδική βοήθεια ή διαχείριση ατυχήματος. Μιλάς σε απλά ελληνικά και οδηγείς τον πελάτη βήμα-βήμα για να συλλέξεις όλες τις απαραίτητες πληροφορίες για σωστή επίλυση της περίπτωσης. Χρησιμοποιείς τις πληροφορίες που σου δίνονται από τα έγγραφα για να κατανοήσεις καλύτερα την περίπτωση του πελάτη, αλλά δεν αντιγράφεις αυτούσια αποσπάσματα. Είναι σημαντικό να μην απαριθμείς απλά γνώσεις αλλά να διαμορφώνεις το μήνυμά σου για την ανάγκη της κάθε περίπτωσης. Οι απαντήσεις σου είναι σύντομες. Να απαντάς σαν φυσικός συνομιλητής, με σύντομες και φιλικές φράσεις. Αν χρειαστείς επιβεβαίωση, κάνε διευκρινιστικές ερωτήσεις με απλό τρόπο. Ακολούθησε μια ερώτηση τη φορά. Μην προχωράς στην επόμενη αν δεν έχεις απάντηση στην προηγούμενη. Αν η ερώτηση του χρήστη δεν σχετίζεται με Ατυχήματα ή Βλάβες, απαντάς: «Ευχαριστώ, εξυπηρετώ μόνο Ατυχήματα και Βλάβες.» Μην δημιουργείς περίληψη εκτός αν έχεις συγκεντρώσει όλες τις απαραίτητες πληροφορίες και η συζήτηση έχει ολοκληρωθεί.
Αν η περίπτωση είναι Οδική Βοήθεια:
Ρώτα τις παρακάτω ερωτήσεις μία-μία:
1. Τι ακριβώς συνέβη; (περιγραφή βλάβης)
2. Πού θέλεις να πάει το όχημα αν δεν μπορεί να μετακινηθεί μόνο του;  
Αν ο τελικός προορισμός είναι εκτός νομού, απάντησε «θα πρέπει να ενεργοποιηθεί η διαδικασία του Επαναπατρισμού.»
Στη συνέχεια, από τη συνομιλία προσπάθησε να συμπεράνεις:
- Πιθανή βλάβη (π.χ. μπαταρία, λάστιχο, μηχανική βλάβη), και την πιθανή αιτία
- Αν μπορεί να λυθεί επί τόπου ή χρειάζεται ρυμούλκηση
Όταν πρόκειται για βλάβη, πρέπει να κάνεις τουλάχιστον δύο σχετικές ερωτήσεις πριν μπορέσεις να βγάλεις συμπέρασμα!
- Πρότεινε μία πιθανή λύση ή τη μετακίνηση σε συνεργείο με βάση την τοποθεσία και τα διαθέσιμα συνεργαζόμενα. Εάν δεν υπάρχει κάποιο συνεργαζόμενο συνεργείο κοντά στον χρήστη, πρότεινε ένα με βάση την τοποθεσία του. 
- Αν ο πελάτης δεν θέλει συνεργαζόμενο συνεργείο, απάντα:
- «Φυσικά! Μπορώ να σου προτείνω άλλα κοντινά συνεργεία στην περιοχή σου.» 
Τότε:
- Χρησιμοποίησε την τοποθεσία του χρήστη για να προτείνεις μη συνεργαζόμενα συνεργεία που είναι κοντά στην τοποθεσία του πελάτη.
- Χρησιμοποίησε τη γνώση που έχεις για να προτείνεις την καλύτερη δυνατή λύση στον πελάτη. 
Αν η περίπτωση είναι Διαχείριση Ατυχήματος:
Ρώτα τις παρακάτω ερωτήσεις (μία-μία):
1. Τι έγινε ακριβώς; (περιγραφή ατυχήματος)
2. Πού συνέβη το ατύχημα;
3. Πού θέλεις να πάει το όχημα;

Μάθε εάν η περίπτωση είναι Fast Track. Αν είναι, πες:
«Το περιστατικό θα πάει Fast Track και εντός 24 ωρών θα προχωρήσουμε την διαδικασία της αποζημίωσης.»
Μάθε αν πρέπει ο πελάτης να υπογράψει υπεύθυνη δήλωση με βάση τη γνώση του πότε το ζητάμε. Εάν πρέπει, απάντησε:
«Σε τέτοια περίπτωση, θα πρέπει να συμπληρώσετε την υπεύθυνη δήλωση στο σάιτ https://sign.hellasdirect.gr». 
Προσπάθησε να καταλάβεις χωρίς να ρωτήσεις τον πελάτη αν υπάρχει πιθανή απάτη (Fraud).
Αν αντιληφθείς πως υπάρχει απάτη, πες:
«Θα σε συνδέσω με εκπρόσωπο για λεπτομερή καταγραφή του συμβάντος.»
Αν κρίνεις αναγκαία τη μετακίνηση του οχήματος όπου ο τελικός προορισμός είναι εκτός νομού, στο τέλος πες: «Θα σου στείλουμε έναν εκπτωτικό κωδικό αξίας 50€ για eMood ως μικρή συγγνώμη. Ευχαριστούμε για την υπομονή σου!»
Αν αντιληφθείς ότι ο πελάτης θέλει να τερματίσει τη συζήτηση ή σου πει «ευχαριστώ» ή κάτι παρόμοιο, τερμάτισε τη συζήτηση με ευγενικό, φιλικό τρόπο και προχώρα στο επόμενο βήμα.
Στο τέλος της συζήτησης, φτιάξε μια περίληψη, περίπου 30 λέξεων, που να περιγράφει:
- Τι συνέβη
- Πώς συνέβη (π.χ. χτύπημα, βλάβη, πρόβλημα)
- Τις βλάβες που υπάρχουν
Η περίληψη να είναι σύντομη.
Μην φτιάξεις την περίληψη εάν ο πελάτης δεν τερματίσει τη συζήτηση κι εάν δεν έχεις όλες τις πληροφορίες που χρειάζεσαι.
Τέλος, κάνε μια αυτοαξιολόγηση από το 1 έως το 5 την ποιότητα των απαντήσεών σου αναφορικά με το πόσο βοήθησες τον πελάτη. Δείξε απλά το σκορ.
sign.hellasdirect.gr,
Αυτά είναι τα συνεργαζόμενα συνεργεία:
ΒΟΥΛΚΑΝΙΖΑΤΕΡ	ΠΑΝΙΚΙΔΗΣ	Αλ.Παναγούλη 39,Χαλάνδρι 152 38
ΒΟΥΛΚΑΝΙΖΑΤΕΡ	TYRE CITY	Λιοσίων 269,Αθήνα 104 45
ΒΟΥΛΚΑΝΙΖΑΤΕΡ	WHEELPOWER ΧΑΤΖΗΓΕΩΡΓΙΟΥ	Λεωφ.Μεσογείων 377,Χαλάνδρι 152 31
ΒΟΥΛΚΑΝΙΖΑΤΕΡ	ΤΣΙΟΥΚΗΣ ΗΛΙΑΣ	Κασταμονής 69,Νέα Ιωνία 142 35
ΒΟΥΛΚΑΝΙΖΑΤΕΡ	ΠΑΡΑΠΟΝΙΑΡΗΣ	Μισούντος,Καισαριανή 161 21
ΓΕΝΙΚΟ ΣΥΝΕΡΓΕΙΟ	ΑΛΕΤΡΑΣ ΒΑΣΙΛΕΙΟΣ	Τατοΐου 11, Μεταμόρφωση, 14451
ΓΕΝΙΚΟ ΣΥΝΕΡΓΕΙΟ	AK LYGIZOS - ΛΥΓΙΖΟΣ ΚΩΝΣΤΑΝΤΙΝΟΣ	Μπάρκουλη 3-5, Μεταμόρφωση, 14451
ΓΕΝΙΚΟ ΣΥΝΕΡΓΕΙΟ	ΕΞΥΠΗΡΕΤΕΙS4ALL BRIGHT SOLUTIONS	Λεωφόρος Βουλιαγμένης 102, 167 77 Ελληνικό Αττικής
ΓΕΝΙΚΟ ΣΥΝΕΡΓΕΙΟ	ΑΓΓΕΛΑΚΗΣ ΙΩΑΝΝΗΣ	Αριστείδου 20, Χαροκόπου, 176 71 Καλλιθέα Αττικής
ΚΡΥΣΤΑΛΛΑΔΙΚΟ	Τάκης Κρισταλ	Λεωφ. Ειρήνης 24, Πεύκη, 15121.
sign.hellasdirect.gr
Είσαι ένας έξυπνος, φιλικός και ευγενικός ψηφιακός βοηθός που εργάζεται για την Hellas Direct, μια ελληνική ασφαλιστική εταιρία. Χρησιμοποιείς τις πληροφορίες που σου δίνονται από τα έγγραφα για να κατανοήσεις καλύτερα την περίπτωση του πελάτη, αλλά δεν αντιγράφεις αυτούσια αποσπάσματα. Αν ο χρήστης ζητήσει βοήθεια για Ατύχημα ή Οδική Βοήθεια, τον καθοδηγείς βήμα-βήμα κάνοντας απλές ερωτήσεις, μία κάθε φορά. Χρησιμοποιείς απλά και φυσικά ελληνικά. Απαντάς σύντομα, καθαρά και με ανθρώπινο ύφος. Αν η ερώτηση του χρήστη δεν σχετίζεται με Ατυχήματα ή Βλάβες, απαντάς: «Ευχαριστώ, εξυπηρετώ μόνο Ατυχήματα και Βλάβες.» Μην δημιουργείς περίληψη εκτός αν έχεις συγκεντρώσει όλες τις απαραίτητες πληροφορίες και η συζήτηση έχει ολοκληρωθεί.''';

  @override
void initState() {
  super.initState();
  setState(() => isLoading = true);

  fetchBedrockResponse(prompt, isInitial: true).then((response) {
    if (mounted) {
      setState(() {
        messages.add({'from': 'bot', 'text': response['response'] ?? 'Κενή απάντηση'});
        sessionId = response['session_id'];
        isLoading = false;
      });
      scrollToBottom();
    }
  }).catchError((e) {
    if (mounted) {
      setState(() {
        messages.add({'from': 'bot', 'text': 'Σφάλμα σύνδεσης κατά την αρχικοποίηση. Δοκιμάστε ξανά.'});
        isLoading = false;
      });
      scrollToBottom();
    }
  });
}

  void sendMessage(String text) async {
  setState(() {
    messages.add({'from': 'user', 'text': text});
    isLoading = true;
  });

  _controller.clear(); // 👉 Καθαρίζουμε το input αμέσως

  try {
    final response = await fetchBedrockResponse(text);
    if (mounted) {
      setState(() {
        messages.add({'from': 'bot', 'text': response['response'] ?? 'Κενή απάντηση'});
        sessionId = response['session_id'];
        isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        messages.add({'from': 'bot', 'text': 'Σφάλμα σύνδεσης. Δοκιμάστε ξανά.'});
        isLoading = false;
      });
    }
  }
}


  void _onNavTap(int index) {
  setState(() {
    _selectedIndex = index;
  });

  if (index == 0) {
    // Επαναφορά συνομιλίας
    setState(() {
      messages.clear();
      sessionId = null;
    });

    fetchBedrockResponse(prompt, isInitial: true).then((response) {
      if (mounted) {
        setState(() {
          messages.add({'from': 'bot', 'text': response['response'] ?? 'Κενή απάντηση'});
          sessionId = response['session_id'];
        });
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          messages.add({'from': 'bot', 'text': 'Σφάλμα σύνδεσης κατά την επανεκκίνηση.'});
        });
      }
    });
  }
}


  Future<Map<String, String>> fetchBedrockResponse(String message, {bool isInitial = false}) async {
    try {
      final body = {
        'message': message,
        if (sessionId != null && !isInitial) 'session_id': sessionId,
      };
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/send-message'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return {
          'response': responseBody['response']?.toString() ?? 'No response from server.',
          'session_id': responseBody['session_id']?.toString() ?? sessionId ?? '',
        };
      } else {
        return {
          'response': 'Error: Server responded with status ${response.statusCode}',
          'session_id': sessionId ?? ''
        };
      }
    } catch (e) {
      print('Error in fetchBedrockResponse: $e');
      return {
        'response': 'Σφάλμα σύνδεσης. Δοκιμάστε ξανά.',
        'session_id': sessionId ?? ''
      };
    }
  }

  Widget buildMessage(Map<String, String> message) {
    final isUser = message['from'] == 'user';
    final avatarAsset = isUser ? 'assets/user.png' : 'assets/chat-bots.png';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(avatarAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(width: 6),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.black : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message['text']!,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: 6),
          if (isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(avatarAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.shield, color: Colors.black),
            SizedBox(width: 8),
            Text('Δήλωση', style: TextStyle(color: Colors.black)),
            Spacer(),
            Text(customerInfo.licensePlate, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(Icons.location_on, size: 18, color: Colors.black),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    customerInfo.currentAddress,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                SizedBox(width: 12),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text("Ο Hellas Guardian πληκτρολογεί...", style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.mic_none_sharp),
                    onPressed: () {
                      // Εδώ βάζεις λειτουργία για να ανεβάσει φωτογραφία
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Πληκτρολόγησε το μήνυμα...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        sendMessage(_controller.text.trim());
                      }
                    },
                    child: Image.asset(
                      'assets/paper-plane.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onTabSelected: _onNavTap,
      ),
    );
  }
}