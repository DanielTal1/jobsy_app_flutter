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
  List<Job> selectedJobs = []; //list tracking the selected jobs
  bool isArchive=false;
  final appbarColor=const Color(0xFF126180);
  final appbarBottomHeight=50.0;
  final popMenuSize=24.0;
  final popMenuPad=8.0;
  final drawerHeight=450.0;
  final drawerWidth=300.0;
  final buttonColor=Color(0xFF126180);
  final drawerTopPad=40.0;
  final drawerFontH1=30.0;
  final drawerFontH2=20.0;
  final drawerBottomPad=95.0;
  final addButtonPad=20.0;



  //callback to close the search bar
  void searchCallBackClose() {
    setState(() {
      searchedQuery = "";
      showSearch = false;
    });
  }

  //callback to get the search query
  void searchCallBackGetQuery(String newSearch) {
    setState(() {
      searchedQuery = newSearch;
    });
  }

  //filter jobs based on the selected stage
  void filterJobs(String stage) {
    setState(() {
      selectedStage = stage;
    });
  }

  //callback to add a job to the selected jobs list
  void addSelectedCallback(Job currentJob){
    setState(() {
      selectedJobs.add(currentJob);
    });
  }

  //callback to check if a job is selected
  bool isJobSelectedCallback(Job currentJob){
    return selectedJobs.contains(currentJob);
  }

  //callback to remove a job from the selected jobs list
  void removeSelectedCallback(Job currentJob){
    setState(() {
      selectedJobs.remove(currentJob);
    });
  }

  //callback to check if the selected jobs list is empty
  bool isSelectedListEmptyCallback(){
    return selectedJobs.isEmpty;
  }

  //delete all selected jobs
  void deleteAllSelected(){
    setState(() {
      selectedJobs=[];
    });
  }

  //update API callback to fetch jobs
  void  UpdateAPiCallback() async{
    final jobData = Provider.of<JobData>(context, listen: false);
    await jobData.fetchJobs();
  }




  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobData>(context,listen: false);
    jobProvider.JobDataInitialize();
    //configure the firebae message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        jobProvider.fetchJobs();
      print('Received message: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from terminated state: ${message.notification?.title}');
    });
  }




  @override
  Widget build(BuildContext context) {
    //using the job provider
    final jobData = Provider.of<JobData>(context,listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); //opens the drawer written below
              },
            );
          },
        ),
        title: isArchive?Text('Jobsy|Archive'):Text('Jobsy'),
        backgroundColor: appbarColor,
        actions: [
          if (!isSelectedListEmptyCallback())
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    List<String> jobIds = selectedJobs.map((job) => job.id).toList();
                    deleteAllSelected();
                    jobData.deleteJobsLocally(jobIds,isArchive);
                    jobData.deleteJobs(jobIds);//deletes the selected jobs
                    },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () async {
                    List<String> jobIds = selectedJobs.map((job) => job.id).toList();
                    deleteAllSelected();
                    jobData.archiveJobsLocally(jobIds,isArchive);
                    jobData.updateArchive(jobIds);//archives or archives selected jobs
                  },
                  icon: Icon(isArchive? Icons.unarchive:Icons.archive),
                ),
                IconButton(
                  onPressed: () {
                    List<String> jobIds = selectedJobs.map((job) => job.id).toList();
                    deleteAllSelected();
                    jobData.updatePinsLocally(jobIds,isArchive?jobData.archiveJobs:jobData.jobs);
                    jobData.sortJobs(isArchive?jobData.archiveJobs:jobData.jobs);
                    jobData.updatePins(jobIds);//update pins for selected jobs
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
          preferredSize: Size.fromHeight(appbarBottomHeight),
          child: showSearch == false
              ? Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () { //shows search
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
                //when clicking on filter opens popupMenu
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
                              width: popMenuSize,
                              height: popMenuSize,
                            ),
                            SizedBox(width: popMenuPad),
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
                                width: popMenuSize,
                                height: popMenuSize,
                              ),
                              SizedBox(width: popMenuPad),
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
                  onPressed: () {//moves between the archive and not archive list
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
      drawer:Align( //opens menu
        alignment: Alignment.topLeft,child:
      SizedBox(height:drawerHeight,width: drawerWidth,child:
      Drawer(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: drawerTopPad, bottom: drawerTopPad),
              child: Text(
                'Menu',
                style: TextStyle(fontSize: drawerFontH1),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Image.asset('images/graphs.png'),
                    title: Text('Graphs',style: TextStyle(fontSize: drawerFontH2),),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyChartPage()));
                    },
                  ),
                  SizedBox(height: 35),
                  ListTile(
                    leading: Image.asset('images/recommendations.png'),
                    title: Text('Recommendations',style: TextStyle(fontSize: drawerFontH2),),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendPage()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: drawerBottomPad),
                    child: ListTile(
                      leading: Image.asset('images/logout.png'),
                      title: Text('Log Out',style: TextStyle(fontSize: drawerFontH2),),
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
      body: JobList(searchedQuery: searchedQuery,selectedStage:selectedStage,
          addSelectedCallback:addSelectedCallback,
          isJobSelected: isJobSelectedCallback,
          removeSelectedCallback:removeSelectedCallback,
          isSelectedListEmptyCallback:isSelectedListEmptyCallback,
          isArchive:isArchive),
      floatingActionButton: !isArchive?FloatingActionButton(
        onPressed: () {
          showModalBottomSheet( //display a modal bottom sheet
            context: context,
            isScrollControlled: true,
            //singleChildScrollView makes sure the keyboard wont hide the input
            builder: (context) => SingleChildScrollView(
              child: GestureDetector( //allowing interaction with content
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(addButtonPad),
                        topRight: Radius.circular(addButtonPad),
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
        backgroundColor: buttonColor,
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
