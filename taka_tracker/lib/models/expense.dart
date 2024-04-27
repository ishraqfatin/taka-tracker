import 'dart:convert';

UserExpense userExpenseFromMap(String str) => UserExpense.fromMap(json.decode(str));
List<UserExpense> userExpenseListFromMap(String str) => List<UserExpense>.from(json.decode(str).map((x) => UserExpense.fromMap(x)));
String userExpenseToMap(UserExpense data) => json.encode(data.toMap());
String userExpenseListToMap(List<UserExpense> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class UserExpense {
  String name;
  String category;
  DateTime? time;
  int price;

  UserExpense({
    required this.name,
    required this.category,    
    required this.time,
    required this.price,
  });

  factory UserExpense.fromMap(Map<String, dynamic> element) => UserExpense(
    name: element["name"],
    category: element["category"],
    time: element["time"],
    price: element["price"]
  );

  Map<String, dynamic> toMap(){ 
    return {
    "name": name,
    "category": category,
    "time": time,
    "price": price
    };
  }

  @override
  String toString() {
    return 'Expense{name: $name, category: $category, time: $time, price: $price}';
  }
}
