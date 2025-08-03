import boto3
import os
import time
import subprocess
import json

sqs_url = os.getenv("SQS_QUEUE_URL")
s3_bucket = os.getenv("S3_BUCKET_NAME")

sqs = boto3.client('sqs')

def poll_messages():
    while True:
        response = sqs.receive_message(
            QueueUrl=sqs_url,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=20
        )

        messages = response.get('Messages', [])
        if messages:
            for message in messages:
                try:
                    body = json.loads(message['Body'])
                    print("Full message body:", json.dumps(body, indent=2))

                    s3_record = body['Records'][0]['s3']
                    key = s3_record['object']['key']

                    print(f"Received file: {key}")
                    os.environ['S3_OBJECT_KEY'] = key
                    subprocess.run(["python", "main.py"])

                    sqs.delete_message(
                        QueueUrl=sqs_url,
                        ReceiptHandle=message['ReceiptHandle']
                    )
                except (KeyError, json.JSONDecodeError) as e:
                    print(f"Error parsing SQS message body: {e}. Skipping message.")
                    sqs.delete_message(
                        QueueUrl=sqs_url,
                        ReceiptHandle=message['ReceiptHandle']
                    )
        else:
            print("No messages, polling again...")

if __name__ == "__main__":
    poll_messages()

