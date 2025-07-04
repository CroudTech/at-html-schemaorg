# GCP Infra changes

## Compute Engine

List of chnages made manually or via the cli that need to be captured later as IAC:
- [ ] Enabled compute engine API
- [ ] Create sa-dev-schemaorg-compute service account
- [ ] Create compute engine instance
```
# This code is compatible with Terraform 4.25.0 and versions that are backward compatible to 4.25.0.
# For information about validating this Terraform code, see https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration

resource "google_compute_instance" "at-html-schemaorg-20250704-114813" {
  boot_disk {
    auto_delete = true
    device_name = "at-html-schemaorg-20250704-114813"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250610"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-x86-template-1-4-0"
  }

  machine_type = "e2-medium"

  metadata = {
    enable-osconfig = "TRUE"
  }

  name = "at-html-schemaorg-20250704-114813"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/prj-croud-dev-schema-org/regions/europe-west2/subnetworks/default"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "sa-dev-schemaorg-compute@prj-croud-dev-schema-org.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server"]
  zone = "europe-west2-a"
}

module "ops_agent_policy" {
  source          = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project         = "prj-croud-dev-schema-org"
  zone            = "europe-west2-a"
  assignment_id   = "goog-ops-agent-v2-x86-template-1-4-0-europe-west2-a"
  agents_rule = {
    package_state = "installed"
    version = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-x86-template-1-4-0"
      }
    }]
  }
}
```
- [ ] Add firewall rules
```
gcloud compute --project=prj-croud-dev-schema-org firewall-rules create schemaorg-allow-http --description="Duplicate of the default http rule allowing a specific port" --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:8080 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute --project=prj-croud-dev-schema-org firewall-rules create schemaorg-allow-https --description="Duplicate of default https rule for a specific port" --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:8080 --source-ranges=0.0.0.0/0 --target-tags=https-server

```

## App Engine

- [ ] Create app engine via `gcloud app create`
- [ ] GCS bucket creation:
   - prj-croud-dev-schema-org.appspot.com
   - staging.prj-croud-dev-schema-org.appspot.com
- [ ] GCS file uploads
- [ ] Grant default app engine SA object viewer on the two buckets
```
╔════════════════════════════════════════════════════════════╗
╠═ Uploading 3118 files to Google Cloud Storage             ═╣
╚════════════════════════════════════════════════════════════╝
File upload done.
Updating service [default]...
failed.

```