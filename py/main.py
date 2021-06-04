import sys
import boto3
import pprint

# https://docs.aws.amazon.com/fr_fr/IAM/latest/UserGuide/id_roles_use_switch-role-api.html



def main():
    print("Allo...")
    pp = pprint.PrettyPrinter(indent=2)

    if len(sys.argv) != 3:
        print("USAGE: main.py <credential> <bucketName>")
        sys.exit(1)

    credential = sys.argv[1]
    bucket_name = sys.argv[2]

    if credential == "sa":
        session = boto3.session.Session(aws_access_key_id="AKIATDQ7BWJB4GKUIMNS", aws_secret_access_key="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")
    elif credential == "techaccount1":
        session = boto3.session.Session(aws_access_key_id="AKIATDQ7BWJB57OHHHHB", aws_secret_access_key="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")
    elif credential == "none":
        session = boto3.session.Session()
    elif credential == "single1_gha1" or credential == "single1_gha2":
        sts_client = boto3.client('sts')
        accountId = sts_client.get_caller_identity().get('Account')
        #print(accountId)
        assumed_role_object = sts_client.assume_role(
            RoleArn="arn:aws:iam::{}:role/{}".format(accountId, credential),
            RoleSessionName = "{}_session".format(credential)
        )
        credentials = assumed_role_object['Credentials']
        session = boto3.session.Session(aws_access_key_id=credentials['AccessKeyId'], aws_secret_access_key=credentials['SecretAccessKey'], aws_session_token=credentials['SessionToken'])
    else:
        print("ERROR: credential must be one of 'sa' or 'techaccount1'")
        sys.exit(2)

    s3 = session.client('s3')

    # response = s3.list_buckets()
    # #pp.pprint(response)
    # print(response["Buckets"][0]["Name"])

    response2 = s3.list_objects_v2(Bucket=bucket_name, FetchOwner=False)
    for entry in response2["Contents"]:
        print(entry["Key"])
    #pp.pprint(response2["Contents"])

    return 0


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    sys.exit(main())
