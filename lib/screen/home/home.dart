import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:labtim_mobile/api/api.dart';
import 'package:labtim_mobile/model/userModel/patientModel.dart';
import 'package:labtim_mobile/model/userModel/userModel.dart';
import 'package:labtim_mobile/screen/home/addPatient.dart';
import 'package:labtim_mobile/screen/home/charts.dart';
import 'package:labtim_mobile/screen/home/eegchart.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.login});
  final VoidCallback login;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PatientModel> patientModel = [];

  Future<void> fetchData() async {
    var data = await Api.getPatient();
    if (data != null) {
      setState(() {
        patientModel.clear();
        for (Map i in data) {
          patientModel.add(PatientModel.fromJson(i));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health_Care"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              widget.login.call();
              UserModel.logOut();
            },
            icon: const Icon(
              FontAwesomeIcons.signOutAlt,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blueGrey,
          primaryColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  'Dr . ${UserModel.sessionUser!.nom}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  UserModel.sessionUser!.email,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/profile_picture.png',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  //Navigator.push(
                  //    context,
                  //   MaterialPageRoute(
                  //    builder: (context) =>
                  //     const Profile(), // Replace with your profile page widget
                  //   ),
                  //  );
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.12,
              child: ListView.builder(
                itemCount: patientModel.length,
                itemBuilder: ((context, i) {
                  final patient = patientModel[i];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        AssetImage('assets/images/icon.png'),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${patient.nom} ${patient.prenom}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Tel: ${patient.tel}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ECG(id: patient.key),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.insert_chart,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    "ECG",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EEG(id: patient.key),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.insert_chart,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    "EEG",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Supprimer"),
                                    content:
                                        const Text("Voulez-vous supprimer ?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          var isDelete = await Api.deletPatient(
                                              patient.id_Patient);

                                          if (isDelete) {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) => Home(
                                                        login: () {},
                                                      )), // Replace YourCurrentPage with your page class
                                            );
                                          }
                                        },
                                        child: const Text("Oui"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Non"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPatient()),
          );
          fetchData(); // Refresh data after returning from AddPatient page
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
