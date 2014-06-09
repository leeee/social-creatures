class Message {
    Date timestamp;
    Person to;
    Person from;
    String extra;

    Source source;

    PVector position;
    float radius = 10;
    float timeRemaining = 255;

    Message(Person to, Person from, Source source, long timestamp) {
      this.to = to;
      this.from = from;
      this.source = source;
      this.timestamp = new Date(timestamp);

      position = new PVector();
      position.x = width;
      if (to == me) {
        position.y = from.y;
      } else {
        position.y = to.y;
      }
    }

    void draw() {
      position.x = map(timeRemaining, 0, 255, 0, width);
      if (timeRemaining > 0) {
        noStroke();
        fill(source.h, source.s, source.b, 200);
        ellipse(position.x, position.y, 15, 15);

        noFill();
        strokeWeight(5);
        strokeCap(SQUARE);
        stroke(to.h, to.s, to.b, 200);
        arc(position.x, position.y, 25, 25, 0, PI);
        stroke(from.h, from.s, from.b, 200);
        arc(position.x, position.y, 25, 25, PI, TWO_PI);

        timeRemaining -= speed;
      }
    }

    boolean isDead() {
      return timeRemaining <= 0;
    }

    String date() {
      SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/YY");
      return sdf.format(timestamp);
    }
}