class Mines {
  int mineCount;
  boolean mine;
  boolean hidden;
  boolean mark;

  Mines() {
    mineCount = 0;
    mine = false;
    hidden = true;
    mark = false;
  }

  int MineCount() {
    return mineCount;
  }

  void countMine() {
    mineCount++;
  }

  boolean Mined() {
    return mine;
  }

  void setMine() {
    mine = true;
  }

  boolean Hidden() {
    return hidden;
  }

  void reveal() {
    hidden = false;
    mark = false;
  }

  boolean Marked() {
    return mark;
  }

  void Mark() {
    mark = !mark;
  }
}
