abstract class DatabaseEvent {}
class DatabaseAdded extends DatabaseEvent {}
class DatabaseRemoved extends DatabaseEvent {}
class DatabaseRemovedAll extends DatabaseEvent {}
class DatabaseUpdate extends DatabaseEvent {}
class DatabaseGetAll extends DatabaseEvent {}