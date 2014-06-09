class Source {
  float h, s, b;
  String name;
  ArrayList<Message> messages;

  Source (String name, float h, float s, float b) {
    this.name = name;
    messages = new ArrayList<Message>();
    this.h = h;
    this.s = s;
    this.b = b;
  }

}