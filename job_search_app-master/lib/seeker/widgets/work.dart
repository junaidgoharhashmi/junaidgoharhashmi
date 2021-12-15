import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as developer;
import 'package:job_search_app/colors.dart' as color;
import 'package:job_search_app/seeker/widgets/apply_job.dart';
import 'package:job_search_app/shared/screens.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../jobSearchResponse.dart';

class Work extends StatefulWidget {
  const Work({Key? key}) : super(key: key);

  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends State<Work> {
  User? user = FirebaseAuth.instance.currentUser;
  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var name = "";
  var docs;
  late Timestamp timestamp;
  jobSearchResponse? _jobsearchresponse;
  int _currentIndex = 0;
  List<jobSearchResponse>? business_lst ;
  List<String>? id;
  TextEditingController search_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    get_jobs_data();
    _currentIndex = 0;
    business_lst = [];
    id = [];
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      setState(() {
        name = fields!['name'] as String;
        name = name.split(' ').elementAt(0);
      });
      print(fields!['name'] as String);
    });
    // Recommended Jobs  based on skills add limit for upto 7 documents and where skills == perosn skills
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      body: Column(
        children: [
          greetings(),
          searchAndControler(context),
          jobCategories(context),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView(
                  addSemanticIndexes: true,
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    if(business_lst!.length > 0)
                    recommendedJobList(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text('Recent Jobs',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: color
                                            .AppColor.welcomeImageContainer)),
                              ))),
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

  Widget recommendedJobList()
  {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text('Recommended Jobs',
                        style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.welcomeImageContainer)),
                  ))),
        ),
        Container(
            height: 260,
            //  decoration: BoxDecoration(color: Common().appColor),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                 itemCount: business_lst!.length,
                 itemBuilder: (context,item)
                  {
                   // timestamp = data[item].dateOpen;
                    var country = business_lst![item].country;
                    country = country.split(' ').elementAt(0);

                    return recommendedJob(
                        business_lst![item].title,
                        business_lst![item].company,
                        country,
                        business_lst![item].dateOpen,
                        business_lst![item].jobType,
                        id![item].toString(),
                        business_lst![item].company_id,
                        business_lst![item].job_id
                    );
                  }
                )
              ),
            ),
      ],
    );
  }



  Widget recommendedJob(String position, String company, String location, String time, String type, String docId,String company_id, String job_id) =>
      Padding(
          padding: const EdgeInsets.only(left: 5),
          child: InkWell(
              onTap: () {
                Navigator.push(context,
                    PageTransition(
                        child: ApplyJob(id: docId, company: company, company_id: company_id, job_id: job_id,contact_number: user!.phoneNumber.toString(),user_name: user!.displayName.toString(),), type: PageTransitionType.fade));
              },
              child: Card(
                shadowColor: color.AppColor.welcomeImageContainer,
                child: Container(
                  width: 280,
                  height: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(position,
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 22, color: color.AppColor.welcomeImageContainer)),
                      Text(company,
                        style: GoogleFonts.lato(fontSize: 18, color: color.AppColor.welcomeImageContainer),),
                      Text(
                        location,
                        style: GoogleFonts.lato(fontSize: 18, color: color.AppColor.welcomeImageContainer),),
                      Divider(),
                      Container(
                        width: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: color.AppColor.welcomeImageContainer),
                                Text(time,
                                    style: GoogleFonts.lato(fontSize: 16, color: color.AppColor.welcomeImageContainer))
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.work,
                                  color: color.AppColor.welcomeImageContainer,),
                                Text(type,
                                    style: GoogleFonts.lato(fontSize: 16, color: color.AppColor.welcomeImageContainer))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )));

  Widget jobCategories(BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text('Job Categories',
                          style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: color.AppColor.welcomeImageContainer)),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  category(0, 'All'),
                  category(1, 'Design'),
                  category(2, 'Software'),
                  category(3, 'Business'),
                ],
              ),
            ),
          ),
        ],
      ));

  Widget category(int index, String title) => Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          if(_currentIndex != index)
          setState(() {
            _currentIndex = index;
            if(index == 0)
              {
                get_jobs_data();
              }
            else{
              get_jobs_category(title.trim());
            }

          });
        },
        child: Container(
          height: 40,
          width: 70,
          decoration: BoxDecoration(
              color: (_currentIndex != index)
                  ? color.AppColor.white
                  : color.AppColor.welcomeImageContainer,
              border: Border.all(
                  color: color.AppColor.welcomeImageContainer, width: 0.5),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(title,
                style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: (_currentIndex != index)
                        ? color.AppColor.welcomeImageContainer
                        : color.AppColor.white)),
          ),
        ),
      ));

  Widget searchAndControler(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: MediaQuery.of(context).size.width - 90,
                child: TextField(
                  controller: search_controller,
                  cursorColor: color.AppColor.welcomeImageContainer,
                  style: GoogleFonts.lato(),
                  decoration: InputDecoration(
                    hintText: 'Search Job',
                    hintStyle: TextStyle(color: color.AppColor.welcomeImageContainer),
                    suffixIcon: IconButton(icon:Icon(Icons.search, color: color.AppColor.welcomeImageContainer),
                      onPressed: ()
                      {
                        get_jobs_search(search_controller.text.trim());
                        print("Click");
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 0.1,
                          color: color.AppColor.welcomeImageContainer),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          width: 0.5,
                          color: color.AppColor.welcomeImageContainer),
                    ),
                  ),
                )),
            IconButton(
              icon: Icon(Icons.tune, color: color.AppColor.matteBlack),
              onPressed: () {

              },
            )
          ],
        ),
      );

  greetings() => Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    width: 170,
                    child: Text('Hello ' + name + '!',
                        style: GoogleFonts.lato(
                            fontSize: 18, color: color.AppColor.matteBlack)),
                  ),
                  Container(
                    width: 170,
                    child: Text('Find your perfect job',
                        style: GoogleFonts.lato(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.welcomeImageContainer)),
                  )
                ],
              )),
        ],
      ));

  /// Get  data against title ////////////////////////////////////////////////////////
  Future<String?> get_jobs_search(String keyword) async
  {
      business_lst = [];

      try
      {
        firestoreInstance.collection("jobs").get().then((value){

          for(int i=0; i<value.docs.length; i++)
          {
            try
            {
              firestoreInstance.collection("jobs").doc(value.docs[i].id.toString()).get().then((value){
                Map<String,dynamic>? h = value.data();
                if(h != null)
                {
                  _jobsearchresponse = jobSearchResponse.fromJson(h);
                  if(_jobsearchresponse!.title.trim() == keyword.trim())
                    {
                      business_lst!.add(_jobsearchresponse!);
                    }
                  else
                    {
                      var s =_jobsearchresponse!.skills.split(",");
                      for(int i=0; i<s.length; i++)
                        if(s[i].toString().trim() == keyword.trim())
                        {
                          business_lst!.add(_jobsearchresponse!);
                        }
                    }
                }
              }).whenComplete(()
              {
                developer.log("my data g       "+ business_lst!.length.toString());
                setState(() {});
              });
            }
            catch(e){
              print(e.toString());
            }
          }
        });
      }
      catch(e)
      {
        _displaySnackBar(context, "No Business Found");
      }
  }

  /// Get  data against title ////////////////////////////////////////////////////////
  Future<String?> get_jobs_category(String keyword) async
  {
    business_lst = [];

    try
    {
      firestoreInstance.collection("jobs").get().then((value){

        for(int i=0; i<value.docs.length; i++)
        {
          try
          {
            firestoreInstance.collection("jobs").doc(value.docs[i].id.toString()).get().then((value){
              Map<String,dynamic>? h = value.data();
              if(h != null)
              {
                _jobsearchresponse = jobSearchResponse.fromJson(h);
                if(_jobsearchresponse!.category.trim() == keyword.trim())
                {
                  business_lst!.add(_jobsearchresponse!);
                }
              }
            }).whenComplete(()
            {
              developer.log("my data g       "+ business_lst!.length.toString());
              setState(() {});
            });
          }
          catch(e){
            print(e.toString());
          }
        }
      });
    }
    catch(e)
    {
      _displaySnackBar(context, "No Business Found");
    }
  }

  /// Get  data against title ////////////////////////////////////////////////////////
  // ignore: non_constant_identifier_names
  get_jobs_data() async
  {
    business_lst = [];
    id = [];

    try
    {
      firestoreInstance.collection("jobs").get().then((value){

        for(int i=0; i<value.docs.length; i++)
        {
          try
          {
            id!.add(value.docs[i].id.toString());
            firestoreInstance.collection("jobs").doc(value.docs[i].id.toString()).get().then((value){
              Map<String,dynamic>? h = value.data();
              if(h != null)
              {
                _jobsearchresponse = jobSearchResponse.fromJson(h);

                  business_lst!.add(_jobsearchresponse!);
              }
            }).whenComplete(()
            {
              developer.log("my data g       "+ business_lst!.length.toString());
              setState(() {});
            });
          }
          catch(e){
            print(e.toString());
          }
        }
      });
    }
    catch(e)
    {
      _displaySnackBar(context, "No Business Found");
    }
  }

  /// Show Snackbar ////////////////////////////////////////////////////////////////
  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(backgroundColor: Colors.black,
      content: new Text(msg, style: TextStyle(
          fontSize: 20, color: Colors.white),),
      duration: Duration(seconds: 7),);
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }

}
