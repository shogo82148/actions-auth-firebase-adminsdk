# actions-auth-firebase-adminsdk

Use google workload identity to run Firebase Admin SDK script

## Synopsis

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - uses: shogo82148/actions-auth-firebase-adminsdk
        with:
          workload_identity_provider: "projects/{{PROJECT_NUMBER}}/locations/global/workloadIdentityPools/{{IDENTITY_POOL}}/providers/{{IDENTITY_PROVIDER}}"
          service_account: "{{ACCOUNT_NAME}}@{{PROJECT_ID}}.iam.gserviceaccount.com"

      - run: npm install firebase-admin
      # Do something with Firebase Admin Node.js SDK
```

## Motivation

The action is workaround for [firebase/firebase-admin-node#1377](https://github.com/firebase/firebase-admin-node/issues/1377).
If you're using this Action to authenticate the Firebase Admin Node.js SDK,
you must authenticate with a service account key since Workload Identity Federation is not yet supported.

The action create a temporary key pair and register the public key using Workload Identity Federation.
And then, it passes the the temporary private key to your application.
After your application is finished, it de-register the public key from the service account.

It is inspired by https://gist.github.com/dylanenabled/5fd0128afe362343cf2a8e9628c4218e.
