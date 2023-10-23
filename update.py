import boto3

# AWS credentials
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"

# Hosted zone ID
hosted_zone_id = "YOUR_HOSTED_ZONE_ID"

# Record details
record_name = input("Enter the record name (e.g., example.com): ")
record_type = input("Enter the record type (e.g., A): ")
new_record_value = input("Enter the new record value (e.g., new IP address): ")

# Create a Route 53 client
client = boto3.client('route53', aws_access_key_id=aws_access_key,
                      aws_secret_access_key=aws_secret_key)

# Get the existing record set
response = client.list_resource_record_sets(
    HostedZoneId=hosted_zone_id,
    StartRecordName=record_name,
    StartRecordType=record_type
)

# Extract the existing record
existing_record = None
for record_set in response['ResourceRecordSets']:
    if record_set['Name'] == record_name and record_set['Type'] == record_type:
        existing_record = record_set
        break

# Check if the record exists
if existing_record is not None:
    # Update the existing record
    existing_record['ResourceRecords'] = [{'Value': new_record_value}]
    response = client.change_resource_record_sets(
        HostedZoneId=hosted_zone_id,
        ChangeBatch={
            'Changes': [
                {
                    'Action': 'UPSERT',
                    'ResourceRecordSet': existing_record
                }
            ]
        }
    )
    print(f"Record updated: {record_name} {record_type} => {new_record_value}")
else:
    print(f"Record not found: {record_name} {record_type}")
