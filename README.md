
# STAGE 1: DEPLOY DOMAIN IAC PIPELINE
Main duty: Route53 + ACM

## PART 1: IAM DUTIES
- Github OIDC provider
- setting trusted policies
- role and policies creation


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

## DOMAIN AND SUBDOMAINS ARCHITECTURE
### projects in development phase:
- dev.tamayo.dev/absencesbo
- dev.tamayo.dev/absencesfo
- dev.tamayo.dev/myproject

### projects in testing phase:
- stg.tamayo.dev/absencesbo
- stg.tamayo.dev/absencesfo
- stg.tamayo.dev/myproject

### projects ready for production:
- apps.tamayo.dev/absencesbo
- apps.tamayo.dev/absencesfo
- apps.tamayo.dev/myproject

## DNS ROUTING
DNS/Route 53 only handles hostnames, not paths.
So Route 53 can route these:
- dev.tamayo.dev
- stg.tamayo.dev
- apps.tamayo.dev

But Route 53 cannot directly route these as separate DNS records:
- dev.tamayo.dev/absencesbo
- dev.tamayo.dev/absencesfo
- apps.tamayo.dev/myproject

The /absencesbo, /absencesfo, /myproject part is an HTTP path, so that routing belongs in:
ALB listener rules, or
NGINX / Traefik / Ingress inside k3s, or
API Gateway / CloudFront, depending on the stack.

### Recommended DNS Records
- dev.tamayo.dev   -> load balancer / ingress
- stg.tamayo.dev   -> load balancer / ingress
- apps.tamayo.dev  -> load balancer / ingress

### Operational note about DNS Record
You should not need to manually update name.com every time unless you destroy and recreate the Route 53 hosted zone.
If you keep the Route 53 hosted zone alive, the nameservers remain stable.

So ideally:
- Keep Route 53 hosted zone as long-lived/shared infrastructure.
- Keep ACM certificate as long-lived/shared infrastructure.
- Destroy/recreate app infra, load balancer, DNS app records as needed.
- Avoid destroying/recreating the hosted zone unless truly necessary.

If you destroy and recreate the hosted zone, AWS will likely assign a new set of Route 53 nameservers, and then yes, you must update name.com again

### SSL certificate
- tamayo.dev
- *.tamayo.dev

Item                    Provider        Used by your AWS infra?
Domain registration     name.com        Yes, name.com owns registration
DNS hosting             Route 53        Yes, after delegation
TLS certificate from name.com name.com  No, unless you manually install/import it
TLS certificate from ACM AWS            Yes, for ALB/NLB/API Gateway/etc.

AWS ACM certificate does not care whether name.com also gives you an SSL certificate.

Your TLS certificate is:
- Created and issued by AWS ACM
    - It is an AMAZON_ISSUED certificate.
    - It covers tamayo.dev and *.tamayo.dev.
- Not the certificate from name.com
    - name.com is only your domain registrar in this setup.
    - Route 53 is now your DNS host.
    - AWS ACM is your TLS certificate provider for the AWS-hosted app/load balancer.

### COMMANDS FOR DIAGNOSTIC
- dig NS tamayo.dev
- dig CNAME _somehash.tamayo.dev
- dig @8.8.8.8 CNAME _somehash.tamayo.dev
- dig @1.1.1.1 CNAME _somehash.tamayo.dev

# STAGE 2: DEPLOY NETWORKING IAC PIPELINE
Main duty: Deploy EC2/VPC/APP Host Infra

# STAGE 3: DEPLOY EDGE IAC:
Main duty: deploy Load Balancer + DNS Record


## SUMMARY

Layer                       Owns
- Registrar                   tamayo.dev registration only
- Route 53                    Hosted zone and DNS records for tamayo.dev
- ACM                         TLS cert for tamayo.dev and *.tamayo.dev
-  ALB/NLB                    uses the ACM certificate to serve HTTPS- 
- Load balancer / ingress     Host-based routing for dev, stg, apps
- App ingress rules           Path-based routing for /absencesbo, /absencesfo, /myproject
- App infra                   Project-specific deploy/destroy