import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/util/string_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'changepassword.dart';
import 'login.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.transparent), // Add border color
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 117, 113, 113).withOpacity(0.2)),
            child: ListTile(
              leading: Icon(
                FontAwesomeIcons.circleExclamation,
                size: 20,
              ),
              title: Text(
                'About apps',
                style: TextStyle(),
                
              ),
              onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutAppPage(),
                  ));
            },
          ),
            ),
          
          // ListTile(
          //   leading: Icon(
          //     FontAwesomeIcons.circleExclamation,
          //     size: 20,
          //   ),
          //   title: Text('About App'),
          //   onTap: () {
          //     // Handle navigation to About App screen
          //   },
          // ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.userShield,
              size: 20,
            ),
            title: Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicyScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.fileShield,
              size: 20,
            ),
            title: Text('Terms and Conditions'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditionsScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.solidQuestionCircle,
              size: 20,
            ),
            title: Text('Help and Support'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HelpAndSupportScreen(),
                  ));
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.phone,
              size: 20,
            ),
            title: Text('Helpline Number'),
            subtitle: Text('+9779860899605'),
            onTap: () {
              launch('tel:+9779860899605');
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
              leading: Icon(
                FontAwesomeIcons.userLock,
                size: 20,
              ),
              title: Text("Change Password"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ))),

          SizedBox(height: 20), // Add some spacing between sections
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red), // Add border color
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red.withOpacity(0.2)),
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.exclamationTriangle,
                    size: 20,
                  ),
                  title: Text(
                    'Danger Zone',
                    style: TextStyle(),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.trash,
                  size: 20,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Delete',
                          ),
                          content: Text('Are you sure you want to Delete?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                               deleteProfile(context);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 138),
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Logout',
                          ),
                          content: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginUi(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },

                  //subtitle: Text("v1.0"),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
   Future<void> deleteProfile(BuildContext context) async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Prompt the user to reauthenticate before deleting the profile
      // You can use various reauthentication methods such as email/password, phone number, etc.
      // Here, we use email/password reauthentication for demonstration purposes
     // AuthCredential credential = EmailAuthProvider.credential(); // Replace 'password' with the user's password

      // Reauthenticate user with the provided credential
    //  await user.reauthenticateWithCredential(credential);

      // Once reauthentication is successful, proceed with profile deletion

      // Delete user data from Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      
      // Delete user from Firebase Auth
      await user.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile deleted successfully')),
      );

      // Navigate to login screen after deleting profile
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginUi(),), (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting profile: $e')),
      );
    }
  }
}

}

//import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorstr,
        foregroundColor: Colors.white,
        title: Text('About App'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:16.0,right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/images/logo.png', 
                  color: colorstr,
                  height: 150,
                ),
              //  SizedBox(height: 20),
                Text(
                  'Home Services App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Nowadays, for any services like Plumbing, Photographer, Carpenter, Mechanical, Painter, cleaner, Water tanker and, if customers want to use these services, then they need to go through a personal meeting. It is difficult for customer to find any service in emergency at any time and place. So, giving a thought to that aspect of life is to design and develop a system that provides many services at your doorstep in just one call. A System that provides variety of services like plumbers, mechanics, cleaners, painters, water tankers and many more. ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Contact us:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: handyhire@homeserviceapp.com',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Phone: +9779860899605',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
}








class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            PrivacyPolicySection(
              title: 'Introduction',
              content:
                  'We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and disclose your personal information.',
            ),
            PrivacyPolicySection(
              title: 'Information We Collect',
              content:
                  'We collect information that you provide directly to us, such as when you register an account, book a service, or contact customer support.',
            ),
            PrivacyPolicySection(
              title: 'How We Use Your Information',
              content:
                  'We may use your information to provide and personalize the services, communicate with you, and improve our products and services.',
            ),
            PrivacyPolicySection(
              title: 'Data Security',
              content:
                  'We implement security measures to protect your personal information against unauthorized access and disclosure.',
            ),
            PrivacyPolicySection(
              title: 'Changes to This Privacy Policy',
              content:
                  'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: January 1, 2024',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicySection extends StatelessWidget {
  final String title;
  final String content;

  PrivacyPolicySection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green[100],
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 15, 15, 15).withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Terms and Conditions',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 16),
            TermsAndConditionsSection(
              title: '1. Introduction',
              content:
                  'These Terms and Conditions govern your use of the Home Service app and any related services provided by us.',
            ),
            TermsAndConditionsSection(
              title: '2. Acceptance of Terms',
              content:
                  'By using the app, you agree to be bound by these Terms and Conditions. If you do not agree to these Terms and Conditions, you may not use the app.',
            ),
            TermsAndConditionsSection(
              title: '3. User Accounts',
              content:
                  'You must create an account to use certain features of the app. You are responsible for maintaining the confidentiality of your account credentials.',
            ),
            TermsAndConditionsSection(
              title: '4. Service Providers',
              content:
                  'Service providers are independent contractors and not employees or agents of the app. We are not responsible for the actions or conduct of service providers.',
            ),
            TermsAndConditionsSection(
              title: '5. Limitation of Liability',
              content:
                  'We shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, revenue, or data.',
            ),
            SizedBox(height: 16),
            Text(
              'Last Updated: January 1, 2024',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsAndConditionsSection extends StatelessWidget {
  final String title;
  final String content;

  TermsAndConditionsSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class HelpAndSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help and Support'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help and Support',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            HelpAndSupportSection(
              title: 'Frequently Asked Questions',
              content:
                  'Find answers to common questions and troubleshooting tips.',
            ),
            Divider(),
            HelpAndSupportSection(
              title: 'Contact Us',
              content:
                  'For further assistance, reach out to our customer support team.',
            ),
            Divider(),
            HelpAndSupportSection(
              title: 'Feedback',
              content:
                  'Share your feedback and suggestions to help us improve our services.',
            ),
          ],
        ),
      ),
    );
  }
}

class HelpAndSupportSection extends StatelessWidget {
  final String title;
  final String content;

  HelpAndSupportSection({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

