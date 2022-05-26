import 'dart:io' show Platform;
import 'package:belks_yt_explorer/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:belks_yt_explorer/widgets/widgets.dart';

class PrivacyScreen extends StatelessWidget {
  final bool acceptedPrivacy;

  PrivacyScreen({Key? key, required this.acceptedPrivacy}) : super(key: key);
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  acceptAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('PrivatePolicyAccepted', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 20),
        padding: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        width: 60,
        height: 60,
        child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: SystemUiOverlay.values),
                  Navigator.of(context).pop()
                }),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50.0,
            ),
          ),
          header('Privacy Policy'),
          paragraf('Last updated: May 26, 2022'),
          paragraf(
              'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.'),
          paragraf(
              'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.'),
          paragraf(
              'We built the Belk`s Tube app as a Free application. We provide this Service at no cost and is intended for use as is.'),
          paragraf(
              'This page is used to inform visitors regarding Our policies with the collection, use, and disclosure of Personal Information if anyone decided to use Our Service.'),
          paragraf(
              'If You choose to use Our Service, then You agree to the collection and use of information in relation to this policy. The Personal Information that We collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Belk`s Tube application unless otherwise defined in this Privacy Policy.'),
          header('Definitions'),
          paragraf('For the purposes of this Privacy Policy:'),
          paragraf(
              'Account means a unique account created for You to access our Service or parts of our Service.'),
          paragraf(
              'Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.'),
          paragraf(
              'Application means the software program provided by the Company downloaded by You on any electronic device, named Belk`s Tube'),
          paragraf(
              'Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to Belk`s Tube.'),
          paragraf(
              'Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.'),
          paragraf(
              'Personal Data is any information that relates to an identified or identifiable individual.'),
          paragraf('Service refers to the Application.'),
          paragraf(
              'Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used.'),
          paragraf(
              'Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).'),
          paragraf(
              'You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.'),
          header('Information Collection and Use'),
          paragraf(
              'For a better experience, while using our Service, We may require you to provide us with certain personally identifiable information. The information that We request will be retained on your device and is not collected by us in any way.'),
          header('Log Data'),
          paragraf(
              'We want to inform you that whenever you use our Service, in a case of an error in the app We collect data and information (through third party products) on your phone called Log Data. This Log Data may include, but not limited to information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing Our Service, the time and date of your use of the Service, and other statistics.'),
          header('Cookies'),
          paragraf(
              'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\`s internal memory.\n This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.'),
          header('Service Providers'),
          paragraf(
              'We may employ third-party companies and individuals due to the following reasons:\n - To facilitate our Service;\n - To provide the Service on our behalf;\n - To perform Service-related services; or\n - To assist us in analyzing how our Service is used.\nWe want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'),
          header('Security'),
          paragraf(
              'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.'),
          header('Links to Other Websites'),
          paragraf(
              'Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party\'s site. We strongly advise You to review the Privacy Policy of every site You visit.\nWe have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.'),
          header('Children’s Privacy'),
          paragraf(
              'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case We discover that a child under 13 has provided us with personal information, We immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that We will be able to do necessary actions.'),
          header('Changes to This Privacy Policy'),
          paragraf(
              'We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.'),
          header('Contact Us'),
          paragraf(
              'If you have any questions about this Privacy Policy, You can contact us:\nBy email: io.levk@gmail.com'),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverToBoxAdapter(
              child: acceptedPrivacy
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        acceptAll();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      child: const Text('Accept and continue'),
                    ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 35.0),
            sliver: SliverToBoxAdapter(
              child: Platform.isIOS || acceptedPrivacy == true
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        if (Platform.isAndroid) {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        }
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.redAccent,
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      child: const Text('Reject and Exit'),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
