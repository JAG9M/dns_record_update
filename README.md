# dns_record_update
this repo contains python code to update route 53 record and jenkins pipeline script to run the python code.

TASK.
Writing a python code to update records in route 53.
Using this code create a jenkins pipeline job that with run automatically when ever someone has a new record.
NB: If jenkins resides in a pod in K8s remember to create a service account to enable it talk to aws route 53.Also create an IAM role in 
aws and related policies to enable them talk together.
