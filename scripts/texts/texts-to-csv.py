import argparse
import csv
import sqlite3

# add this to timestamps from ios to get unix timestamp
UNIX_DATE_OFFSET = 978307200

parser = argparse.ArgumentParser(
  description='Generate CSV from messages backup db')
parser.add_argument('database', help='Path to your backup database')
parser.add_argument('number', help='Your phone number')
parser.add_argument('-o', '--outfile', help='File to output to',
    default='all-texts.csv')
args = parser.parse_args()

conn = sqlite3.connect(args.database)
cursor = conn.cursor()
cursor.execute('SELECT message.date,message.is_from_me,message.text,handle.id FROM \
      handle INNER JOIN message ON message.handle_id = handle.ROWID \
      ORDER BY message.date')

csv_file = open(args.outfile, 'w')
csv_writer = csv.writer(csv_file)
csv_writer.writerow(('Timestamp','From','To','Source','Extra'))

for row in cursor.fetchall():
  if row[1] == 1:
    receiver = row[3]
    sender = args.number
  else:
    sender = row[3]
    receiver = args.number

  if row[2] is not None:
    csv_writer.writerow((row[0] + UNIX_DATE_OFFSET, sender,
      receiver, 'iphone', row[2].encode('utf8')))

csv_file.close()