import argparse
import csv
import fileinput
import operator

if __name__ == "__main__":
  parser = argparse.ArgumentParser(
    description='Combine our generated CSVs into one')
  parser.add_argument('files', help='CSVs to combine',
    nargs='+')
  parser.add_argument('-o', '--outfile', help='File to output to',
    default='all.csv')
  args = parser.parse_args()

  with open(args.outfile, 'w+') as outfile:
    # Combine CSVs
    for line in fileinput.input(args.files):
      if not line.startswith('Timestamp'):
        outfile.write(line)

    # Sort data by timestamp
    outfile.seek(0)
    data = csv.reader(outfile)
    sortedlist = sorted(data, key=operator.itemgetter(0))

    # Overwrite unsorted content
    outfile.seek(0)
    fileWriter = csv.writer(outfile)
    fileWriter.writerow(('Timestamp','From','To','Source','Extra'))
    for row in sortedlist:
        fileWriter.writerow(row)
    outfile.truncate()
