# Dragen AWS/LSF Hybrid Workflow

## Setup & Execution Guide

### 1. Launch Interactive Nextflow Job

Start an LSF interactive job with pre-mounted volumes and docker:

```bash
bsub -G compute-dspencer -Is -q general-interactive -R"select[mem>24000] rusage[mem=24000]" -M 24000000 -n 4 -a "docker(mdivr/nextflow:20230925)" /bin/bash -l
```

### 2. Set AWS Credentials

Configure your AWS credentials once per Nextflow environment:

```bash
nextflow secrets set AWS_ACCESS_KEY '<Your_Access_Key>'
nextflow secrets set AWS_SECRET_KEY '<Your_Secret_Key>'

# Verify that the secrets are correctly set
nextflow secrets list
```

### 3. Export Dragen License Credentials

Export the Dragen license credentials as environment variables:

```bash
export DRAGEN_USERNAME=<Username>
export DRAGEN_PASSWORD=<Password>
```

### 4. Workflow Execution

Execute the Nextflow workflow in your preferred mode:

**Hybrid AWS/LSF:**

```bash
NXF_HOME=${PWD}/.nextflow && \
nextflow run m-mahgoub/dragen-aws -r main --latest --dragen_username $DRAGEN_USERNAME --dragen_password $DRAGEN_PASSWORD -profile hybrid -bucket-dir s3://dspencer-dragen-data/tmp/ --outdir results
```

**AWS-only:**

```bash
NXF_HOME=${PWD}/.nextflow && \
nextflow run m-mahgoub/dragen-aws -r main --latest --dragen_username $DRAGEN_USERNAME --dragen_password $DRAGEN_PASSWORD -profile aws -bucket-dir s3://dspencer-dragen-data/tmp/ --outdir results
```

**LSF-only:**

```bash
NXF_HOME=${PWD}/.nextflow && \
nextflow run m-mahgoub/dragen-aws -r main --latest -profile ris --outdir results
```

Replace placeholders (`<Username>`, `<Password>`, `<Your_Access_Key>`, `<Your_Secret_Key>`) with actual values. Ensure AWS and LSF configurations are properly set before executing the workflows.
