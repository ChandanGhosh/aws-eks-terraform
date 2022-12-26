# aws-eks-terraform
A EKS deployment using terraform IaC using supported Ubuntu AMI instead of default Amazon Optimized Linux AMI Id. It automatically detect and fetch the latest Ubuntu AMI for the region and the kubernetes version getting deployed. It takes care of provisioning worker node using node template in autoscale group, auto join the node to the cluster, creates kubernetes namespace, docker registry secret etc. It also provision gateway load balancer, endpoint services, automatically fetch node instance id and create load balancer target group for demonstration.

