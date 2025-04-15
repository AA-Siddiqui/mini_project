class Expense {
  int? id;
  int userId;
  String name;
  String category;
  double amount;
  DateTime date;
  List<String> imagePaths;
  Map<int, double> sharedWith;
  bool isShared;
  int? sharedByUserId;

  Expense({
    this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    this.imagePaths = const [],
    this.sharedWith = const {},
    this.isShared = false,
    this.sharedByUserId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'name': name,
        'category': category,
        'amount': amount,
        'date': date.toIso8601String(),
        'imagePaths': imagePaths.join(','),
        'sharedWith':
            sharedWith.entries.map((e) => '${e.key}:${e.value}').join(','),
        'isShared': isShared ? 1 : 0,
        'sharedByUserId': sharedByUserId,
      };

  static List<String> _processImagePaths(List<String> item) {
    if (item.length == 1 && item[0] == "") {
      return List.empty();
    }
    return item;
  }

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        id: map['id'],
        userId: map['userId'],
        name: map['name'],
        category: map['category'],
        amount: map['amount'],
        date: DateTime.parse(map['date']),
        imagePaths: _processImagePaths(map['imagePaths'].toString().split(',')),
        sharedWith: {
          for (var pair in map['sharedWith'].toString().split(','))
            if (pair.contains(':'))
              int.parse(pair.split(':')[0]): double.parse(pair.split(':')[1])
        },
        isShared: map['isShared'] == 1,
        sharedByUserId: map['sharedByUserId'],
      );
}
