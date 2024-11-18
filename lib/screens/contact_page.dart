import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/* Mailtrap */

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<String> _titles = ['Mademoiselle', 'Madame', 'Monsieur'];
  String? _selectedTitle;

  //
  //https://www.youtube.com/watch?v=RDwst9icjAY
 /*  Future sendEmail() async {
    final email = 'octoloupe@gmail.com';
    final token = ''

    final smtpServer = gmailSaslXoauth2(email, accessToken);
    final message = Message()
      ..from = Address(email, 'Application Octoloupe Info Service')
      ..recipients = ['duflos.samuel@gmail.com']
      ..subject = $subject
      ..text = 'Titre: $title\nPrénom: $firstName\nNom: $name\nEmail: $email\n\nMessage:\n$body';
  } */

  //

  Future<void> sendEmail(String title, String firstName, String name, String email, String subject, String body) async {
    final smtpServer = gmailSaslXoauth2(dotenv.env['EMAIL'] ?? '', dotenv.env['PASSWORD'] ?? '');
    final message = Message()
      ..from = Address(dotenv.env['EMAIL']!, 'Application Info Service')
      ..recipients.add('samuel-50100@hotmail.fr')
      ..subject = subject
      ..text = 'Titre: $title\nPrénom: $firstName\nNom: $name\nEmail: $email\n\nMessage:\n$body'
      ..html = "<p>Titre: $title</p><p>Prénom: $firstName</p><p>Nom: $name</p><p>Email: $email</p><p>Message:</p><p>$body</p>";

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: ${sendReport.toString()}');
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF5D71FF),
                  Color(0xFFF365C7),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'N\'hésitez pas à nous contacter pour modifier du contenu ou pour toutes autres questions.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedTitle,
                        hint: Text('Choisissez un titre'),
                        items: _titles.map((String title) {
                          return DropdownMenuItem<String>(
                            value: title,
                            child: Text(title),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTitle = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null) ? 'Veuillez choisir un titre' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Veuillez entrer un prénom' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Veuillez entrer un nom' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un mail';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Veuillez entrer une adresse e-mail valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Objet',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un objet';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un message';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String title = _selectedTitle ?? '';
                            String firstName = _firstNameController.text;
                            String name = _nameController.text;
                            String email = _emailController.text;
                            String subject = _subjectController.text;
                            String message = _messageController.text;

                            sendEmail(title, firstName, name, email, subject, message);
                          }
                        },
                        child: const Text('Envoyer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}