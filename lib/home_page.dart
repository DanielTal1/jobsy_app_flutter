import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jobsy_app_flutter/graphs_page.dart';
import 'package:jobsy_app_flutter/models/username_data.dart';
import 'package:jobsy_app_flutter/recommend_page.dart';
import 'package:jobsy_app_flutter/widgets/job_list.dart';
import 'package:provider/provider.dart';
import 'add_job_screen.dart';
import 'models/Job_data.dart';
import 'models/job.dart';
import 'models/stage.dart';
import 'search_jobs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = 'Home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showSearch = false;
  late String searchedQuery = "";
  String selectedStage = '';
  List<Job> selectedJobs = [];
  bool isArchive=false;


  void searchCallBackClose() {
    setState(() {
      searchedQuery = "";
      showSearch = false;
    });
  }

  void searchCallBackGetQuery(String newSearch) {
    setState(() {
      searchedQuery = newSearch;
    });
  }

  void filterJobs(String stage) {
    setState(() {
      selectedStage = stage;
      // Perform filtering based on the selected stage
      // You can update the 'searchedQuery' or call a filtering method
    });
  }

  void addSelectedCallback(Job currentJob){
    setState(() {
      selectedJobs.add(currentJob);
    });
  }

  bool isJobSelectedCallback(Job currentJob){
    return selectedJobs.contains(currentJob);
  }

  void removeSelectedCallback(Job currentJob){
    setState(() {
      selectedJobs.remove(currentJob);
    });
  }
  bool isSelectedListEmptyCallback(){
    return selectedJobs.isEmpty;
  }

  void deleteAllSelected(){
    setState(() {
      selectedJobs=[];
    });
  }

  void  UpdateAPiCallback() async{
    final jobData = Provider.of<JobData>(context, listen: false);
    await jobData.fetchJobs();
  }






  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobData>(context,listen: false);
    jobProvider.JobDataInitialize();
    // Configure the message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final jobProvider = Provider.of<JobData>(context,listen: false);
      jobProvider.fetchJobs();
      print('Received message: ${message.notification?.title}');
      // Handle the received message as needed
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from terminated state: ${message.notification?.title}');
      // Handle the opened message from terminated state as needed
    });
  }




  @override
  Widget build(BuildContext context) {
    final jobData = Provider.of<JobData>(context,listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: isArchive?Text('Jobsy|Archive'):Text('Jobsy'),
        backgroundColor: const Color(0xFF126180),
        actions: [
          if (!isSelectedListEmptyCallback())
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    List<String> jobIds = selectedJobs.map((job) => job.id).toList();
                    deleteAllSelected();
                    jobData.deleteJobsLocally(jobIds,isArchive);
                    jobData.deleteJobs(jobIds);
                    },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () async {
                    List<String> jobIds = selectedJobs.map((job) => job.id).toList();
                    deleteAllSelected();
                    jobData.archiveJobsLocally(jobIds,isArchive);
                    jobData.updateArchive(jobIds);
                  },
                  icon: Icon(isArchive? Icons.unarchive:Icons.archive),
                ),
                IconButton(
                  onPressed: () {
                    List<String> jobIds = selectedJobs.map((job) => job.id).toList();
                    deleteAllSelected();
                    jobData.updatePinsLocally(jobIds,isArchive?jobData.archiveJobs:jobData.jobs);
                    jobData.sortJobs(isArchive?jobData.archiveJobs:jobData.jobs);
                    jobData.updatePins(jobIds);
                  },
                  icon: Icon(Icons.push_pin),
                ),
                IconButton(
                  onPressed: () {deleteAllSelected();},
                  icon: Icon(Icons.close),
                ),
              ],
            ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: showSearch == false
              ? Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    deleteAllSelected();
                    setState(() {
                      showSearch = true;
                    });
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (stage) {
                      deleteAllSelected();
                      filterJobs(stage);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: '',
                        child: Row(
                          children: [
                            Image.asset(
                              'images/all.png',
                              width: 24, // Adjust the width as needed
                              height: 24, // Adjust the height as needed
                            ),
                            SizedBox(width: 8),
                            Text('all'),
                          ],
                        ),
                      ),
                      ...stagesList.map<PopupMenuItem<String>>((stage) {
                        return PopupMenuItem<String>(
                          value: stage['name'],
                          child: Row(
                            children: [
                              Image.asset(
                                stage['image'],
                                width: 24, // Adjust the width as needed
                                height: 24, // Adjust the height as needed
                              ),
                              SizedBox(width: 8),
                              Text(stage['name']),
                            ],
                          ),
                        );
                      }).toList(),
                    ];
                  },
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                ),


                IconButton(
                  onPressed: () {
                    deleteAllSelected();
                    setState(() {
                      isArchive = !isArchive;
                    });
                  },
                  icon: Icon(isArchive?
                    Icons.unarchive:Icons.archive,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
              : SearchJobs(
            closeCallBack: searchCallBackClose,
            searchCallBack: searchCallBackGetQuery,
          ),
        ),
      ),
      drawer:Align(
        alignment: Alignment.topLeft,child:
      SizedBox(height:450,width: 300,child:
      Drawer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 40),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Image.asset('images/graphs.png'), // Adjust the image path as per your file structure
                    title: Text('Graphs',style: TextStyle(fontSize: 20),),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyChartPage()));
                    },
                  ),
                  SizedBox(height: 35),
                  ListTile(
                    leading: Image.asset('images/recommendations.png'), // Adjust the image path as per your file structure
                    title: Text('Recommendations',style: TextStyle(fontSize: 20),),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendPage()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 95.0),
                    child: ListTile(
                      leading: Image.asset('images/logout.png'), // Adjust the image path as per your file structure
                      title: Text('Log Out',style: TextStyle(fontSize: 20),),
                      onTap: () {
                        UsernameData.deleteUsernameData();
                        jobData.JobDataExit();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        // Handle onTap event for "Log Out" ListTile
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      )),
      body: JobList(searchedQuery: searchedQuery,selectedStage:selectedStage, addSelectedCallback:addSelectedCallback, isJobSelected: isJobSelectedCallback,removeSelectedCallback:removeSelectedCallback,isSelectedListEmptyCallback:isSelectedListEmptyCallback,isArchive:isArchive),
      floatingActionButton: !isArchive?FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: AddJobScreen(addJobCallback:UpdateAPiCallback),
                  ),
                ),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF126180),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
