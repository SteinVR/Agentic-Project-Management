---
description: Setup CD - Generate GitHub Actions workflow for deployment to staging
---

## User Input

```text
$ARGUMENTS
```

## Instructions

You are now the **Principal Engineer** in CD Setup mode.

**Read your role:** @.apm/AGENT_DROLES/Principal-Engineer.md

**Read the architecture:** @ARCHITECTURE.md

**Read the workflow:** @WORKFLOW.md

---

## Your Task

Create or update GitHub Actions CD workflow for deployment to staging.

### Workflow

1. **Analyze project** - Determine:
   - Deployment target (Docker, server, cloud provider)
   - Build process (Docker build, npm build, etc.)
   - Staging environment configuration
   - E2E test framework (Playwright, Cypress, etc.)

2. **Generate workflow file** - Create `.github/workflows/cd.yml`:
   - Trigger: `workflow_dispatch` (manual) and/or after CI success on main
   - Build artifacts (Docker image, bundle, package)
   - Deploy to staging environment
   - Run E2E tests against staging
   - Report results

3. **Deployment options** - Based on ARCHITECTURE.md:
   - Docker: build image, push to registry, deploy container
   - Static site: build, deploy to hosting (Vercel, Netlify, S3)
   - Server: SSH deploy, restart service

4. **Verify** - Ensure workflow is valid and deployment credentials are referenced via secrets

5. **Report** - Use `AGENT_REPORTS/E2E_REPORT_TEMPLATE.md` format for E2E results

### Output

Create file: `.github/workflows/cd.yml`

Example structure (adapt to project):

```yaml
name: CD - Deploy to Staging

on:
  workflow_dispatch:
  workflow_run:
    workflows: ["CI"]
    types: [completed]
    branches: [main]

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' || github.event_name == 'workflow_dispatch' }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Build
        run: [build command]
      
      - name: Deploy to Staging
        run: [deploy command]
        env:
          STAGING_URL: ${{ secrets.STAGING_URL }}
          DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
      
      - name: Run E2E Tests
        run: [e2e test command]
        env:
          BASE_URL: ${{ secrets.STAGING_URL }}
      
      - name: Upload E2E Results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: e2e-results
          path: [e2e results path]
```

### Important Notes

- This workflow does NOT deploy to production
- Production deployment requires separate manual process
- Ensure secrets are configured in repository settings:
  - `STAGING_URL`
  - `DEPLOY_TOKEN`
  - Other environment-specific secrets

---

## Additional Context

$ARGUMENTS
