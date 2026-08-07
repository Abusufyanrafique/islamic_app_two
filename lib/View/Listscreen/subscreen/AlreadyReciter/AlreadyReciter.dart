import 'package:flutter/material.dart';
import 'package:local_notification/Utils/Constants/AllImages.dart';
import 'package:local_notification/Utils/Constants/AllText.dart';
import 'package:local_notification/Utils/Constants/SizeConfig.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../Utils/Constants/userFeedback.dart';
import 'BookAppointment.dart';
class Alreadyreciter extends StatelessWidget {
  const Alreadyreciter({super.key});

  Future<List<Map<String, dynamic>>> fetchImams() async {
    final response = await Supabase.instance.client
        .from('Hafiz_Profile')
        .select();

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AllText.Already_Reciter),
      ),
      body: FutureBuilder(
        future: fetchImams(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: spinkit);
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final dataList = snapshot.data ?? [];

          if (dataList.isEmpty) {
            return const Center(child: Text("No Imams Found"));
          }
          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];

              return InkWell(
                onTap: () {


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Book_Appointment(
                        name:     data['name'] ?? "",
                        profile_url:  data['profile_url'],
                        mufti_id: data['id'],
                      ),
                    ),
                  );
                },
                child: ReciterContainerList(
                  data['name'] ?? "",
                  data['phone_number'] ?? "", 
                  data['profile_url'],
                  data ['id']
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget ReciterContainerList(String name, String subtitle, String? imageUrl, int id) {
    return Padding(
      padding:  EdgeInsets.all(8.0),
      child: Container(
        height: getHeight(65),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
               blurRadius: 5,
               )
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: imageUrl != null
                ? NetworkImage(imageUrl) 
                : AssetImage(AllImages.kahba) as ImageProvider,
          ),
          title: Text(name),
          subtitle: Text(subtitle),
          trailing: Text(id.toString()),
        ),
      ),
    );
  }
}
