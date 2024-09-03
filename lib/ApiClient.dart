import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  // Constructor factory 
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class ApiClient {

  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

 
  List<User> filterUsersByUsername(List<User> users) {
    return users.where((user) => user.username.length > 6).toList();
  }


  int countUsersWithBizDomain(List<User> users) {
    return users.where((user) => user.email.endsWith('@biz')).length;
  }

 
  void execute() async {
    List<User> users = await fetchUsers();

    
    List<User> filteredUsers = filterUsersByUsername(users);
    print('Usuarios con username de más de 6 caracteres:');
    filteredUsers.forEach((user) => print(user.username));

   
    int bizUsersCount = countUsersWithBizDomain(users);
    print('\nCantidad de usuarios con email de dominio "biz": $bizUsersCount');
  }
}

void main() {
  ApiClient apiClient = ApiClient();
  apiClient.execute();
}
