Create a service account for GitHub OIDC federation.

```console
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}" --project "${PROJECT_ID}"
```

`iam.serviceAccountKeys.create` permission is required for uploading public keys.
`roles/iam.serviceAccountKeyAdmin` (Service Account Key Admin) role can do this.

```console
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --role="roles/iam.serviceAccountKeyAdmin" \
    --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
```

Enables the service required for GitHub OIDC federation.

```console
gcloud services enable iamcredentials.googleapis.com --project "${PROJECT_ID}"
```

`iam.googleapis.com` is required for uploading public keys.

```console
gcloud services enable iam.googleapis.com --project "${PROJECT_ID}"
```

```console
gcloud iam workload-identity-pools create "gha-pool" --project="${PROJECT_ID}" --location="global" --display-name="Pool for GitHub Actions OIDC"
```

```
gcloud iam workload-identity-pools describe "gha-pool" --project="${PROJECT_ID}" --location="global" --format="value(name)"
```

```console
export WORKLOAD_IDENTITY_POOL_ID=projects/912487971903/locations/global/workloadIdentityPools/gha-pool
```

```console
gcloud iam workload-identity-pools providers create-oidc "gha-provider" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --workload-identity-pool="gha-pool" \
    --display-name="GitHub Actions OIDC provider" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
    --issuer-uri="https://token.actions.githubusercontent.com"
```

```console
export REPO="shogo82148/actions-auth-firebase-adminsdk"
```

```console
gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --project="${PROJECT_ID}" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${REPO}"
```

```console
gcloud iam workload-identity-pools providers describe "gha-provider" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --workload-identity-pool="gha-pool" \
    --format='value(name)'
```

reference: https://dev.classmethod.jp/articles/google-cloud-auth-with-workload-identity/
