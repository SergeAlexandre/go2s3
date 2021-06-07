# go2s3

This is a small test program to exercice a security model on AWS using instance role and assume role switching.

Test buckets and permission are created by terraform (See `terraform` folder)

```
cd .../go2s3/terraform
terraform init
....
terraform apply
....
```

Of course, you must have valid AWS administrator credential to issue these commands

Then:

```
./setup/install.sh
```

Will create an appropriate python virtualenv.

```
. ./setup/activate.sh
```

Will activate it.

Then, you can exercise the small python code. The first parameter is a switch to an authentication method:
- none: No authentication at all (Use the instance role, if any)
- user1/2: Use a specific IAM account with explicit credential. These account must be created manually. (They are not part of the terraform manifest mantionned above.)
- single_gha1/2: Switch to such role

The second parameter is the target bucket name

```
# Using instance role will allow access to gha-common-1 bucket 
$ python py/main.py none gha-common-1
gha_common_content/xx.txt

# But not to gha1-primary-1 
$ python py/main.py none gha1-primary-1
ERROR: Unable to access bucket 'gha1-primary-1': An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied

# Nor gha2-primary-1
$ python py/main.py none gha2-primary-1
ERROR: Unable to access bucket 'gha2-primary-1': An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied

# Switching to single1_gha1 allow access to gha1-primary-1
$ python py/main.py single1_gha1  gha1-primary-1
gha1_primary1_content/xx.txt

# But not to gha2-primary-1 
$ python py/main.py single1_gha1  gha2-primary-1
ERROR: Unable to access bucket 'gha2-primary-1': An error occurred (AccessDenied) when calling the ListObjectsV2 operation: Access Denied

# Switching to single1_gha2 allow access to gha2-primary-1
$ python py/main.py single1_gha2  gha2-primary-1
gha1_primary2_content/xx.txt
```

