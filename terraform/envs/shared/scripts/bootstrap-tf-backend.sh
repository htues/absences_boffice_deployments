#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${LOG_FILE:-terraform-deployment.log}"
AWS_REGION="${AWS_REGION:-us-east-2}"
BUCKET_NAME="${BUCKET_NAME:-}"

log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

require_env() {
  if [[ -z "${BUCKET_NAME}" ]]; then
    log_message "ERROR: BUCKET_NAME is not set. Provide it via environment (e.g., BUCKET_NAME=... ./bootstrap-tf-backend.sh verify)"
    exit 1
  fi
}

verify_aws_connection() {
  log_message "Verifying AWS credentials..."
  aws sts get-caller-identity >/dev/null 2>&1 || {
    log_message "ERROR: AWS credentials not configured correctly (sts:GetCallerIdentity failed)"
    return 1
  }
}

bucket_exists() {
  aws s3api head-bucket --bucket "$BUCKET_NAME" >/dev/null 2>&1
}

create_bucket() {
  log_message "Creating S3 bucket: $BUCKET_NAME (region: $AWS_REGION)"

  if [[ "$AWS_REGION" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" >/dev/null
  else
    aws s3api create-bucket \
      --bucket "$BUCKET_NAME" \
      --region "$AWS_REGION" \
      --create-bucket-configuration "LocationConstraint=$AWS_REGION" >/dev/null
  fi

  log_message "✅ Bucket created: $BUCKET_NAME"
}

harden_bucket_defaults() {
  log_message "Applying bucket safety defaults (idempotent)..."

  # Block all public access (strong default for tfstate buckets)
   aws s3api put-public-access-block \
     --bucket "$BUCKET_NAME" \
     --public-access-block-configuration \
     "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" || log_message "WARNING: Failed to apply public access block"

   # Enable versioning (recommended for tfstate recovery)
   aws s3api put-bucket-versioning \
     --bucket "$BUCKET_NAME" \
     --versioning-configuration "Status=Enabled" || log_message "WARNING: Failed to enable versioning"

   # Default encryption (SSE-S3). If you require KMS, adjust to SSE-KMS.
   aws s3api put-bucket-encryption \
     --bucket "$BUCKET_NAME" \
     --server-side-encryption-configuration \
     '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}' || log_message "WARNING: Failed to apply encryption"

   log_message "✅ Bucket defaults applied"
}

ensure_s3_bucket_exists() {
  log_message "Ensuring S3 state bucket exists: $BUCKET_NAME"
  if bucket_exists; then
    log_message "✅ Bucket exists: $BUCKET_NAME"
  else
    log_message "ℹ️ Bucket not found; will create it"
    create_bucket
  fi

  harden_bucket_defaults
}

verify_prerequisites() {
  require_env
  log_message "Running pre-deployment checks (region: $AWS_REGION, bucket: $BUCKET_NAME)..."

  verify_aws_connection
  ensure_s3_bucket_exists

  log_message "✅ Prerequisites completed"
}

main() {
  local command="${1:-}"
  case "$command" in
    verify)
      verify_prerequisites
      ;;
    *)
      echo "Usage: $0 verify"
      echo "Environment variables:"
      echo "  BUCKET_NAME (required)   e.g. myapp-terraform-state"
      echo "  AWS_REGION (optional)    default: us-east-2"
      echo "  LOG_FILE (optional)      default: terraform-deployment.log"
      exit 1
      ;;
  esac
}

main "$@"