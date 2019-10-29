Walkthrough portal experience of creating a cluster with virtual kubelet 
Go to the app that we are hosting on the kubernetes cluster (contoso ads)
Go to the live metrics stream of traffic on website hosted on the cluster
start load event in terminal
get pods --watch
go to dashboard to see all container instances
azure monitoring + grafana dashboard

To reset, we need to delete the deployment that creates all this load, and watch the pod count return to 1 or 0.
To clean-up, we need to delete the cluster