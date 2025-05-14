import 'package:flutter/material.dart';

class GCUPage extends StatelessWidget {
  const GCUPage({super.key});

  @override
  Widget build(
    BuildContext context
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white24,
          ),
        ),
        Align(
          /* alignment: Alignment.center, */
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(
                      child: Text(
                        'Conditions Générales d\'Utilisation',
                        style: TextStyle(
                          fontFamily: 'Satisfy-Regular',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '1. Objet',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les présentes Conditions Générales d\'Utilisation (CGU) ont pour objet de définir les modalités d\'utilisation de l\'application Octo’Loupe, qui recense toutes les activités culturelles et sportives présentes dans une ville et de sa périphérie. L\'utilisation de l\'application implique l\'acceptation pleine et entière des présentes CGU.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '2. Description du Service',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'application Octo’Loupe permet aux utilisateurs de rechercher et de consulter des activités culturelles et sportives dans leur ville. Les informations fournies par l\'application sont collectées auprès de diverses sources et peuvent inclure des événements, des ateliers, des cours, des expositions, des spectacles, et des activités sportives.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '3. Accès au Service',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'accès à l\'application est gratuit, mais certaines fonctionnalités peuvent nécessiter la création d\'un compte utilisateur. L\'utilisateur s\'engage à fournir des informations exactes et complètes lors de la création de son compte et à les mettre à jour régulièrement.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '4. Utilisation du Service',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'utilisateur s\'engage à utiliser l\'application de manière responsable et conforme aux lois en vigueur. Il est interdit d\'utiliser l\'application à des fins illégales, frauduleuses ou contraires aux présentes CGU. L\'utilisateur est responsable de ses actes et omissions, ainsi que de ceux des personnes qu\'il invite à utiliser l\'application.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '5. Propriété Intellectuelle',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tous les contenus présents sur l\'application, y compris les textes, images, vidéos, et logos, sont la propriété exclusive de l\’ASAM Cherbourg ou de ses partenaires. Toute reproduction, distribution ou modification de ces contenus sans autorisation préalable est strictement interdite.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '6. Responsabilité',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'éditeur de l\'application s\'efforce de fournir des informations précises et à jour, mais ne peut garantir l\'exactitude ou l\'exhaustivité des informations fournies. L\'utilisateur reconnaît utiliser l\'application à ses propres risques et renonce à toute réclamation à l\'encontre de l\'éditeur en cas de dommages directs ou indirects résultant de l\'utilisation de l\'application.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '7. Protection des Données Personnelles',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'application collecte et traite des données personnelles conformément à la loi Informatique et Libertés et au Règlement Général sur la Protection des Données (RGPD). Les données collectées sont utilisées pour améliorer les services proposés et personnaliser l\'expérience utilisateur. L\'utilisateur dispose d\'un droit d\'accès, de rectification, et de suppression de ses données personnelles.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '8. Modification des CGU',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'éditeur se réserve le droit de modifier les présentes CGU à tout moment. Les modifications seront notifiées aux utilisateurs par email ou via une notification dans l\'application. L\'utilisation continue de l\'application après la notification des modifications vaudra acceptation des nouvelles CGU.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '9. Résiliation',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'L\'utilisateur peut résilier son compte à tout moment en suivant la procédure prévue dans l\'application. L\'éditeur se réserve le droit de suspendre ou de résilier le compte d\'un utilisateur en cas de non-respect des présentes CGU.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '10. Loi Applicable',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Les présentes CGU sont régies par la loi française. Tout litige relatif à l\'interprétation ou à l\'exécution des présentes CGU sera soumis à la compétence exclusive des tribunaux français.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Padding(
                  padding: EdgeInsets.only(bottom: 32),
                ),
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}