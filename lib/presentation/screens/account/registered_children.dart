import 'package:eaglerides/presentation/controller/auth/auth_controller.dart';
import 'package:eaglerides/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../injection_container.dart' as di;

class RegisteredChildren extends StatefulWidget {
  const RegisteredChildren({super.key});

  @override
  State<RegisteredChildren> createState() => _RegisteredChildrenState();
}

class _RegisteredChildrenState extends State<RegisteredChildren> {
  final AuthController _authController = Get.put(di.sl<AuthController>());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController.fetchChildren();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children List'),
      ),
      body: Obx(() {
        // if (childController.isLoading.value) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }

        if (_authController.children.isEmpty) {
          return const Center(
            child: Text('No children found'),
          );
        }

        return ListView.builder(
          itemCount: _authController.children.length,
          itemBuilder: (context, index) {
            final child = _authController.children[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.1),
                    border: Border.all(width: 1, color: backgroundColor),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Child Name'),
                      Text(child.fullname),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Age: ${child.age}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Grade: ${child.grade}'),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('School: ${child.school}'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('Address: ${child.address}'),
                    ],
                  ),
                  trailing: Text(child.relationship ?? 'N/A'),
                  onTap: () {
                    // Handle tap, e.g., navigate to a child details screen
                    // Get.to(() => ChildDetailsScreen(child: child));
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _authController.fetchChildren,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
