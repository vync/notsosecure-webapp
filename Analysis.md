#Vulnerabilty description
The chosen vulnerability for the webserver is a reflected cross-site scripting,  
which can be triggered by engineering the query string paramater 'id'. A user  
is sent a malicious URL in the form of 
> http://notsosecure-webserver.example.com/?id=<script>alert(1)</script>
which the server happily reflects on the contents delivered to the user browser  
where it is then executed as valid javascript. If the server was making use of  
a user session stored as a cookie or any other sensitive data, these could be  
stolen by an attacker and directed at a different origin.

#Infrastructure Overview
The AWS infrastructure consists of:
1. a WAFv2 web acl
2. a WAFv2 rule group
3. an EKS deployment, service and ingress triplet.
4. a Application Load Balancer (which is automatically created by the ingress  
   controller.
5. a WAFv2 web acl association
6. a WAFv2 web acl logging configuration, which makes use of a Kinesis Firehose  
   delivery stream, which it has been assumed to be created by a separate 
   ci/cd pipeline.

The web acl is configured to default block all traffic which is not matching  
the associated rule statement. The rule statement makes use of negated logic to  
only allow traffic where xss patterns are not detected on the url query string.  
This prevents the vulnerabilty from being triggered.

The traffic hitting the web acl is logged to the kinesis firehose delivery  
stream with no filtering applied to it. It can therefore be further analysed  
and potentially automatically alerted on. Cloudwatch metrics are also available  
as per the chosen web acl and rule configurations, so they can also be  
leveraged in detections.

#Deployment pipeline
The pipeline does in order:
1. checkout the code from the source control manager system.
2. build the image for the vulnerable webserver 
3. CAUTION: This step has actually not been implemented. The pipeline should  
   have a stage to publish the built image to a container registry - an ECR  
   repository would do. Typically this stage can make use of boiler plate code  
   from other existing deployment pipelines.
4. apply the k8s resources. This happens before the rest of the infrastructure  
   is created by terraform because the terraform configuration refers to the  
   application load balancer which is created by the ingress controller. This  
   implies that when the webserver is created for the first time, it is  
   actually vulnerable for a short period of time.
5. plan and apply terraform resources.

#Improvements
1. The webserver should be built as a distroless image to reduce impact in case  
   of server takeover. This is not possible by expoliting an XSS vulnerability  
   but would be in case of a remote code execution vulnerability.
2. The rule group can be extended to cover more fields to match as the  
   application evolves.
3. The k8s and terraform resources could make better use of common variables:  
   the k8s yaml files should be templated using a templating engine such as 
   kustomize or helm.
