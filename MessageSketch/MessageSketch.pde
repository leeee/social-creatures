import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;

Table table;
int rows;
int currentRow = 1; // Skip header row
int frame = 0;
float speed = 1;
int peopleSeen = 0;

ArrayList<Message> messages;
HashMap<String, Person> people;
HashMap<String, Source> sources;

Person me;

void setup() {
  size(640, 640);
  colorMode(HSB, 360, 100, 100);
  background(0);
  table = loadTable("all.csv", "header, newlines");
  rows = table.getRowCount();

  messages = new ArrayList<Message>();
  people = new HashMap<String, Person>();
  me = new Person(156, 70, 100);
  me.ids.add("le.giantsquid.wei@gmail.com");
  me.ids.add("+13022521884");
  me.ids.add("");
  people.put("le.giantsquid.wei@gmail.com", me);
  people.put("+13022521884", me);
  people.put("", me);

  sources = new HashMap<String, Source>();
  sources.put("gchat", new Source("gchat", 61, 100, 100));
  sources.put("foursquare", new Source("foursquare", 2, 90, 80));
  sources.put("iphone", new Source("iphone", 206, 90, 100));

  for (TableRow row : table.rows()) {
    if (row.getString("From") == null) {
      // This is the header row, skip
      continue;
    }
    String from = row.getString("From").toLowerCase();
    String to = row.getString("To").toLowerCase();

    if (!people.containsKey(from)) {
      people.put(from, new Person(156 + 15 + random(0, 330) % 360,
        random(50, 100), random(75, 100), from));
    }

    if (!people.containsKey(to)) {
      people.put(to, new Person(156 + 15 + random(0, 330) % 360,
        random(50, 100), random(75, 100), to));
    }
  }
}

void draw() {
  background(0);

  if (frame % floor(15 / speed) == 0 && currentRow < rows) {
    TableRow row = table.getRow(currentRow);
    long timestamp = (long) row.getInt("Timestamp") * 1000;
    String from = row.getString("From").toLowerCase();
    String to = row.getString("To").toLowerCase();
    String source = row.getString("Source");
    String extra = row.getString("Extra");

    Person messageFrom = people.get(from);
    Person messageTo = people.get(to);
    Source messageSource = sources.get(source);

    if (messageFrom.y == 0) {
      messageFrom.y = map(peopleSeen, 0, people.size(), 90, height - 60);
      peopleSeen++;
    }
    if (messageTo.y == 0) {
      messageTo.y = map(peopleSeen, 0, people.size(), 90, height - 60);
      peopleSeen++;
    }

    messages.add(new Message(messageTo, messageFrom, messageSource, timestamp));

    currentRow++;
  }

  // Draw legend and messages
  float xKey = 15;
  float yKey = 15;
  textSize(13);
  HashSet<Person> peopleOnScreen = new HashSet<Person>();
  for (int i = messages.size() - 1; i >= 0; i--) {
    Message currentMessage = messages.get(i);
    if (currentMessage.isDead()) {
      messages.remove(i);
    } else {
      currentMessage.draw();
      if (!peopleOnScreen.contains(currentMessage.to)) {
        Person toPerson = currentMessage.to;
        fill(toPerson.h, toPerson.s, toPerson.b, 200);
        text(toPerson.ids.get(0), xKey, yKey);
        yKey += 15;
        if (yKey >= 60) {
          yKey = 15;
          xKey += 200;
        }
        peopleOnScreen.add(toPerson);
      }
      if (!peopleOnScreen.contains(currentMessage.from)) {
        Person fromPerson = currentMessage.from;
        fill(fromPerson.h, fromPerson.s, fromPerson.b, 200);
        text(fromPerson.ids.get(0), xKey, yKey);
        yKey += 15;
        if (yKey > 60) {
          yKey = 15;
          xKey += 200;
        }
        peopleOnScreen.add(fromPerson);
      }
    }
  }
  // Draw date
  if (messages.size() > 0) {
    fill(360);
    textSize(24);
    text(messages.get(messages.size() - 1).date(), width - 150, height - 30);
    frame++;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      speed = min(speed + 0.25, 15);
    } else if (keyCode == LEFT) {
      speed = max(speed - 0.25, 0);
    }
  }

  if (key == ' ') {
    speed = 0;
  }
}
