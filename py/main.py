import sys
import boto3
import pprint

# https://docs.aws.amazon.com/fr_fr/IAM/latest/UserGuide/id_roles_use_switch-role-api.html

# sa
#AWS_ACCESS_KEY="AKIATDQ7BWJB4GKUIMNS"
#AWS_SECRET_ACCESS_KEY="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"
#AWS_SESSION_TOKEN=None

# techaccount1
AWS_ACCESS_KEY="AKIATDQ7BWJB57OHHHHB"
AWS_SECRET_ACCESS_KEY="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"
AWS_SESSION_TOKEN=None

def main():
    print("Allo...")
    pp = pprint.PrettyPrinter(indent=2)

    session = boto3.session.Session(aws_access_key_id=AWS_ACCESS_KEY, aws_secret_access_key=AWS_SECRET_ACCESS_KEY, aws_session_token=AWS_SESSION_TOKEN)

    s3 = session.client('s3')

    if False:
        response = s3.list_buckets()
        #pp.pprint(response)
        print(response["Buckets"][0]["Name"])

    response2 = s3.list_objects_v2(Bucket='gha2-primary-1', FetchOwner=False)
    for entry in response2["Contents"]:
        print(entry["Key"])
    #pp.pprint(response2["Contents"])

    return 0


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    sys.exit(main())
