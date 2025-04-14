class Expense {
  int? id;
  String name;
  String category;
  double amount;
  DateTime date;
  List<String> imagePaths;
  Map<int, double> sharedWith; // userId -> percentage

  Expense({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    this.imagePaths = const [],
    this.sharedWith = const {},
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
        'imagePaths': imagePaths.join(','),
        'sharedWith':
            sharedWith.entries.map((e) => '${e.key}:${e.value}').join(','),
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        name: map['name'],
        category: map['category'],
        amount: map['amount'],
        date: DateTime.parse(map['date']),
        imagePaths: map['imagePaths'].toString().split(','),
        sharedWith: {
          for (var pair in map['sharedWith'].toString().split(','))
            if (pair.contains(':'))
              int.parse(pair.split(':')[0]): double.parse(pair.split(':')[1])
        },
      );
}
