import argparse
import chats
import csv
import getpass
import sys

def validate_email(email):
  if email.count('/') > 0:
    email = email[email.find('/') + 1:]
    email = email.replace('_', '@')

  if email.count('@') > 0:
    host = email[email.find('@') + 1:]
    if host == 'groupchat.google.com' or host == 'public.talk.google.com':
      return ''
    else:
      return email
  return ''

if __name__ == "__main__":
  parser = argparse.ArgumentParser(
    description='Fetch gchat logs and output CSV')
  parser.add_argument('-u', '--username', help='Gmail username')
  parser.add_argument('-f', '--fetch',
    help='Fetch logs from gmail (This may take a while)', action="store_true")
  parser.add_argument('-d', '--dir', help='Directory to save logs to',
    default='chat-logs')
  parser.add_argument('-o', '--outfile', help='File to output CSV to',
    default='all-chats.csv')
  args = parser.parse_args()

  if args.fetch:
    if args.username:
      logger = chats.GChatLog(user=args.username, passwd=getpass.getpass())
      logger.import_chats(args.dir)
    else:
      print 'Provide a username with -u'
      sys.exit()

  csv_file = open(args.outfile, 'w')
  csv_writer = csv.writer(csv_file)
  csv_writer.writerow(('Timestamp','From','To','Source','Extra'))

  chatLogs = chats.read_chats(args.dir)

  for chat in chatLogs:
    for message in chat.messages:
      receiver = validate_email(message.receiver)
      sender = validate_email(message.sender)
      if receiver != '' and sender != '' and message.timestamp > 0:
        csv_writer.writerow((message.timestamp, message.sender,
                      message.receiver, 'gchat', message.body))

  csv_file.close()
