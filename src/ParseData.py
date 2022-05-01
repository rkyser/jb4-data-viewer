import argparse
import datetime
from os.path import exists
import pprint
from Jb4CsvReader import Jb4CsvReader
from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS

parser = argparse.ArgumentParser(description='Import JB4 CSV to InfluxDB')
parser.add_argument('--file', type=str, required=True, help='JB4 CSV file')
parser.add_argument('--influxdb-bucket', type=str, help='Bucket to write JB4 data to')
parser.add_argument('--influxdb-config', type=str, help='Config file for influxdb client')
args = parser.parse_args()

csv_filepath = args.file
influxdb_config = args.influxdb_config
bucket = args.influxdb_bucket

if not exists(csv_filepath):
    print(f'no such csv file \"{csv_filepath}\"')
    exit(1)

if not exists(influxdb_config):
    print(f'no such influxdb client config file \"{influxdb_config}\"')
    exit(1)

client = InfluxDBClient.from_config_file(influxdb_config)
write_api = client.write_api(write_options=SYNCHRONOUS)

def format_my_nanos(nanos):
    dt = datetime.datetime.fromtimestamp(nanos / 1e9)
    return '{}{:03.0f}'.format(dt.strftime('%Y-%m-%dT%H:%M:%S.%f'), nanos % 1e3)

with open(csv_filepath, newline='') as csvfile:
    jb4reader = Jb4CsvReader(csvfile)
#    pprint.pprint(jb4reader.parameters)
    for sample in jb4reader:
        point = Point.from_dict({
            'measurement': 'sample',
            'tags': {
            },
            'fields': sample.dict(),
            'time': sample.timestamp_ns
        }, write_precision=WritePrecision.NS)
        write_api.write(bucket=bucket, record=point)

write_api.flush()
write_api.close()