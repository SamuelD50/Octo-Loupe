import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
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

  Future<void> sendEmail(
    String title,
    String firstName,
    String name,
    String email,
    String subject,
    String body
  ) async {
    final smtpServer = gmailSaslXoauth2(
      dotenv.env['EMAIL'] ?? '',
      dotenv.env['PASSWORD'] ?? ''
    );
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
  Widget build(
    BuildContext context
  ) {
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'N\'hésitez pas à nous contacter pour modifier du contenu ou pour toutes autres questions.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:DropdownButtonFormField<String>(
                        value: _selectedTitle,
                        hint: Text('Titre'),
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
                          isDense: true,
                        ),
                        validator: (value) => (value == null) ?
                          'Veuillez choisir un titre' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ?
                          'Veuillez entrer un prénom' : null,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ?
                          'Veuillez entrer un nom' : null,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Ex: abc@exemple.com',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un email';
                          }
                          final emailRegex = RegExp(
                            r'^[^@]+@[^@]+\.[^@]+'
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:TextFormField(
                        controller: _subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Objet',
                          hintText: 'Ex: Modification du lieu d\'activité',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un objet';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child:TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          hintText: 'Ex: Bonjour, le lieu de l\'activité a changé...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un message';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B59B4),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFF5B59B4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String title = _selectedTitle ?? '';
                          String firstName = _firstNameController.text;
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String subject = _subjectController.text;
                          String message = _messageController.text;

                          sendEmail(
                            title,
                            firstName,
                            name,
                            email,
                            subject,
                            message
                          );
                        }
                      },
                      child: Text('Envoyer'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 32),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}