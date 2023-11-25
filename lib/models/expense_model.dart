class ExpenseData {
  ExpenseData({
    required this.uid,
    required this.title,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

   String uid; 
   String title;
   String description;
   String category;
   String amount;
   DateTime date;

  factory ExpenseData.fromJson(Map<String, dynamic> json) {
    return ExpenseData(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
