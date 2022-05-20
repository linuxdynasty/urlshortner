# urlshortner

This project was done as a test, to see what I can accomplish. The goal of this project is to be able to create amnd deploy a urlshortner simple service.

## What has been done so far.

1. Created a simple urlshortner service using the python language.
2. Created a Docker image and pushed it to dockerhub https://hub.docker.com/repository/docker/linuxdynasty/urlshortner.
3. Created a `docker-compose.yml` file to test locally.
4. Created the terraform directory `terraform/envs/test` to deploy this service into an empty account. ( I have yet to test it)
5. Terraform will create the following resources.
   1. VPC
   2. Subnets
   3. Routing Tables
   4. RDS postgress db
   5. ALB
   6. ASG ( Will install docker and pull down the latest docker image and run it)
   7. Security Groups


## What would I change in order to make this into a fully functional service.

1. Integrate `statsd` into the urlshortner service.
2. In each route I would remove the logic from each route and place it into it's own function.
3. I would wrap a python decorator to capture the latency of each api.
4. I would also apply a `statsd` decorator around each function.
5. I would add a Elasticache cluster and utitlize caching, vs making each get call to the RDS db.
6. I would forward the api call latencies to cloudwatch and utilize those custom metrics to scale the urlshortner service.
7. I would also use pre and post lifecycle hooks in the ASG, to make sure that we are pulling the correct docker image vs the latest image.
8. I would use ECR vs dockerhub. ( I didn't want to spend more time than I already have oni this test :P )
9. Also, I would have used a CI/CD process for urlshortner deployments.
   1.  Jenkins/Github Action or something similiar.
   2.  Terraform would only manage the AWS resources.
   3.  Jenkins would probably use Ansible to deploy the tagged image, vs the latest image. Or leverage Lambda and Lifecyclehooks and Launch templates to make sure it uses the tagged image and when launched, the lambda will deploy to the new launch ec2 instance  the tagged image instead of latest.
