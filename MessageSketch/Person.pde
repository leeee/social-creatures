class Person {
  float h, s, b;
  float y;
  ArrayList<String> ids;
  ArrayList<Message> messages;

  Person(float h, float s, float b) {
    this.h = h;
    this.s = s;
    this.b = b;

    this.y = 0;
    messages = new ArrayList<Message>();
    ids = new ArrayList<String>();
  }

  Person(float h, float s, float b, String id) {
    this(h, s, b);
    ids.add(id);
  }

}