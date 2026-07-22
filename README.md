
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

### SSL certificate
- tamayo.dev
- *.tamayo.dev

## SUMMARY

Layer                       Owns
- Registrar                   tamayo.dev registration only
- Route 53                    Hosted zone and DNS records for tamayo.dev
- ACM                         TLS cert for tamayo.dev and *.tamayo.dev
- Load balancer / ingress     Host-based routing for dev, stg, apps
- App ingress rules           Path-based routing for /absencesbo, /absencesfo, /myproject
- App infra                   Project-specific deploy/destroy