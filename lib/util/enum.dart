enum ItemType{
  income("income", 0),
  transfer("transfer", 1),
  expense("expense", 2);

  const ItemType(this.string, this.intVal);
  final String string;
  final int intVal;
}