## DNS, HOSTED ZONE AND SSL

- name.com = registrar only
- Route 53 = DNS hosting
- ACM = SSL certificate
- Terraform = manages Route 53 + ACM + validation + ALB

## Should the certificate be destroyed with infra?

Careful here.
For shared/domain infra, I’d treat ACM and hosted zone as shared foundational resources, not app-level disposable resources.
Meaning:
- Dev EC2/app/load balancer can be destroyed often.
- Route 53 hosted zone and ACM certificate should usually live longer.
- Don’t accidentally destroy them every time you tear down an app environment.